# Hermes Agent 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://hermes-agent.nousresearch.com/docs/zh-Hans/getting-started/installation
# 更新日期：2026-10-27
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

iex (irm https://hermes-agent.nousresearch.com/install.ps1)
$env:Path = "$env:LOCALAPPDATA\hermes\bin;$env:Path" ; hermes --help
Write-Host '安装完成：运行 hermes setup 配置模型与消息平台，再输入 hermes 开始对话'

Write-Host ''

Write-Host '安装完成：运行 hermes setup 配置模型和消息平台，然后直接输入 hermes 开始对话'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://hermes-agent.nousresearch.com/docs/zh-Hans/getting-started/installation'
