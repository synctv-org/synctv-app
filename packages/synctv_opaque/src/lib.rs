use opaque_ke::argon2::Argon2;
use opaque_ke::ciphersuite::CipherSuite;
use opaque_ke::{
    ClientLogin, ClientLoginFinishParameters, ClientRegistration,
    ClientRegistrationFinishParameters, CredentialResponse, RegistrationResponse,
};
use rand::rngs::OsRng;
use sha2::Sha512;
use std::panic::{catch_unwind, AssertUnwindSafe};
use std::ptr;
use std::slice;

struct SyncTvOpaqueCipherSuite;

impl CipherSuite for SyncTvOpaqueCipherSuite {
    type OprfCs = opaque_ke::Ristretto255;
    type KeyExchange = opaque_ke::TripleDh<opaque_ke::Ristretto255, Sha512>;
    type Ksf = Argon2<'static>;
}

#[repr(C)]
pub struct SyncTvOpaqueBuffer {
    ptr: *mut u8,
    len: usize,
}

impl SyncTvOpaqueBuffer {
    fn empty() -> Self {
        Self {
            ptr: ptr::null_mut(),
            len: 0,
        }
    }

    fn from_vec(bytes: Vec<u8>) -> Self {
        let mut boxed = bytes.into_boxed_slice();
        let len = boxed.len();
        let ptr = boxed.as_mut_ptr();
        std::mem::forget(boxed);
        Self { ptr, len }
    }
}

#[repr(C)]
pub struct SyncTvOpaqueResult {
    status: i32,
    error: SyncTvOpaqueBuffer,
    first: SyncTvOpaqueBuffer,
    second: SyncTvOpaqueBuffer,
}

impl SyncTvOpaqueResult {
    fn ok(first: Vec<u8>, second: Vec<u8>) -> Self {
        Self {
            status: 0,
            error: SyncTvOpaqueBuffer::empty(),
            first: SyncTvOpaqueBuffer::from_vec(first),
            second: SyncTvOpaqueBuffer::from_vec(second),
        }
    }

    fn err(message: impl Into<String>) -> Self {
        Self {
            status: 1,
            error: SyncTvOpaqueBuffer::from_vec(message.into().into_bytes()),
            first: SyncTvOpaqueBuffer::empty(),
            second: SyncTvOpaqueBuffer::empty(),
        }
    }
}

unsafe fn input_bytes<'a>(ptr: *const u8, len: usize, name: &str) -> Result<&'a [u8], String> {
    if len == 0 {
        return Ok(&[]);
    }
    if ptr.is_null() {
        return Err(format!("{name} pointer is null"));
    }
    Ok(slice::from_raw_parts(ptr, len))
}

fn run_ffi(operation: impl FnOnce() -> Result<SyncTvOpaqueResult, String>) -> SyncTvOpaqueResult {
    match catch_unwind(AssertUnwindSafe(operation)) {
        Ok(Ok(result)) => result,
        Ok(Err(message)) => SyncTvOpaqueResult::err(message),
        Err(_) => SyncTvOpaqueResult::err("OPAQUE operation panicked"),
    }
}

#[no_mangle]
pub extern "C" fn synctv_opaque_registration_start(
    password_ptr: *const u8,
    password_len: usize,
) -> SyncTvOpaqueResult {
    run_ffi(|| {
        let password = unsafe { input_bytes(password_ptr, password_len, "password") }?;
        let mut rng = OsRng;
        let start = ClientRegistration::<SyncTvOpaqueCipherSuite>::start(&mut rng, password)
            .map_err(|e| format!("Failed to start OPAQUE registration: {e}"))?;
        Ok(SyncTvOpaqueResult::ok(
            start.message.serialize().to_vec(),
            start.state.serialize().to_vec(),
        ))
    })
}

#[no_mangle]
pub extern "C" fn synctv_opaque_registration_finish(
    password_ptr: *const u8,
    password_len: usize,
    state_ptr: *const u8,
    state_len: usize,
    response_ptr: *const u8,
    response_len: usize,
) -> SyncTvOpaqueResult {
    run_ffi(|| {
        let password = unsafe { input_bytes(password_ptr, password_len, "password") }?;
        let state_bytes = unsafe { input_bytes(state_ptr, state_len, "registration state") }?;
        let response_bytes =
            unsafe { input_bytes(response_ptr, response_len, "registration response") }?;
        let state =
            opaque_ke::ClientRegistration::<SyncTvOpaqueCipherSuite>::deserialize(state_bytes)
                .map_err(|e| format!("Invalid OPAQUE registration state: {e}"))?;
        let response = RegistrationResponse::deserialize(response_bytes)
            .map_err(|e| format!("Invalid OPAQUE registration response: {e}"))?;
        let mut rng = OsRng;
        let finish = state
            .finish(
                &mut rng,
                password,
                response,
                ClientRegistrationFinishParameters::default(),
            )
            .map_err(|e| format!("Failed to finish OPAQUE registration: {e}"))?;
        Ok(SyncTvOpaqueResult::ok(
            finish.message.serialize().to_vec(),
            Vec::new(),
        ))
    })
}

#[no_mangle]
pub extern "C" fn synctv_opaque_login_start(
    password_ptr: *const u8,
    password_len: usize,
) -> SyncTvOpaqueResult {
    run_ffi(|| {
        let password = unsafe { input_bytes(password_ptr, password_len, "password") }?;
        let mut rng = OsRng;
        let start = ClientLogin::<SyncTvOpaqueCipherSuite>::start(&mut rng, password)
            .map_err(|e| format!("Failed to start OPAQUE login: {e}"))?;
        Ok(SyncTvOpaqueResult::ok(
            start.message.serialize().to_vec(),
            start.state.serialize().to_vec(),
        ))
    })
}

