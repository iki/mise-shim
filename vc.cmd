@echo off
setlocal
call "%ProgramFiles(x86)%\Microsoft Visual Studio\18\BuildTools\Common7\Tools\vsdevcmd\core\vsdevcmd_start.bat"
if not "%~1"=="" %*
