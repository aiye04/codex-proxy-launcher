@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Codex Global Proxy Session

set "PROXY=http://127.0.0.1:10808"
set "NO_PROXY_VALUE=localhost,127.0.0.1,::1"
set "ENV_KEY=HKCU\Environment"

echo ========================================
echo Codex Global Proxy Session
echo ========================================
echo.
echo This window enables the user-level proxy while it stays open.
echo Wait until the proxy is enabled, then type OFF and press Enter to disable it.
echo.

call :clear_user_var ALL_PROXY

call :is_proxy_enabled
if "%ERRORLEVEL%"=="0" (
  echo Proxy is already enabled for the current Windows user.
) else (
  call :set_user_var HTTP_PROXY "%PROXY%" || goto enable_failed
  call :set_user_var HTTPS_PROXY "%PROXY%" || goto enable_failed
  call :set_user_var NO_PROXY "%NO_PROXY_VALUE%" || goto enable_failed
)

echo Proxy enabled for the current Windows user:
echo   HTTP_PROXY=%PROXY%
echo   HTTPS_PROXY=%PROXY%
echo   NO_PROXY=%NO_PROXY_VALUE%
echo.
echo [OK] Keep this window open while you need the proxy.
echo Before shutdown, type OFF here and press Enter for the most reliable cleanup.
echo.

:wait_for_off
set "USER_INPUT="
set /p "USER_INPUT=Type OFF and press Enter to disable the proxy: "
if /i not "%USER_INPUT%"=="OFF" (
  echo Proxy is still enabled. Type OFF when you are ready to disable it.
  goto wait_for_off
)

echo.
call :clear_user_var HTTP_PROXY
call :clear_user_var HTTPS_PROXY
call :clear_user_var NO_PROXY
call :clear_user_var ALL_PROXY

echo Proxy disabled for the current Windows user.
echo.
echo [OK] Proxy session ended successfully.
echo.
set /p "CLOSE_INPUT=Press Enter to close this window..."
exit /b 0

:enable_failed
echo.
echo [FAILED] Could not enable proxy.
echo.
set /p "CLOSE_INPUT=Press Enter to close this window..."
exit /b 1

:set_user_var
echo Setting %~1...
setx "%~1" "%~2" >nul
exit /b %ERRORLEVEL%

:clear_user_var
echo Clearing %~1...
setx "%~1" "" >nul
reg delete "%ENV_KEY%" /v "%~1" /f >nul 2>nul
exit /b 0

:is_proxy_enabled
reg query "%ENV_KEY%" /v HTTP_PROXY 2>nul | findstr /c:"%PROXY%" >nul || exit /b 1
reg query "%ENV_KEY%" /v HTTPS_PROXY 2>nul | findstr /c:"%PROXY%" >nul || exit /b 1
reg query "%ENV_KEY%" /v NO_PROXY 2>nul | findstr /c:"%NO_PROXY_VALUE%" >nul || exit /b 1
exit /b 0
