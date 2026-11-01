//! Native WebTransport bridge for the SyncTV app.
//!
//! One C ABI surface, driven by Dart FFI:
//! - [`synctv_wt_connect`] establishes a WebTransport session and opens the
//!   bidirectional control stream (length-prefixed frames, 64 KiB cap, the
//!   same wire format as the web adapter);
//! - [`synctv_wt_send`] hands frames to the control stream's writer task;
//! - [`synctv_wt_recv`] returns the next frame from any stream — the control
//!   stream plus the per-observation unidirectional push streams the server
//!   opens for multi-stream sessions — blocking until one arrives (call it
//!   from a reader isolate);
//! - [`synctv_wt_close`] tears the session down;
//! - [`synctv_wt_last_error`] retrieves the last error message.
//!
//! The tokio runtime is owned by the library; every call blocks the calling
//! thread only.

#![allow(clippy::missing_safety_doc)]

use std::collections::HashMap;
use std::io;
use std::sync::atomic::{AtomicI64, Ordering};
use std::sync::{Arc, Mutex, OnceLock};

use tokio::io::AsyncWriteExt;
use tokio::runtime::Runtime;
use tokio::sync::mpsc;
use wtransport::ClientConfig;
use wtransport::Endpoint;

/// Maximum frame payload (matches the server's cap and the web adapter).
pub const MAX_FRAME_BYTES: usize = 64 * 1024;

/// Writer channel capacity: bounds how far the app can outrun the QUIC
/// stream before sends begin to block.
const WRITER_QUEUE: usize = 64;

/// Downlink frame queue shared by the control stream and every push stream.
const FRAME_QUEUE: usize = 128;

/// Upper bound on the connect + control-stream setup. The Dart side times
/// out too, but its timeout cannot cancel this native call, so without this
/// bound a stalled endpoint would pin the connecting isolate.
const CONNECT_TIMEOUT: std::time::Duration = std::time::Duration::from_secs(10);

fn runtime() -> &'static Runtime {
    static RUNTIME: OnceLock<Runtime> = OnceLock::new();
    RUNTIME.get_or_init(|| Runtime::new().expect("tokio runtime starts"))
}

fn sessions() -> &'static Mutex<HashMap<i64, Arc<Session>>> {
    static SESSIONS: OnceLock<Mutex<HashMap<i64, Arc<Session>>>> = OnceLock::new();
    SESSIONS.get_or_init(|| Mutex::new(HashMap::new()))
}

fn next_handle() -> i64 {
    static NEXT: AtomicI64 = AtomicI64::new(1);
    NEXT.fetch_add(1, Ordering::Relaxed)
}

struct Session {
    /// Held to keep the QUIC connection alive; dropped on close, which ends
    /// the stream tasks.
    #[allow(dead_code)]
    connection: wtransport::Connection,
    /// Feeds the control stream writer task; dropping signals finish.
    writer: mpsc::Sender<Vec<u8>>,
    /// Frames from the control stream and every push stream.
    frames: tokio::sync::Mutex<mpsc::Receiver<Vec<u8>>>,
}

thread_local! {
    static LAST_ERROR: std::cell::RefCell<Option<String>> = const { std::cell::RefCell::new(None) };
}

fn set_error(message: impl Into<String>) {
    LAST_ERROR.with(|slot| *slot.borrow_mut() = Some(message.into()));
}

/// Reads one length-prefixed frame; `Ok(None)` on clean close.
async fn read_frame(stream: &mut wtransport::RecvStream) -> io::Result<Option<Vec<u8>>> {
    let mut header = [0u8; 4];
    match stream.read_exact(&mut header).await {
        Ok(()) => {}
        Err(wtransport::error::StreamReadExactError::FinishedEarly(_)) => {
            return Ok(None)
        }
        Err(wtransport::error::StreamReadExactError::Read(error)) => {
            return Err(io::Error::other(error))
        }
    }
    let length = u32::from_be_bytes(header) as usize;
    if length > MAX_FRAME_BYTES {
        return Err(io::Error::new(
            io::ErrorKind::InvalidData,
            "frame exceeds size cap",
        ));
    }
    let mut payload = vec![0u8; length];
    match stream.read_exact(&mut payload).await {
        Ok(()) => {}
        Err(wtransport::error::StreamReadExactError::FinishedEarly(_)) => {
            return Err(io::Error::new(
                io::ErrorKind::UnexpectedEof,
                "frame truncated by close",
            ));
        }
        Err(wtransport::error::StreamReadExactError::Read(error)) => {
            return Err(io::Error::other(error))
        }
    }
    Ok(Some(payload))
}

