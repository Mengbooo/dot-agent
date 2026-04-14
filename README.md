# dot-agents

Claude Code + Hermes + OpenClaw 配置文件同步与管理

## 目录结构

```
dot-agents/
├── README.md
├── .env.template          # 环境变量模板
├── hermes/
│   ├── config.yaml        # Hermes 主配置
│   └── README.md
├── openclaw/
│   └── config.json        # OpenClaw 配置
├── claudecode/
│   └── settings.json      # Claude Code 设置
└── scripts/
    └── bootstrap.sh       # 一键安装脚本
```

## 快速开始

### 1. 克隆此 Repo

```bash
git clone https://github.com/YOUR_USERNAME/dot-agents.git ~/dot-agents
cd ~/dot-agents
```

### 2. 配置环境变量

```bash
cp .env.template .env
# 编辑 .env 填入你的 API Key
```

### 3. 一键安装

```bash
bash scripts/bootstrap.sh
```

## 各组件说明

### Hermes
- 通用 AI Agent，大脑角色
- 配置：`~/.hermes/config.yaml`
- 支持记忆持久化、Skills 系统、多平台接入

### OpenClaw
- 消息网关，负责多平台聚合
- 配置：`~/.openclaw/openclaw.json`
- 支持 Telegram/飞书/Discord 等

### Claude Code
- 专注代码生成的 CLI 工具
- 配置：`~/.claude/settings.json`
- 与 Hermes 共享 API 端点

## 敏感信息

所有密钥通过环境变量注入，不要将以下文件提交到 Git：

- `.env` (包含真实密钥)
- `auth.json`
- `settings.local.json`

## 自定义配置

### 添加新的 Claude Code 项目配置

```bash
# 查看现有项目
ls ~/.claude/projects/

# 添加到 claudecode/projects/
```

### 添加新的 Hermes Skill

```bash
# 目录结构
~/.hermes/skills/
├── SKILL.md
├── references/
├── templates/
└── scripts/
```

## License

MIT
