# Proxy launcher

These launchers help Codex and developer tools inherit proxy environment
variables.

## Recommended: global proxy policy

Use the root policy launcher when you want a temporary user-level proxy for
VSCode, IntelliJ IDEA, DataGrip, PowerShell, Command Prompt, Windows Terminal,
Codex, and other tools that read proxy environment variables.

The global proxy policy prompts for a proxy profile:

```text
1. FlClash  - http://127.0.0.1:7890
2. v2rayN   - http://127.0.0.1:10808
```

Then it sets only:

```text
HTTP_PROXY=<selected proxy>
HTTPS_PROXY=<selected proxy>
NO_PROXY=localhost,127.0.0.1,::1
```

It does not set `ALL_PROXY`, because that can interfere with JetBrains local
Codex/ACP/WebSocket communication. It also clears any old `ALL_PROXY` value left
by earlier versions of this launcher.

Keep the policy window open while you need the proxy. Type `OFF` and press
Enter in that window to disable the proxy and end the session.

## Temporary Codex app launcher

Use the root Codex app launcher when you only want to open the Codex app with
proxy variables set for that process tree. This launcher keeps its original
process-local proxy behavior, including `ALL_PROXY`, because it does not write
user-level environment variables.

The launcher prompts for a proxy profile and continues immediately after a
profile is selected:

```text
1. FlClash  - http://127.0.0.1:7890
2. v2rayN   - http://127.0.0.1:10808
```

## Script layout

```text
scripts\global-proxy\global-proxy-policy.cmd
scripts\codex-app\launch-codex-with-proxy.cmd
scripts\generic\start-with-proxy.cmd
scripts\generic\start-with-proxy.ps1
```

The root `.cmd` files are thin launchers kept for Start Menu shortcuts and
double-click convenience.

## Notes

- Replace the built-in FlClash or v2rayN proxy ports with your actual proxy
  host and port if needed.
- After enabling or disabling the global proxy, restart VSCode, JetBrains IDEs,
  terminals, and running Codex sessions. Already running programs keep the
  environment variables they started with.
- User-level proxy variables can affect other CLI tools that read `HTTP_PROXY`
  or `HTTPS_PROXY`.
