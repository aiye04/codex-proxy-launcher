# Proxy launcher

These launchers help Codex and developer tools inherit proxy environment
variables.

## Recommended: global proxy session

Use the root session launcher when you want a temporary user-level proxy for
Codex in VSCode, IntelliJ IDEA, DataGrip, PowerShell, Command Prompt, or Windows
Terminal.

The global proxy session sets only:

```text
HTTP_PROXY=http://127.0.0.1:7890
HTTPS_PROXY=http://127.0.0.1:7890
NO_PROXY=localhost,127.0.0.1,::1
```

It does not set `ALL_PROXY`, because that can interfere with JetBrains local
Codex/ACP/WebSocket communication. It also clears any old `ALL_PROXY` value left
by earlier versions of this launcher.

Keep the session window open while you need the proxy. Type `OFF` and press
Enter in that window to disable the proxy and end the session.

## Temporary Codex app launcher

Use the root Codex app launcher when you only want to open the Codex app with
proxy variables set for that process tree. This launcher keeps its original
process-local proxy behavior, including `ALL_PROXY`, because it does not write
user-level environment variables.

## Script layout

```text
scripts\global-proxy\codex-global-proxy-session.cmd
scripts\codex-app\launch-codex-with-proxy.cmd
scripts\generic\start-with-proxy.cmd
scripts\generic\start-with-proxy.ps1
```

The root `.cmd` files are thin launchers kept for Start Menu shortcuts and
double-click convenience.

## Notes

- Replace `127.0.0.1:7890` with your actual proxy host and port if needed.
- After enabling or disabling the global proxy, restart VSCode, JetBrains IDEs,
  terminals, and running Codex sessions. Already running programs keep the
  environment variables they started with.
- User-level proxy variables can affect other CLI tools that read `HTTP_PROXY`
  or `HTTPS_PROXY`.
