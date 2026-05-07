@echo off
setlocal
call "%~dp0scripts\global-proxy\codex-global-proxy-session.cmd"
exit /b %ERRORLEVEL%
