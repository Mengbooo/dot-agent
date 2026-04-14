#!/bin/bash
# dot-agents Bootstrap Script
# 用于在新机器上快速同步配置

set -e

DOT_AGENTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dot-agents-backup/$(date +%Y%m%d_%H%M%S)"

echo "=== dot-agents Bootstrap ==="
echo "备份目录: $BACKUP_DIR"
echo ""

# 创建备份
mkdir -p "$BACKUP_DIR"

# Hermes
if [ -f "$HOME/.hermes/config.yaml" ]; then
    echo "[1/3] 备份 Hermes 配置..."
    cp -r "$HOME/.hermes" "$BACKUP_DIR/"
fi

# OpenClaw
if [ -f "$HOME/.openclaw/openclaw.json" ]; then
    echo "[2/3] 备份 OpenClaw 配置..."
    cp -r "$HOME/.openclaw" "$BACKUP_DIR/"
fi

# Claude Code
if [ -f "$HOME/.claude/settings.json" ]; then
    echo "[3/3] 备份 Claude Code 配置..."
    cp -r "$HOME/.claude" "$BACKUP_DIR/"
fi

# 软链接配置
echo ""
echo "=== 创建软链接 ==="

# Hermes
if [ -f "$DOT_AGENTS_DIR/hermes/config.yaml" ]; then
    echo "Linking Hermes config..."
    # 不覆盖用户自己的 .env
    if [ ! -f "$HOME/.hermes/.env" ]; then
        touch "$HOME/.hermes/.env"
        echo "Created empty ~/.hermes/.env (请编辑填入密钥)"
    fi
fi

# OpenClaw
if [ -f "$DOT_AGENTS_DIR/openclaw/config.json" ]; then
    echo "Linking OpenClaw config..."
    # 需要用环境变量替换 token
    export OPENCLAW_TOKEN="${OPENCLAW_TOKEN:-$(openssl rand -hex 16)}"
    envsubst < "$DOT_AGENTS_DIR/openclaw/config.json" > "$HOME/.openclaw/openclaw.json"
fi

# Claude Code
if [ -f "$DOT_AGENTS_DIR/claudecode/settings.json" ]; then
    echo "Linking Claude Code settings..."
    # Claude Code 不支持 envsubst，直接复制
    cp "$DOT_AGENTS_DIR/claudecode/settings.json" "$HOME/.claude/settings.json"
fi

echo ""
echo "=== 完成 ==="
echo "备份已保存到: $BACKUP_DIR"
echo ""
echo "请确保已配置环境变量:"
echo "  cp .env.template .env"
echo "  # 编辑 .env 填入真实密钥"
