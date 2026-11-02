//! Security-audit regression tests for the native WebTransport bridge.
//!
//! Each test runs a loopback WebTransport server on 127.0.0.1 (self-signed
//! identity pinned by certificate hash) and pins one fixed behavior:
//! - `connect_and_close_reclaims_the_session`: session tasks are spawned in
//!   the runtime context and close() tears the QUIC connection down;
//! - `send_stall_is_bounded_and_fails_the_session`: a stalled control stream
//!   cannot block the calling thread indefinitely;
//! - `connect_timeout_is_bounded_below_the_dart_deadline`: an endpoint that
//!   never completes the handshake gives up natively, below the Dart
//!   deadline.

use std::net::{IpAddr, Ipv4Addr, SocketAddr};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{mpsc, Arc};
use std::time::{Duration, Instant};

use synctv_webtransport::{
    synctv_wt_close, synctv_wt_connect, synctv_wt_last_error, synctv_wt_send,
};

/// Spawns a loopback WebTransport server that accepts one session, never
/// reads its streams, and reports the connection's lifetime through the
/// returned flag.
fn spawn_stalling_server(keep_alive: Duration) -> (u16, [u8; 32], Arc<AtomicBool>) {
    let (ready_tx, ready_rx) = mpsc::channel::<(u16, [u8; 32])>();
    let alive = Arc::new(AtomicBool::new(false));
    let alive_for_server = alive.clone();
    std::thread::Builder::new()
        .name("wt-test-server".into())
        .spawn(move || {
            let runtime = tokio::runtime::Builder::new_current_thread()
                .enable_all()
                .build()
                .expect("server runtime builds");
            runtime.block_on(async move {
                let identity = wtransport::Identity::self_signed_builder()
                    .subject_alt_names(["localhost", "127.0.0.1", "::1"])
                    .from_now_utc()
                    .validity_days(7)
                    .build()
                    .expect("identity builds");
                let hash: [u8; 32] = *identity
                    .certificate_chain()
                    .as_ref()
                    .first()
                    .expect("leaf certificate present")
                    .hash()
                    .as_ref();
                let config = wtransport::ServerConfig::builder()
                    .with_bind_address(SocketAddr::new(IpAddr::V4(Ipv4Addr::LOCALHOST), 0))
                    .with_identity(identity)
                    .keep_alive_interval(Some(keep_alive))
                    .build();
                let endpoint = wtransport::Endpoint::server(config).expect("binds loopback");
                let port = endpoint.local_addr().expect("local address").port();
                ready_tx
                    .send((port, hash))
                    .expect("ready channel stays open");
                let incoming = endpoint.accept().await;
                let request = incoming.await.expect("session request arrives");
                let session = request.accept().await.expect("session accepts");
                alive_for_server.store(true, Ordering::SeqCst);
                // Hold the session open without reading any stream.
                let _ = session.closed().await;
                alive_for_server.store(false, Ordering::SeqCst);
            });
        })
        .expect("server thread spawns");
    let (port, hash) = ready_rx.recv().expect("server becomes ready");
    (port, hash, alive)
}

fn last_error_text() -> String {
    let mut buffer = [0u8; 512];
    let length = unsafe { synctv_wt_last_error(buffer.as_mut_ptr(), buffer.len()) };
    String::from_utf8_lossy(&buffer[..length.max(0) as usize]).to_string()
}

fn wait_until_false(flag: &AtomicBool, timeout: Duration) -> bool {
    let deadline = Instant::now() + timeout;
    while flag.load(Ordering::SeqCst) && Instant::now() < deadline {
        std::thread::sleep(Duration::from_millis(100));
    }
    !flag.load(Ordering::SeqCst)
}

fn connect_loopback(port: u16, hash: [u8; 32], label: &str) -> i64 {
    let url = format!("https://127.0.0.1:{port}/wt/rooms/{label}");
    let url_bytes = url.as_bytes();
    unsafe {
        synctv_wt_connect(
            url_bytes.as_ptr(),
            url_bytes.len(),
            hash.as_ptr(),
            hash.len(),
        )
    }
}

