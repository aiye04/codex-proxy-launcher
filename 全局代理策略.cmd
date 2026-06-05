@echo off
setlocal
call "%~dp0scripts\global-proxy\global-proxy-policy.cmd"
exit /b %ERRORLEVEL%
