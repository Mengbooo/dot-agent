# Hermes 配置

## 文件说明

| 文件 | 说明 |
|------|------|
| `config.yaml` | 主配置文件（不含密钥） |
| `skills/` | 自定义 Skills 目录 |
| `cron/` | Cron 任务配置 |

## 敏感信息

密钥存储在 `~/.hermes/.env`，不要将此文件提交到 Git。

## 模板

如需重新生成模板：
```bash
cp ~/.hermes/config.yaml config.yaml.template
# 然后手动替换密钥为占位符
```
