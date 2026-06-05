# Codex Proxy Launcher

Windows 上的 Codex 代理启动器集合，用于让 Codex、IDE 和命令行工具继承代理环境变量。

## 功能

- 一键开启临时的用户级全局代理策略，适合 VSCode、JetBrains IDE、PowerShell、Command Prompt 和 Windows Terminal。
- 单独以代理环境启动 Codex 桌面应用，不修改用户级环境变量。
- 提供通用 `.cmd` / PowerShell 启动脚本，可让任意命令在代理环境下运行。
- 默认代理地址为 `http://127.0.0.1:7890`，可按需修改脚本或参数。

## 快速开始

### 推荐：全局代理策略

双击根目录下的：

```text
全局代理策略.cmd
```

启动时会先选择代理配置，选中后写入当前 Windows 用户环境变量。它会影响所有读取 `HTTP_PROXY` / `HTTPS_PROXY` 的程序，不限于 Codex：

```text
1. FlClash  - http://127.0.0.1:7890
2. v2rayN   - http://127.0.0.1:10808
```

写入的变量包括：

```text
HTTP_PROXY=<所选代理地址>
HTTPS_PROXY=<所选代理地址>
NO_PROXY=localhost,127.0.0.1,::1
```

它不会设置 `ALL_PROXY`，因为 `ALL_PROXY` 可能影响 JetBrains 本地 Codex、ACP 或 WebSocket 通信。脚本也会清理旧版本可能残留的 `ALL_PROXY`。

使用流程：

1. 双击启动 `全局代理策略.cmd`。
2. 选择 `FlClash` 或 `v2rayN`，等待窗口提示代理已开启。
3. 重启需要代理的 IDE、终端或 Codex 会话。
4. 使用完毕后，在该窗口输入 `OFF` 并按 Enter，脚本会清理用户级代理环境变量。

### 仅启动 Codex 桌面应用

如果只想让 Codex 桌面应用继承代理，而不修改用户级环境变量，双击：

```text
launch-codex-with-proxy.cmd
```

启动时会先选择代理配置，选中后直接继续：

```text
1. FlClash  - http://127.0.0.1:7890
2. v2rayN   - http://127.0.0.1:10808
```

该脚本只影响当前启动的 Codex 进程树，并会设置：

```text
HTTP_PROXY
HTTPS_PROXY
ALL_PROXY
NO_PROXY
```

## 通用脚本

### CMD

```bat
scripts\generic\start-with-proxy.cmd http://127.0.0.1:7890 codex
scripts\generic\start-with-proxy.cmd socks5://127.0.0.1:7890 npm install
```

### PowerShell

```powershell
.\scripts\generic\start-with-proxy.ps1 -Proxy http://127.0.0.1:7890 codex
.\scripts\generic\start-with-proxy.ps1 -Proxy socks5://127.0.0.1:7890 npm install
```

如果需要把代理写入当前 Windows 用户环境变量：

```powershell
.\scripts\generic\start-with-proxy.ps1 -Proxy http://127.0.0.1:7890 -PersistForUser codex
```

## 文件结构

```text
.
|-- 全局代理策略.cmd
|-- launch-codex-with-proxy.cmd
|-- README-proxy-launcher.md
`-- scripts
    |-- codex-app
    |   `-- launch-codex-with-proxy.cmd
    |-- generic
    |   |-- start-with-proxy.cmd
    |   `-- start-with-proxy.ps1
    `-- global-proxy
        `-- global-proxy-policy.cmd
```

根目录的 `.cmd` 文件是便捷入口，适合放到开始菜单、桌面快捷方式或直接双击使用。

## 修改代理地址

默认代理地址是：

```text
http://127.0.0.1:7890
```

Codex 桌面应用启动脚本和全局代理策略脚本都内置 `FlClash` 和 `v2rayN` 两个选项。如果你的代理端口不同，请修改对应脚本里的 `FLCLASH_PROXY` / `V2RAYN_PROXY` 值，或在调用通用脚本时传入新的代理地址。

## 注意事项

- 开启或关闭用户级代理后，已经运行的 IDE、终端和 Codex 会话不会自动更新环境变量，需要重启后才会读取新值。
- 用户级 `HTTP_PROXY` 和 `HTTPS_PROXY` 可能影响其他 CLI 工具。
- 如果只需要给单个命令或单个 Codex 应用进程设置代理，优先使用临时启动脚本，避免影响全局环境。
- 该项目主要面向 Windows 环境。
