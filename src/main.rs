use std::env;
use std::process::Command;

fn main() {
    // Only run on Windows
    if cfg!(not(target_os = "windows")) {
        eprintln!("This shim is designed for Windows only.");
        std::process::exit(1);
    }

    // 1. Get current executable path
    let exe_path = env::current_exe()
        .expect("Failed to retrieve the current process path.");
    
    // 2. Extract name without .exe extension
    let exe_name = exe_path
        .file_stem()
        .and_then(|s| s.to_str())
        .expect("Could not determine a valid name for this executable.");

    let args: Vec<String> = env::args().collect();

    // 3. Execute mise x -- <exe_name> <args>
    let status = Command::new("mise")
        .arg("x")
        .arg("--")
        .arg(exe_name) 
        .args(&args[1..])
        .status()
        .expect("Failed to launch 'mise'. Is it installed and in your PATH?");

    std::process::exit(status.code().unwrap_or(1));
}