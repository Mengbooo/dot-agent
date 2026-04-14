# dot-agents

> Claude Code + Hermes + OpenClaw — **Agent 记忆与能力同步**

## 核心理念

把 **Agent 的"大脑"** 备份到 GitHub：
- **Skills**：Agent 学到的能力（工作流、坑点、验证步骤）
- **Sessions**：历史对话（可搜索的 FTS5 SQLite）
- **Memory**：用户偏好、环境配置

换机器后，Agent 能继承积累的经验，继续成长。

## 同步内容

```
dot-agents/
├── skills/                    # Hermes Skills（全部）
│   ├── github/               # GitHub 相关技能
│   ├── mlops/               # ML 训练技能
│   ├── creative/             # 创意技能
│   └── ...                   # 其他技能
│   └── .skills_prompt_snapshot.json  # Skills 索引
├── sessions/
│   └── hermes_state.db      # FTS5 SQLite（可搜索历史）
└── config/                   # 脱敏配置
```

## Skills 结构

```
skill-name/
├── SKILL.md         # 核心文档
├── references/      # 参考资料
├── templates/       # 模板文件
└── scripts/        # 辅助脚本
```

## Sessions 搜索

```bash
# 搜索包含某关键词的历史会话
sqlite3 sessions/hermes_state.db \
  "SELECT session_id, substr(content, 1, 100) FROM messages_fts WHERE content MATCH '关键词' LIMIT 10;"

# 查看某会话的所有消息
sqlite3 sessions/hermes_state.db \
  "SELECT * FROM messages WHERE session_id = 'abc123';"
```

## 同步命令

```bash
# 推送到 GitHub
bash scripts/sync.sh push

# 从 GitHub 拉取
bash scripts/sync.sh pull

# 查看同步状态
bash scripts/sync.sh status
```

## 不同步的内容

| 内容 | 原因 |
|------|------|
| API Keys / Tokens | 敏感信息 |
| history.jsonl | 原始日志 |
| cache/ | 临时缓存 |

## GitHub Repo

```
https://github.com/Mengbooo/dot-agent
```
