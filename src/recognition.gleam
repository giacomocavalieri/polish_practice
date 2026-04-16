pub type Recognition

@external(javascript, "./recognition_ffi.mjs", "new_")
pub fn new(language: String) -> Result(Recognition, Nil)

@external(javascript, "./recognition_ffi.mjs", "start")
pub fn start(recognition: Recognition) -> Nil

@external(javascript, "./recognition_ffi.mjs", "stop")
pub fn stop(recognition: Recognition) -> Nil

@external(javascript, "./recognition_ffi.mjs", "on_start")
pub fn on_start(recognition: Recognition, do: fn() -> a) -> Nil

@external(javascript, "./recognition_ffi.mjs", "on_end")
pub fn on_end(recognition: Recognition, do: fn() -> a) -> Nil

@external(javascript, "./recognition_ffi.mjs", "on_result")
pub fn on_result(recognition: Recognition, do: fn(String) -> a) -> Nil
