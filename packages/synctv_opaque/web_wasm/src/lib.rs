use opaque_ke::argon2::Argon2;
use opaque_ke::ciphersuite::CipherSuite;
use opaque_ke::{
    ClientLogin, ClientLoginFinishParameters, ClientRegistration,
    ClientRegistrationFinishParameters, CredentialResponse, RegistrationResponse,
};
use rand::SeedableRng;
use rand_chacha::ChaCha20Rng;
use sha2::Sha512;
use std::alloc::{alloc, dealloc, Layout};
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

fn seed_rng(seed_ptr: *const u8, seed_len: usize) -> Result<ChaCha20Rng, String> {
    let seed = unsafe { input_bytes(seed_ptr, seed_len, "seed") }?;
    if seed.len() < 32 {
        return Err(format!("seed too short: {} < 32", seed.len()));
    }
    let mut bytes = [0u8; 32];
    bytes.copy_from_slice(&seed[..32]);
    Ok(ChaCha20Rng::from_seed(bytes))
}

fn run(operation: impl FnOnce() -> Result<SyncTvOpaqueResult, String>) -> SyncTvOpaqueResult {
    match catch_unwind(AssertUnwindSafe(operation)) {
        Ok(Ok(result)) => result,
        Ok(Err(message)) => SyncTvOpaqueResult::err(message),
        Err(_) => SyncTvOpaqueResult::err("OPAQUE operation panicked"),
    }
}

#[no_mangle]
pub extern "C" fn synctv_wasm_alloc(len: usize) -> *mut u8 {
    if len == 0 {
        return ptr::null_mut();
    }
    let layout = match Layout::array::<u8>(len) {
        Ok(layout) => layout,
        Err(_) => return ptr::null_mut(),
    };
    unsafe { alloc(layout) }
}

#[no_mangle]
pub unsafe extern "C" fn synctv_wasm_dealloc(ptr: *mut u8, len: usize) {
    if ptr.is_null() || len == 0 {
        return;
    }
    if let Ok(layout) = Layout::array::<u8>(len) {
        unsafe { dealloc(ptr, layout) };
    }
}

#[no_mangle]
pub unsafe extern "C" fn synctv_wasm_free_result(ptr: *mut SyncTvOpaqueResult) {
    if ptr.is_null() {
        return;
    }
    let result = unsafe { Box::from_raw(ptr) };
    free_buffer(result.error);
    free_buffer(result.first);
    free_buffer(result.second);
}

unsafe fn free_buffer(buffer: SyncTvOpaqueBuffer) {
    if buffer.ptr.is_null() {
        return;
    }
    unsafe {
        drop(Vec::from_raw_parts(buffer.ptr, buffer.len, buffer.len));
    }
}

#[no_mangle]
pub extern "C" fn synctv_wasm_registration_start(
    password_ptr: *const u8,
    password_len: usize,
    seed_ptr: *const u8,
    seed_len: usize,
) -> *mut SyncTvOpaqueResult {
    let result = run(|| {
        let password = unsafe { input_bytes(password_ptr, password_len, "password") }?;
        let mut rng = seed_rng(seed_ptr, seed_len)?;
        let start = ClientRegistration::<SyncTvOpaqueCipherSuite>::start(&mut rng, password)
            .map_err(|error| format!("Failed to start OPAQUE registration: {error}"))?;
        Ok(SyncTvOpaqueResult::ok(
            start.message.serialize().to_vec(),
            start.state.serialize().to_vec(),
        ))
    });
    Box::into_raw(Box::new(result))
}

#[no_mangle]
pub extern "C" fn synctv_wasm_registration_finish(
    password_ptr: *const u8,
    password_len: usize,
    state_ptr: *const u8,
    state_len: usize,
    response_ptr: *const u8,
    response_len: usize,
    seed_ptr: *const u8,
    seed_len: usize,
) -> *mut SyncTvOpaqueResult {
    let result = run(|| {
        let password = unsafe { input_bytes(password_ptr, password_len, "password") }?;
        let state_bytes = unsafe { input_bytes(state_ptr, state_len, "registration state") }?;
        let response_bytes =
            unsafe { input_bytes(response_ptr, response_len, "registration response") }?;
        let state =
            ClientRegistration::<SyncTvOpaqueCipherSuite>::deserialize(state_bytes)
                .map_err(|error| format!("Invalid OPAQUE registration state: {error}"))?;
        let response = RegistrationResponse::deserialize(response_bytes)
            .map_err(|error| format!("Invalid OPAQUE registration response: {error}"))?;
        let mut rng = seed_rng(seed_ptr, seed_len)?;
        let finish = state
            .finish(
                &mut rng,
                password,
                response,
                ClientRegistrationFinishParameters::default(),
            )
            .map_err(|error| format!("Failed to finish OPAQUE registration: {error}"))?;
        Ok(SyncTvOpaqueResult::ok(
            finish.message.serialize().to_vec(),
            Vec::new(),
        ))
    });
    Box::into_raw(Box::new(result))
}

#[no_mangle]
pub extern "C" fn synctv_wasm_login_start(
    password_ptr: *const u8,
    password_len: usize,
    seed_ptr: *const u8,
    seed_len: usize,
) -> *mut SyncTvOpaqueResult {
    let result = run(|| {
        let password = unsafe { input_bytes(password_ptr, password_len, "password") }?;
        let mut rng = seed_rng(seed_ptr, seed_len)?;
        let start = ClientLogin::<SyncTvOpaqueCipherSuite>::start(&mut rng, password)
            .map_err(|error| format!("Failed to start OPAQUE login: {error}"))?;
        Ok(SyncTvOpaqueResult::ok(
            start.message.serialize().to_vec(),
            start.state.serialize().to_vec(),
        ))
    });
    Box::into_raw(Box::new(result))
}

