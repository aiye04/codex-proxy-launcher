@echo off
setlocal EnableDelayedExpansion

if "%~1"=="" (
  echo Usage:
  echo   start-with-proxy.cmd http://127.0.0.1:7890 command [args...]
  echo.
  echo Examples:
  echo   start-with-proxy.cmd http://127.0.0.1:7890 codex
  echo   start-with-proxy.cmd socks5://127.0.0.1:7890 npm install
  exit /b 2
)

set "PROXY=%~1"
set "LAUNCH_CMD=%*"
set "LAUNCH_CMD=!LAUNCH_CMD:* =!"
shift /1

if "%~1"=="" (
  echo Missing command to launch.
  exit /b 2
)

set "HTTP_PROXY=%PROXY%"
set "HTTPS_PROXY=%PROXY%"
set "ALL_PROXY=%PROXY%"
set "http_proxy=%PROXY%"
set "https_proxy=%PROXY%"
set "all_proxy=%PROXY%"
set "NO_PROXY=localhost,127.0.0.1,::1"
set "no_proxy=localhost,127.0.0.1,::1"

echo Proxy environment set for this process tree:
echo   HTTP_PROXY=%HTTP_PROXY%
echo   HTTPS_PROXY=%HTTPS_PROXY%
echo   ALL_PROXY=%ALL_PROXY%
echo   NO_PROXY=%NO_PROXY%
echo.
echo Starting: %LAUNCH_CMD%

call %LAUNCH_CMD%
exit /b %ERRORLEVEL%