/// F04 + F05: connect must spawn its session tasks inside the runtime
/// context (spawning after `block_on` returned aborts), and close() must
/// close the QUIC connection so the peer observes the disconnect instead of
/// the session tasks keeping it alive forever.
#[test]
fn connect_and_close_reclaims_the_session() {
    let (port, hash, alive) = spawn_stalling_server(Duration::from_secs(3));

    let handle = connect_loopback(port, hash, "close-reclaim");
    assert!(handle > 0, "connect failed: {}", last_error_text());

    // One frame through the writer proves the spawned writer task runs.
    let payload = [0x5au8; 1024];
    let send_result = unsafe { synctv_wt_send(handle, payload.as_ptr(), payload.len()) };
    assert_eq!(send_result, 0, "send failed: {}", last_error_text());

    synctv_wt_close(handle);

    // The handle is gone: later sends refuse immediately.
    let send_after = unsafe { synctv_wt_send(handle, payload.as_ptr(), payload.len()) };
    assert_eq!(send_after, -1);
    assert!(
        last_error_text().contains("unknown session handle"),
        "{}",
        last_error_text()
    );

    // Decisive for the teardown leak: the server sees the connection close
    // (close() sent the QUIC CONNECTION_CLOSE instead of the parked tasks
    // holding their cloned handles forever).
    assert!(
        wait_until_false(&alive, Duration::from_secs(10)),
        "close() must tear the QUIC connection down for the peer"
    );
}

/// F06: a peer that stops reading the control stream must not pin the
/// calling thread: the send fails after the bounded wait, and the session is
/// failed so later calls refuse immediately.
#[test]
fn send_stall_is_bounded_and_fails_the_session() {
    let (port, hash, alive) = spawn_stalling_server(Duration::from_secs(3));

    let handle = connect_loopback(port, hash, "send-stall");
    assert!(handle > 0, "connect failed: {}", last_error_text());

    let payload = [0x5au8; 60 * 1024];
    let started = Instant::now();
    let mut sends = 0u32;
    let mut error_text = String::new();
    while started.elapsed() < Duration::from_secs(20) {
        let result = unsafe { synctv_wt_send(handle, payload.as_ptr(), payload.len()) };
        if result != 0 {
            error_text = last_error_text();
            break;
        }
        sends += 1;
    }
    assert!(
        !error_text.is_empty(),
        "send must fail once the control stream stalls ({sends} sends succeeded)"
    );
    assert!(
        error_text.contains("timed out"),
        "stalled send must report the bounded timeout: {error_text}"
    );
    assert!(
        started.elapsed() < Duration::from_secs(20),
        "send must be bounded, not block the calling thread"
    );

    // The timed-out session is failed and removed: the next call refuses
    // immediately instead of pinning the caller again.
    let refused_at = Instant::now();
    let send_after = unsafe { synctv_wt_send(handle, payload.as_ptr(), payload.len()) };
    assert_eq!(send_after, -1);
    assert!(refused_at.elapsed() < Duration::from_secs(1));
    assert!(
        last_error_text().contains("unknown session handle"),
        "{}",
        last_error_text()
    );

    synctv_wt_close(handle);
    assert!(wait_until_false(&alive, Duration::from_secs(10)));
}

/// F13 (native half): the native connect bound sits below the Dart deadline,
/// so an endpoint that never completes the handshake produces a native
/// failure the Dart late-arrival reaper can rely on, never a silent session.
#[test]
fn connect_timeout_is_bounded_below_the_dart_deadline() {
    let identity = wtransport::Identity::self_signed_builder()
        .subject_alt_names(["localhost", "127.0.0.1", "::1"])
        .from_now_utc()
        .validity_days(7)
        .build()
        .expect("identity builds");
    let hash: [u8; 32] = *identity
        .certificate_chain()
        .as_ref()
        .first()
        .expect("leaf certificate present")
        .hash()
        .as_ref();
    // A bound-but-silent UDP endpoint: QUIC Initials disappear into its
    // receive buffer, so the handshake can never complete.
    let silent = std::net::UdpSocket::bind("127.0.0.1:0").expect("binds loopback");
    let port = silent.local_addr().expect("local address").port();
    std::thread::spawn(move || {
        // Hold the socket open for the duration of the test.
        std::thread::sleep(Duration::from_secs(30));
        drop(silent);
    });

    let started = Instant::now();
    let handle = connect_loopback(port, hash, "connect-timeout");
    let elapsed = started.elapsed();
    assert_eq!(handle, -1);
    let error_text = last_error_text();
    assert!(
        error_text.contains("connect failed"),
        "unexpected error text: {error_text}"
    );
    // The native bound is 9.5 s; the Dart default deadline is 10 s. Pin the
    // ordering with margin for slow CI loopback.
    assert!(
        elapsed >= Duration::from_secs(9) && elapsed <= Duration::from_secs(10),
        "native connect bound must stay below the 10 s Dart deadline (took {elapsed:?})"
    );
}
