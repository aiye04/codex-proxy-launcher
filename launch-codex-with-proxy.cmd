@echo off
setlocal
call "%~dp0scripts\codex-app\launch-codex-with-proxy.cmd"
exit /b %ERRORLEVEL%
