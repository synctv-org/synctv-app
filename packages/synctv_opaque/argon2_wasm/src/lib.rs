use argon2::{Algorithm, Argon2, Params, Version};
use std::alloc::{alloc, dealloc, Layout};
use std::slice;

// Keep these parameters identical to opaque-ke's Argon2::default().
const MEMORY_KIB: u32 = 19456;
const ITERATIONS: u32 = 2;
const PARALLELISM: u32 = 1;
const OUTPUT_LENGTH: usize = 64;
const SALT_LENGTH: usize = 16;

fn derive(input: &[u8], output: &mut [u8]) -> Result<(), &'static str> {
    if input.len() != 64 || output.len() != OUTPUT_LENGTH {
        return Err("invalid argon2 buffer length");
    }
    let params = Params::new(
        MEMORY_KIB,
        ITERATIONS,
        PARALLELISM,
        Some(OUTPUT_LENGTH),
    )
    .map_err(|_| "invalid argon2 parameters")?;
    let argon2 = Argon2::new(Algorithm::Argon2id, Version::V0x13, params);
    argon2
        .hash_password_into(input, &[0; SALT_LENGTH], output)
        .map_err(|_| "argon2 derivation failed")
}

#[no_mangle]
pub extern "C" fn synctv_argon2_alloc(len: usize) -> *mut u8 {
    if len == 0 {
        return std::ptr::null_mut();
    }
    let layout = match Layout::array::<u8>(len) {
        Ok(layout) => layout,
        Err(_) => return std::ptr::null_mut(),
    };
    unsafe { alloc(layout) }
}

/// # Safety
///
/// `ptr` must have been returned by `synctv_argon2_alloc` with the same `len`.
#[no_mangle]
pub unsafe extern "C" fn synctv_argon2_dealloc(ptr: *mut u8, len: usize) {
    if ptr.is_null() || len == 0 {
        return;
    }
    if let Ok(layout) = Layout::array::<u8>(len) {
        unsafe { dealloc(ptr, layout) };
    }
}

#[no_mangle]
pub extern "C" fn synctv_argon2_derive(
    input_ptr: *const u8,
    input_len: usize,
    output_ptr: *mut u8,
) -> i32 {
    if input_ptr.is_null() || output_ptr.is_null() {
        return 1;
    }
    let input = unsafe { slice::from_raw_parts(input_ptr, input_len) };
    let output = unsafe { slice::from_raw_parts_mut(output_ptr, OUTPUT_LENGTH) };
    i32::from(derive(input, output).is_err())
}
