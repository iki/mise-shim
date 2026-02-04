::|Usage: reshim [options] [shims-path=%LocalAppData%\mise\shims]
::|
::|Copy executable shim `mise-shim.exe` to .exe shim in mise shim-path
::|for all .cmd shims that do not already have .exe shim there
::|
::|Remove all existing .exe shims in mise shim-path
::|that do not have matching .cmd shim there (were uninstalled)
::|
::|Options:
::|  -f       Overwrite existing .exe shims. Use after rebuild
::|  -h       Show this help and exit.
::|
@echo off

setlocal
if "%~1"=="-h" for /f "usebackq delims=| tokens=1*" %%l in ("%~f0") do if "%%~l"=="::" (echo.%%~m) else exit /b 0
if "%~1"=="-f" (shift && set force=true) else set force=

set shim=mise-shim.exe
set shims=%~1
if not defined shims set shims=%LocalAppData%\mise\shims

if not exist "%shim%" echo Shim executable not found: "%shim%" >&2 && echo Run "build.cmd" to build it >&2 && exit /b 1
if not exist "%shims%" echo Mise shims not found: "%shims%" >&2 && echo Install mise, or run "%~nx0 shims-path >&2 && exit /b 1
if not exist "%shims%\*.cmd" echo No mise shims found: "%shims%\*.cmd" >&2 && exit /b 0

if defined force for %%s in (%shims%\*.cmd) do echo %%~ns && copy /b /y "%shim%" "%%~dpns.exe" >nul || exit /b 1
if not defined force for %%s in (%shims%\*.cmd) do if not exist "%%~dpns.exe" echo %%~ns && copy /b /y "%shim%" "%%~dpns.exe" >nul || exit /b 1

for %%s in (%shims%\*.exe) do if not exist "%%~dpns.cmd" echo - %%~ns && del /f "%%~s" >nul || exit /b 1
