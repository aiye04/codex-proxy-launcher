@echo off
setlocal

set "FLCLASH_PROXY=http://127.0.0.1:7890"
set "V2RAYN_PROXY=http://127.0.0.1:10808"
set "CODEX_PATTERN=C:\Program Files\WindowsApps\OpenAI.Codex_....\app\Codex.exe"
set "SHORTCUT_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Codex"

:choose_proxy
echo Select proxy profile for Codex:
echo   1. FlClash  - %FLCLASH_PROXY%
echo   2. v2rayN   - %V2RAYN_PROXY%
echo   Q. Quit
echo.
choice /c 12Q /n /m "Select [1/2/Q]: "
if errorlevel 3 exit /b 0
if errorlevel 2 (
  set "PROXY_NAME=v2rayN"
  set "PROXY=%V2RAYN_PROXY%"
) else (
  set "PROXY_NAME=FlClash"
  set "PROXY=%FLCLASH_PROXY%"
)

echo.
echo Selected %PROXY_NAME%:
echo   %PROXY%
choice /c YN /n /m "Continue and launch Codex? [Y/N]: "
if errorlevel 2 (
  echo.
  goto choose_proxy
)
echo.

for /f "usebackq delims=" %%I in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "$root = Join-Path $env:ProgramFiles 'WindowsApps'; $best = $null; foreach ($dir in Get-ChildItem -LiteralPath $root -Directory -Filter 'OpenAI.Codex_*' -ErrorAction SilentlyContinue) { if ($dir.Name -match '^OpenAI\.Codex_([\d\.]+)_') { $exe = Join-Path $dir.FullName 'app\Codex.exe'; $version = [version]$Matches[1]; if ((Test-Path -LiteralPath $exe) -and (($null -eq $best) -or ($version -gt $best.Version))) { $best = [pscustomobject]@{ Version = $version; Exe = $exe } } } }; if ($best) { $best.Exe }"`) do set "CODEX_EXE=%%I"

if not defined CODEX_EXE (
  echo Codex.exe was not found:
  echo   %CODEX_PATTERN%
  echo.
  echo The Codex app may not be installed, or WindowsApps permissions blocked detection.
  echo Expected path pattern:
  echo   %CODEX_PATTERN%
  echo.
  echo Try launching Codex once from the Start menu, then run this launcher again.
  pause
  exit /b 1
)

set "HTTP_PROXY=%PROXY%"
set "HTTPS_PROXY=%PROXY%"
set "ALL_PROXY=%PROXY%"
set "http_proxy=%PROXY%"
set "https_proxy=%PROXY%"
set "all_proxy=%PROXY%"
set "NO_PROXY=localhost,127.0.0.1,::1"
set "no_proxy=localhost,127.0.0.1,::1"

echo Found Codex:
echo   %CODEX_EXE%
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$shortcutDir = $env:SHORTCUT_DIR; $shortcutName = 'Codex ' + [char]0x4EE3 + [char]0x7406 + [char]0x542F + [char]0x52A8 + '.lnk'; $shortcutPath = Join-Path $shortcutDir $shortcutName; $iconLocation = $env:CODEX_EXE + ',0'; if (Test-Path -LiteralPath $shortcutPath -ErrorAction SilentlyContinue) { $shell = New-Object -ComObject WScript.Shell; $shortcut = $shell.CreateShortcut($shortcutPath); if ($shortcut.IconLocation -ne $iconLocation) { $shortcut.IconLocation = $iconLocation; $shortcut.Save(); Write-Host ('Updated shortcut icon: ' + $shortcutPath) } } elseif (Test-Path -LiteralPath $shortcutDir -ErrorAction SilentlyContinue) { Write-Host ('Shortcut was not found, skipped icon update: ' + $shortcutPath) }"

start "" "%CODEX_EXE%"
if errorlevel 1 (
  echo Failed to start Codex:
  echo   %CODEX_EXE%
  echo.
  echo The Codex app may have updated or moved under:
  echo   %CODEX_PATTERN%
  echo.
  echo Please check that Codex is installed and that this launcher can access WindowsApps.
  pause
  exit /b 1
)

exit /b 0
