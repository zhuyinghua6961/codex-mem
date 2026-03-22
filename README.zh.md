# codex-mem

这是一个把 [`thedotmack/claude-mem`](https://github.com/thedotmack/claude-mem) 迁移到 Codex 使用场景下的 skills 仓库。

这个仓库**不是** Claude Code 插件本体，也**不会**让 Codex 原生获得 Claude Code 的 `/plugin`、hooks 或 Claude Desktop 集成能力。  
它做的是把 `claude-mem` 里真正有价值的工作流，整理成 Codex 可用的 skills、shell 命令和运维操作手册。

## 仓库里有什么

当前仓库主要包含：

- 一个总入口 skill：`claude-mem-for-codex`
- 记忆检索与高级检索相关 skills
- context、viewer、settings、queue、troubleshooting、session runtime 相关 skills
- 适配到 Codex subagent 的 `make-plan` / `do` 工作流
- `smart-explore` 的高保真 helper scripts

仓库结构是“一技能一目录”，例如：

```text
claude-mem-for-codex/
claude-mem-memory-search/
claude-mem-advanced-search/
...
```

## 这个仓库解决什么问题

这套迁移的目标是，尽量把 `claude-mem` 的实用能力保留下来，让它能在 Codex 里继续发挥作用，比如：

- 从运行中的 `claude-mem` worker 或本地数据库中回忆历史工作
- 查看 observations、prompts、sessions、timeline
- 使用 viewer、settings、queue、troubleshooting 等运维能力
- 用 HTTP session lifecycle API 适配外部自动化流程
- 把原本的 `make-plan` / `do` / `smart-explore` 工作方式迁移到 Codex

## 这个仓库不做什么

它**不会**让 Codex 原生支持：

- Claude Code 的 `/plugin` 命令
- Claude Code hooks 自动注册
- Claude Desktop 集成

这些能力在本仓库里会以“等价 workflow”的方式出现，例如：

- worker HTTP API
- 本地数据库操作
- 脚本化运维流程

但它们不是宿主平台层面的 1:1 原生复刻。

## 如何安装到 Codex

Codex 的 skill 发现通常依赖 `~/.agents/skills/` 目录。  
最稳妥的做法，是把每个 skill 目录单独链接进去。

示例：

```bash
mkdir -p ~/.agents/skills

for dir in /path/to/codex-mem/*; do
  [ -d "$dir" ] || continue
  ln -s "$dir" "$HOME/.agents/skills/$(basename "$dir")"
done
```

如果目标链接已经存在，需要先手动处理旧链接或旧目录。

链接完成后，重启 Codex，让它重新发现这些 skills。

## 推荐从哪里开始

如果你是第一次使用这套 skills，建议从：

- `claude-mem-for-codex`

开始。

它会把任务继续分流到更具体的 skills，例如：

- 记忆检索与高级搜索
- context inject 和 timeline report
- settings、maintenance、queue、troubleshooting
- planning 和 execution

## 运行前提

很多 skill 默认假设以下条件至少满足一项：

- 有一个运行中的 `claude-mem` worker：`http://localhost:37777`
- 本地存在 `claude-mem` 数据库：`~/.claude-mem/claude-mem.db`
- 本地有一份 `claude-mem` 源码 checkout，可用于脚本型工作流

没有这些前提时，部分 skill 仍然能提供说明或 fallback，但大多数记忆类和运行时类能力都依赖这些环境。

## Smart Explore

`claude-mem-smart-explore` 目前支持两种模式：

- 高保真 AST 模式：调用原始 `claude-mem` 的 smart-file-read 引擎
- shell fallback 模式：使用 `rg` 和定点读文件

相关 helper scripts 位于：

```text
claude-mem-smart-explore/scripts/
```

## 仓库定位

这个仓库是一个实用的迁移/适配层，不是官方 upstream 分发仓库。

如果你需要的是原汁原味的 Claude 插件行为，应该直接使用上游 `claude-mem`：

- https://github.com/thedotmack/claude-mem