/// Pumps frames from one receive stream into the shared downlink queue. The
/// task ends when the stream closes or the queue's receiver is gone.
async fn pump_stream(
    mut stream: wtransport::RecvStream,
    frames: mpsc::Sender<Vec<u8>>,
) {
    loop {
        match read_frame(&mut stream).await {
            Ok(Some(payload)) => {
                if frames.send(payload).await.is_err() {
                    return;
                }
            }
            Ok(None) | Err(_) => return,
        }
    }
}

/// Accepts server-initiated unidirectional push streams (per-observation
/// lanes of multi-stream sessions) and pumps each into the shared queue.
async fn pump_push_streams(connection: wtransport::Connection, frames: mpsc::Sender<Vec<u8>>) {
    loop {
        match connection.accept_uni().await {
            Ok(stream) => {
                let frames = frames.clone();
                tokio::spawn(pump_stream(stream, frames));
            }
            Err(_) => return,
        }
    }
}

/// Writes frames from the app onto the control stream; finishing the stream
/// when the session closes.
async fn drive_writer(mut send: wtransport::SendStream, mut writer: mpsc::Receiver<Vec<u8>>) {
    while let Some(payload) = writer.recv().await {
        let mut frame = Vec::with_capacity(4 + payload.len());
        frame.extend_from_slice(&(payload.len() as u32).to_be_bytes());
        frame.extend_from_slice(&payload);
        if send.write_all(&frame).await.is_err() || send.flush().await.is_err() {
            return;
        }
    }
    let _ = send.finish().await;
}

fn build_config(cert_hash: Option<[u8; 32]>) -> wtransport::ClientConfig {
    let builder = ClientConfig::builder().with_bind_default();
    match cert_hash {
        Some(hash) => {
            builder
                .with_server_certificate_hashes([wtransport::tls::Sha256Digest::new(hash)])
                .build()
        }
        None => builder.with_native_certs().build(),
    }
}

/// Connects a WebTransport session to `url` (UTF-8 `https://…`) and opens
/// the control stream. `cert_hash`, when 32 bytes, pins the server
/// certificate by SHA-256 (self-signed deployments); otherwise system trust
/// roots apply. Server-initiated unidirectional push streams are served
/// automatically and multiplexed into the same receive queue. Returns a
/// positive session handle or -1 on failure (see [`synctv_wt_last_error`]).
#[no_mangle]
pub unsafe extern "C" fn synctv_wt_connect(
    url: *const u8,
    url_len: usize,
    cert_hash: *const u8,
    cert_hash_len: usize,
) -> i64 {
    let url = match std::str::from_utf8(std::slice::from_raw_parts(url, url_len)) {
        Ok(url) => url.to_string(),
        Err(error) => {
            set_error(format!("url is not UTF-8: {error}"));
            return -1;
        }
    };
    let cert_hash = if cert_hash_len == 32 && !cert_hash.is_null() {
        let mut digest = [0u8; 32];
        digest.copy_from_slice(std::slice::from_raw_parts(cert_hash, 32));
        Some(digest)
    } else {
        None
    };

    let result = runtime().block_on(async {
        let connect = async {
            let endpoint = Endpoint::client(build_config(cert_hash))
                .map_err(io::Error::other)?;
            let connection = endpoint
                .connect(&url)
                .await
                .map_err(io::Error::other)?;
            let (send, recv) = connection
                .open_bi()
                .await
                .map_err(io::Error::other)?
                .await
                .map_err(io::Error::other)?;
            io::Result::Ok((connection, send, recv))
        };
        match tokio::time::timeout(CONNECT_TIMEOUT, connect).await {
            Ok(result) => result,
            Err(_) => Err(io::Error::new(
                io::ErrorKind::TimedOut,
                "WebTransport connect timed out",
            )),
        }
    });
    match result {
        Ok((connection, send, recv)) => {
            let (writer_tx, writer_rx) = mpsc::channel(WRITER_QUEUE);
            let (frames_tx, frames_rx) = mpsc::channel(FRAME_QUEUE);

            tokio::spawn(drive_writer(send, writer_rx));
            tokio::spawn(pump_stream(recv, frames_tx.clone()));
            tokio::spawn(pump_push_streams(connection.clone(), frames_tx));

            let handle = next_handle();
            sessions().lock().expect("session map").insert(
                handle,
                Arc::new(Session {
                    connection,
                    writer: writer_tx,
                    frames: tokio::sync::Mutex::new(frames_rx),
                }),
            );
            handle
        }
        Err(error) => {
            set_error(format!("WebTransport connect failed: {error}"));
            -1
        }
    }
}

