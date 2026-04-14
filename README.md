# dot-agent

Hermes + Claude Code + OpenClaw 配置与记忆同步

## 同步内容

- `skills/` — Hermes Skills（Agent 能力）
- `sessions/hermes_state.db` — 历史会话（FTS5 可搜索）
- `config/` — 配置文件

## 使用

```bash
# 推送到 GitHub
bash scripts/sync.sh push

# 从 GitHub 拉取
bash scripts/sync.sh pull
```

## 新机器恢复

```bash
git clone https://github.com/Mengbooo/dot-agent.git ~/dot-agents
cd ~/dot-agents
bash scripts/sync.sh pull
```

然后手动恢复 `~/.hermes/.env`（API Keys 未同步）。