#[no_mangle]
pub extern "C" fn synctv_wasm_login_finish(
    password_ptr: *const u8,
    password_len: usize,
    state_ptr: *const u8,
    state_len: usize,
    response_ptr: *const u8,
    response_len: usize,
    seed_ptr: *const u8,
    seed_len: usize,
) -> *mut SyncTvOpaqueResult {
    let result = run(|| {
        let password = unsafe { input_bytes(password_ptr, password_len, "password") }?;
        let state_bytes = unsafe { input_bytes(state_ptr, state_len, "login state") }?;
        let response_bytes = unsafe { input_bytes(response_ptr, response_len, "login response") }?;
        let state = ClientLogin::<SyncTvOpaqueCipherSuite>::deserialize(state_bytes)
            .map_err(|error| format!("Invalid OPAQUE login state: {error}"))?;
        let response = CredentialResponse::deserialize(response_bytes)
            .map_err(|error| format!("Invalid OPAQUE credential response: {error}"))?;
        let mut rng = seed_rng(seed_ptr, seed_len)?;
        let finish = state
            .finish(
                &mut rng,
                password,
                response,
                ClientLoginFinishParameters::default(),
            )
            .map_err(|error| format!("Failed to finish OPAQUE login: {error}"))?;
        Ok(SyncTvOpaqueResult::ok(
            finish.message.serialize().to_vec(),
            finish.session_key.to_vec(),
        ))
    });
    Box::into_raw(Box::new(result))
}

#[cfg(test)]
mod tests {
    use super::*;
    use opaque_ke::{
        CredentialFinalization, CredentialRequest, RegistrationRequest, RegistrationUpload,
        ServerLogin, ServerLoginParameters, ServerRegistration, ServerSetup,
    };

    fn bytes(buffer: &SyncTvOpaqueBuffer) -> Vec<u8> {
        if buffer.ptr.is_null() || buffer.len == 0 {
            return Vec::new();
        }
        unsafe { slice::from_raw_parts(buffer.ptr, buffer.len).to_vec() }
    }

    fn copy_result(ptr: *mut SyncTvOpaqueResult) -> (Vec<u8>, Vec<u8>) {
        let result = unsafe { &*ptr };
        assert_eq!(result.status, 0);
        let value = (bytes(&result.first), bytes(&result.second));
        unsafe { synctv_wasm_free_result(ptr) };
        value
    }

    #[test]
    fn seeded_client_messages_complete_server_registration_and_login() {
        let password = b"correct horse battery staple";
        let credential_identifier = b"synctv:user:alice";
        let mut server_rng = ChaCha20Rng::from_seed([7; 32]);
        let server_setup = ServerSetup::<SyncTvOpaqueCipherSuite>::new(&mut server_rng);
        let registration_seed = [1u8; 32];
        let finish_seed = [2u8; 32];
        let login_seed = [3u8; 32];
        let login_finish_seed = [4u8; 32];

        let (registration_request, registration_state) = copy_result(
            synctv_wasm_registration_start(
                password.as_ptr(),
                password.len(),
                registration_seed.as_ptr(),
                registration_seed.len(),
            ),
        );
        let server_registration = ServerRegistration::<SyncTvOpaqueCipherSuite>::start(
            &server_setup,
            RegistrationRequest::deserialize(&registration_request).unwrap(),
            credential_identifier,
        )
        .unwrap();
        let registration_response = server_registration.message.serialize();
        let (registration_upload, _) = copy_result(synctv_wasm_registration_finish(
            password.as_ptr(),
            password.len(),
            registration_state.as_ptr(),
            registration_state.len(),
            registration_response.as_ptr(),
            registration_response.len(),
            finish_seed.as_ptr(),
            finish_seed.len(),
        ));
        let password_file = ServerRegistration::<SyncTvOpaqueCipherSuite>::finish(
            RegistrationUpload::<SyncTvOpaqueCipherSuite>::deserialize(&registration_upload)
                .unwrap(),
        );

        let (credential_request, login_state) = copy_result(synctv_wasm_login_start(
            password.as_ptr(),
            password.len(),
            login_seed.as_ptr(),
            login_seed.len(),
        ));
        let server_login = ServerLogin::start(
            &mut server_rng,
            &server_setup,
            Some(password_file),
            CredentialRequest::deserialize(&credential_request).unwrap(),
            credential_identifier,
            ServerLoginParameters::default(),
        )
        .unwrap();
        let credential_response = server_login.message.serialize();
        let (credential_finalization, session_key) = copy_result(synctv_wasm_login_finish(
            password.as_ptr(),
            password.len(),
            login_state.as_ptr(),
            login_state.len(),
            credential_response.as_ptr(),
            credential_response.len(),
            login_finish_seed.as_ptr(),
            login_finish_seed.len(),
        ));
        let server_finish = server_login
            .state
            .finish(
                CredentialFinalization::<SyncTvOpaqueCipherSuite>::deserialize(
                    &credential_finalization,
                )
                .unwrap(),
                ServerLoginParameters::default(),
            )
            .unwrap();
        assert_eq!(session_key, server_finish.session_key.to_vec());
    }
}
