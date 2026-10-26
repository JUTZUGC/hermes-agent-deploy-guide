# Hermes Agent 一键部署指南

> 第三方部署指南 · 非 Hermes Agent 官方仓库。官方项目：[NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
> 内容来自官方文档（2026-10-27）。项目迭代快，请以[官方文档](https://hermes-agent.nousresearch.com/docs/zh-Hans/getting-started/installation)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不想自己配一堆运行时，让百度搭子把 Hermes 装好，再接通模型就能长期用。

⚠️ 源码安装会准备 Python 3.14、Node.js、ripgrep、FFmpeg 等运行时，体积与耗时都不小；Windows 杀软可能误报自带的 uv.exe。原生 Windows / macOS / Linux / WSL2 / Docker 都支持，macOS 只支持 Apple Silicon。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/hermes-agent-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会跑官方安装脚本，自动准备 Python、Node、ripgrep、FFmpeg 等运行时，装完提示你跑 hermes setup，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## Hermes Agent 是什么？

Hermes Agent 是开源的自托管、跨会话积累记忆的 AI Agent（协议：MIT，<img src="https://img.shields.io/github/stars/NousResearch/hermes-agent?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

一个长期驻留的 Agent：记忆以 Markdown 存在本地，跨会话累积；内置 47 个工具、cron 定时任务、技能系统、MCP 客户端/服务端，支持 Telegram / Discord / Slack / 飞书 / 企业微信等入口。

- 记忆：本地 Markdown，跨会话、跨模型保留
- 工具：47 个内置工具（搜索、浏览器、代码、视觉、图像、TTS 等）
- 定时：内置 cron，离线也能跑任务
- 入口：CLI / TUI / Gateway / Web Dashboard / 消息平台
- 运行：本地、Docker、SSH、Daytona、Modal 等后端
- MCP：既接外部 MCP，也能把自己暴露成 MCP server

（来源：[官方仓库](https://github.com/NousResearch/hermes-agent)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 257.4k stars | Nous Research 出品，2025-07 建，持续高频更新 |
| 记忆与技能 | 本地 Markdown 记忆，技能可自动沉淀 |
| 入口最全 | CLI、TUI、Gateway、Dashboard、手机消息平台 |
| 原生 Windows | 不需要 WSL，PowerShell 一条命令装 |
| MIT | 协议宽松，二次开发自由 |

| 需要注意 | 说明 |
|---|---|
| 安装重 | 会拉 Python 3.14、Node、FFmpeg 等运行时 |
| macOS 只支持 ARM | Intel Mac 不在支持列表 |
| 概念较多 | 模型、工具、网关、技能要逐个理解 |
| 长期驻留有成本 | cron 与消息网关会持续调用模型 |
| 杀软误报 | 自带的 uv.exe 常被误判 |

> 以上基于官方文档与社区反馈整理（2026-10-27），以官方最新文档为准。

## 快速部署（官方方式）

```bash
command -v curl >/dev/null 2>&1 || { echo "需要先安装 curl"; exit 1; }
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
command -v hermes >/dev/null 2>&1 || { echo "安装后没找到 hermes，请重开终端或检查 PATH"; exit 1; }
hermes --help
```

部署步骤来源：[https://github.com/NousResearch/hermes-agent#quick-install](https://github.com/NousResearch/hermes-agent#quick-install)

## 验证状态

| 场景 | 状态 |
|---|---|
| 官方 README 的安装命令、gateway 端口与 Docker 用法已核对 | 已核对 2026-10-27 |
| Release v0.22.5 已核对（无二进制资产，安装走官方域名脚本） | 已核对 2026-10-27 |
| 未安装（安装会写入用户目录并拉取多个运行时） | 已核对 2026-10-27 |
| MCP 服务握手与工具列表（initialize / tools/list） | 已验证 2026-10-27 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-27 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

Hermes 既支持接入外部 MCP server，也能把自己暴露成 MCP server 给 Claude Code / Cursor / Codex 调用。本仓库的 MCP 只提供安装、配置与常见坑。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-27）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\hermes-agent-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 安装完成后

1. 配置：`hermes setup`（一次性配完）或 `hermes setup --portal`（用 Nous Portal 免填各家 Key）
2. 选模型：`hermes model`；选工具：`hermes tools`
3. 开始对话：`hermes`
4. 消息网关：`hermes gateway setup` 后运行 `hermes gateway`
5. 诊断与升级：`hermes doctor`、`hermes update`

### Docker（官方镜像）

```sh
mkdir -p ~/.hermes
docker run -it --rm -v ~/.hermes:/opt/data nousresearch/hermes-agent setup
docker run -d --name hermes --restart unless-stopped \
  -v ~/.hermes:/opt/data -p 8642:8642 \
  nousresearch/hermes-agent gateway run
```

8642 是 gateway 的 OpenAI 兼容接口与健康检查端口；要看 Dashboard 时设 `HERMES_DASHBOARD=1`。

### Windows 注意

原生安装落在 `%LOCALAPPDATA%\hermes`，与 WSL2 安装互不影响。杀软如果隔离了 `uv.exe`，按官方 README 的校验步骤确认后再把整个 bin 目录加白名单。

> ⚠️ 它会长期驻留并调用模型，注意 API 费用；接入 Telegram / 飞书 / 企业微信前先确认哪些消息可以出境。

## 常见坑

- PowerShell 执行策略拦截：先 `Set-ExecutionPolicy -Scope Process Bypass`
- 命令找不到：重开终端，确认 `~/.local/bin` 或 `%LOCALAPPDATA%\hermes\bin` 在 PATH 里
- 杀软删了 uv.exe：按官方 README 校验后把 bin 目录加白名单
- gateway 连不上：检查 8642 端口与 `hermes doctor` 输出
- 模型不响应：先 `hermes model` 确认 provider 与 Key
- 升级后异常：跑 `hermes update`，再 `hermes doctor`
- Docker 写入失败：挂载的 `~/.hermes` 要可写

## 免责声明

本仓库为第三方指南，与 Hermes Agent 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-27），项目迭代快，请以[官方文档](https://hermes-agent.nousresearch.com/docs/zh-Hans/getting-started/installation)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