#[no_mangle]
pub extern "C" fn synctv_opaque_login_finish(
    password_ptr: *const u8,
    password_len: usize,
    state_ptr: *const u8,
    state_len: usize,
    response_ptr: *const u8,
    response_len: usize,
) -> SyncTvOpaqueResult {
    run_ffi(|| {
        let password = unsafe { input_bytes(password_ptr, password_len, "password") }?;
        let state_bytes = unsafe { input_bytes(state_ptr, state_len, "login state") }?;
        let response_bytes = unsafe { input_bytes(response_ptr, response_len, "login response") }?;
        let state = opaque_ke::ClientLogin::<SyncTvOpaqueCipherSuite>::deserialize(state_bytes)
            .map_err(|e| format!("Invalid OPAQUE login state: {e}"))?;
        let response = CredentialResponse::deserialize(response_bytes)
            .map_err(|e| format!("Invalid OPAQUE credential response: {e}"))?;
        let mut rng = OsRng;
        let finish = state
            .finish(
                &mut rng,
                password,
                response,
                ClientLoginFinishParameters::default(),
            )
            .map_err(|e| format!("Failed to finish OPAQUE login: {e}"))?;
        Ok(SyncTvOpaqueResult::ok(
            finish.message.serialize().to_vec(),
            finish.session_key.to_vec(),
        ))
    })
}

#[no_mangle]
pub extern "C" fn synctv_opaque_free_buffer(buffer: SyncTvOpaqueBuffer) {
    if buffer.ptr.is_null() {
        return;
    }
    unsafe {
        drop(Vec::from_raw_parts(buffer.ptr, buffer.len, buffer.len));
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use opaque_ke::{
        CredentialFinalization, CredentialRequest, RegistrationRequest, RegistrationUpload,
        ServerLogin, ServerLoginParameters, ServerRegistration, ServerSetup,
    };
    use rand_chacha::rand_core::SeedableRng;
    use rand_chacha::ChaCha20Rng;

    fn bytes(buffer: &SyncTvOpaqueBuffer) -> Vec<u8> {
        if buffer.ptr.is_null() || buffer.len == 0 {
            return Vec::new();
        }
        unsafe { slice::from_raw_parts(buffer.ptr, buffer.len).to_vec() }
    }

    fn free_result(result: SyncTvOpaqueResult) {
        synctv_opaque_free_buffer(result.error);
        synctv_opaque_free_buffer(result.first);
        synctv_opaque_free_buffer(result.second);
    }

    #[test]
    fn client_messages_complete_server_registration_and_login() {
        let password = b"correct horse battery staple";
        let credential_identifier = b"synctv:user:alice";
        let mut server_rng = ChaCha20Rng::from_seed([7; 32]);
        let server_setup = ServerSetup::<SyncTvOpaqueCipherSuite>::new(&mut server_rng);

        let registration_start =
            synctv_opaque_registration_start(password.as_ptr(), password.len());
        assert_eq!(registration_start.status, 0);
        let registration_request_bytes = bytes(&registration_start.first);
        let registration_state = bytes(&registration_start.second);

        let server_registration_start = ServerRegistration::<SyncTvOpaqueCipherSuite>::start(
            &server_setup,
            RegistrationRequest::deserialize(&registration_request_bytes).unwrap(),
            credential_identifier,
        )
        .unwrap();
        let registration_response = server_registration_start.message.serialize();

        let registration_finish = synctv_opaque_registration_finish(
            password.as_ptr(),
            password.len(),
            registration_state.as_ptr(),
            registration_state.len(),
            registration_response.as_ptr(),
            registration_response.len(),
        );
        assert_eq!(registration_finish.status, 0);
        let registration_upload = bytes(&registration_finish.first);
        let password_file = ServerRegistration::<SyncTvOpaqueCipherSuite>::finish(
            RegistrationUpload::<SyncTvOpaqueCipherSuite>::deserialize(&registration_upload)
                .unwrap(),
        );

        let login_start = synctv_opaque_login_start(password.as_ptr(), password.len());
        assert_eq!(login_start.status, 0);
        let credential_request = bytes(&login_start.first);
        let login_state = bytes(&login_start.second);

        let server_login_start = ServerLogin::start(
            &mut server_rng,
            &server_setup,
            Some(password_file),
            CredentialRequest::deserialize(&credential_request).unwrap(),
            credential_identifier,
            ServerLoginParameters::default(),
        )
        .unwrap();
        let credential_response = server_login_start.message.serialize();

        let login_finish = synctv_opaque_login_finish(
            password.as_ptr(),
            password.len(),
            login_state.as_ptr(),
            login_state.len(),
            credential_response.as_ptr(),
            credential_response.len(),
        );
        assert_eq!(login_finish.status, 0);
        let credential_finalization = bytes(&login_finish.first);
        let client_session_key = bytes(&login_finish.second);
        let server_finish = server_login_start
            .state
            .finish(
                CredentialFinalization::<SyncTvOpaqueCipherSuite>::deserialize(
                    &credential_finalization,
                )
                .unwrap(),
                ServerLoginParameters::default(),
            )
            .unwrap();
        assert_eq!(client_session_key, server_finish.session_key.to_vec());

        free_result(registration_start);
        free_result(registration_finish);
        free_result(login_start);
        free_result(login_finish);
    }
}
