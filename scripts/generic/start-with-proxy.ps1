param(
    [string]$Proxy = $env:CODEX_LAUNCH_PROXY,
    [string]$NoProxy = "localhost,127.0.0.1,::1",
    [switch]$PersistForUser,
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Target
)

$ErrorActionPreference = "Stop"

function Show-Usage {
    Write-Host "Usage:"
    Write-Host "  .\start-with-proxy.ps1 -Proxy http://127.0.0.1:7890 <command> [args...]"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\start-with-proxy.ps1 -Proxy http://127.0.0.1:7890 codex"
    Write-Host "  .\start-with-proxy.ps1 -Proxy socks5://127.0.0.1:7890 npm install"
    Write-Host "  .\start-with-proxy.ps1 -Proxy http://127.0.0.1:7890 -PersistForUser codex"
}

if (-not $Proxy) {
    Write-Error "Missing proxy. Pass -Proxy or set CODEX_LAUNCH_PROXY, for example: http://127.0.0.1:7890"
}

if (-not $Target -or $Target.Count -eq 0) {
    Show-Usage
    exit 2
}

if ($Target[0] -eq "--") {
    if ($Target.Count -eq 1) {
        $Target = @()
    } else {
        $Target = $Target[1..($Target.Count - 1)]
    }
}

if (-not $Target -or $Target.Count -eq 0) {
    Show-Usage
    exit 2
}

$proxyVars = @(
    @("HTTP_PROXY", $Proxy),
    @("HTTPS_PROXY", $Proxy),
    @("ALL_PROXY", $Proxy),
    @("http_proxy", $Proxy),
    @("https_proxy", $Proxy),
    @("all_proxy", $Proxy),
    @("NO_PROXY", $NoProxy),
    @("no_proxy", $NoProxy)
)

foreach ($item in $proxyVars) {
    Set-Item -Path "Env:\$($item[0])" -Value $item[1]
    if ($PersistForUser) {
        [Environment]::SetEnvironmentVariable($item[0], $item[1], "User")
    }
}

$exe = $Target[0]
$argsForExe = @()
if ($Target.Count -gt 1) {
    $argsForExe = $Target[1..($Target.Count - 1)]
}

Write-Host "Proxy environment set for this process tree:"
Write-Host "  HTTP_PROXY=$Proxy"
Write-Host "  HTTPS_PROXY=$Proxy"
Write-Host "  ALL_PROXY=$Proxy"
Write-Host "  NO_PROXY=$NoProxy"
if ($PersistForUser) {
    Write-Host "Proxy variables were also persisted to the current Windows user environment."
}
Write-Host ""
Write-Host "Starting: $exe $($argsForExe -join ' ')"

& $exe @argsForExe
exit $LASTEXITCODE
