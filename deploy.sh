#!/usr/bin/env bash
set -euo pipefail
# Hermes Agent 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://hermes-agent.nousresearch.com/docs/zh-Hans/getting-started/installation
# 更新日期：2026-10-27
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }

mkdir -p .download
cd .download

command -v curl >/dev/null 2>&1 || { echo "需要先安装 curl"; exit 1; }
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
command -v hermes >/dev/null 2>&1 || { echo "安装后没找到 hermes，请重开终端或检查 PATH"; exit 1; }
hermes --help

echo ""

echo "安装完成：运行 hermes setup 配置模型和消息平台，然后直接输入 hermes 开始对话"
echo "若结果异常或需要改配置，请参考官方文档：https://hermes-agent.nousresearch.com/docs/zh-Hans/getting-started/installation"