/// Sends one frame payload (length prefix added here). 0 on success, -1 on
/// failure.
#[no_mangle]
pub unsafe extern "C" fn synctv_wt_send(handle: i64, buf: *const u8, len: usize) -> i32 {
    let Some(session) = sessions().lock().expect("session map").get(&handle).cloned() else {
        set_error("unknown session handle");
        return -1;
    };
    if len > MAX_FRAME_BYTES {
        set_error("frame exceeds size cap");
        return -1;
    }
    let payload = std::slice::from_raw_parts(buf, len).to_vec();

    let result = runtime().block_on(session.writer.send(payload));
    match result {
        Ok(()) => 0,
        Err(_) => {
            set_error("WebTransport send failed: session closed");
            -1
        }
    }
}

/// Receives the next frame payload into `buf` (`cap` bytes), blocking until
/// a complete frame is available from any stream. Returns the payload
/// length, -1 when the session closed or failed, -2 when the buffer is too
/// small.
#[no_mangle]
pub unsafe extern "C" fn synctv_wt_recv(handle: i64, buf: *mut u8, cap: usize) -> i32 {
    let Some(session) = sessions().lock().expect("session map").get(&handle).cloned() else {
        set_error("unknown session handle");
        return -1;
    };
    let result = runtime().block_on(async {
        let mut frames = session.frames.lock().await;
        frames.recv().await
    });
    match result {
        Some(payload) => {
            if payload.len() > cap {
                set_error("recv buffer too small");
                return -2;
            }
            std::ptr::copy_nonoverlapping(payload.as_ptr(), buf, payload.len());
            payload.len() as i32
        }
        None => {
            set_error("session closed by peer");
            -1
        }
    }
}

/// Closes a session and releases its handle. Safe on unknown handles.
#[no_mangle]
pub extern "C" fn synctv_wt_close(handle: i64) {
    if let Some(session) = sessions().lock().expect("session map").remove(&handle) {
        // Dropping the Arc ends the connection and with it the stream tasks;
        // finishing the control stream first gives the peer a clean close.
        let writer = session.writer.clone();
        runtime().block_on(async {
            drop(writer);
            // The writer task owns the stream; give it a beat to finish.
            tokio::time::sleep(std::time::Duration::from_millis(10)).await;
        });
    }
}

/// Copies the last error message into `buf` (truncating to `cap`); returns
/// the copied length.
#[no_mangle]
pub unsafe extern "C" fn synctv_wt_last_error(buf: *mut u8, cap: usize) -> i32 {
    let message = LAST_ERROR.with(|slot| slot.borrow().clone()).unwrap_or_default();
    if cap == 0 || buf.is_null() {
        return message.len() as i32;
    }
    let mut copied = message.len().min(cap);
    // Respect char boundaries when truncating.
    while copied > 0 && !message.is_char_boundary(copied) {
        copied -= 1;
    }
    std::ptr::copy_nonoverlapping(message.as_ptr(), buf, copied);
    copied as i32
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn unknown_handle_errors_are_reported() {
        unsafe {
            assert_eq!(synctv_wt_send(999, std::ptr::null(), 0), -1);
            assert_eq!(synctv_wt_recv(999, std::ptr::null_mut(), 0), -1);
            let mut buffer = [0u8; 256];
            let length = synctv_wt_last_error(buffer.as_mut_ptr(), buffer.len());
            assert!(length > 0);
            let text = String::from_utf8_lossy(&buffer[..length as usize]).to_string();
            assert!(text.contains("unknown session handle"), "{text}");
        }
        synctv_wt_close(999);
    }

    #[test]
    fn connect_failure_reports_an_error() {
        unsafe {
            let url = b"https://127.0.0.1:1/wt/rooms/x";
            let handle = synctv_wt_connect(
                url.as_ptr(),
                url.len(),
                std::ptr::null(),
                0,
            );
            assert_eq!(handle, -1);
            let mut buffer = [0u8; 512];
            let length = synctv_wt_last_error(buffer.as_mut_ptr(), buffer.len());
            let text = String::from_utf8_lossy(&buffer[..length as usize]).to_string();
            assert!(
                text.contains("WebTransport connect failed"),
                "unexpected error text: {text}"
            );
        }
    }
}
