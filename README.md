<div align="center">

# 🎭 novel-creator 2.0

### 先学文风，再写长篇

轻主控、强记忆、可连载的中文小说创作总控台。

</div>

---

## ✨ 2.0 核心升级

- **四种工作模式**
  - **快速开写**：先出样章，再补设定
  - **标准建书**：完整建档、规划卷纲、进入连载
  - **继续连载**：读取现有 `plan/` 与 `memory/` 直接续写
  - **救稿重构**：从已有稿件反推结构，修复大纲与记忆

- **正式加入“文风预热阶段”**
  - 写正文前先读取指定题材样本
  - 自动提炼语感、句式、对白、意象和禁忌写法
  - 生成 `plan/style_guide.md` 作为后续章节的固定文风卡

- **轻量主控 + 技能解耦**
  - `novel-creator` 负责规划、记忆、节奏与连贯性
  - `novel-humanizer` 负责小说去 AI
  - `novel-write-style` 负责强化指定题材笔触
  - `deep-research` 仅在需要市场/平台趋势时启用

- **更安全的初始化**
  - 支持 `minimal` / `full` 两种初始化模式
  - 清空旧项目时先自动备份
  - 新增 `manifest.json` 记录项目状态

---

## 🚀 适合什么场景

- “帮我开一本悬疑长篇”
- “先写一章样章试试”
- “继续写第 12 章”
- “这本书写崩了，帮我重整大纲”
- “写之前先学一下这个题材的文风”

---

## 📂 目录结构

```text
novel-creator/
├── SKILL.md
├── README.md
├── assets/
│   ├── chapter-template.md
│   ├── memory-template.md
│   ├── plan-template.md
│   ├── PROMPT-TEMPLATE.md
│   └── style-guide-template.md
├── examples/
├── references/
├── scripts/
│   ├── init-novel.ps1
│   ├── init-novel.sh
│   └── check_chapter_wordcount.py
```

运行后会在工作区生成：

```text
output/
plan/
memory/
manifest.json
backup/
```

---

## 🧭 2.0 工作流

### 1. 分流任务
- 新建
- 续写
- 救稿
- 样章

### 2. 最小确认
优先只确认：
- 题材
- 模式（网文 / 文学）
- 当前任务
- 生成节奏
- 是否需要市场调研

### 3. 文风预热
写之前先读：
- `examples/[题材].md`
- 必要时 `references/小说经典片段赏析_[题材].md`

然后生成：
- `plan/style_guide.md`

### 4. 初始化
- `minimal`：适合样章、快速试写
- `full`：适合正式建书、长期连载

### 5. 逐章创作
每次优先读取：
- `plan/current_unit.md`
- `plan/style_guide.md`
- 必要的 `memory/*.md`

### 6. 章节完成后
- 保存正文
- 更新 `plan/`
- 更新 `memory/`
- 跑字数检查脚本

---

## 🛠️ 初始化脚本

### PowerShell

```powershell
./scripts/init-novel.ps1 "夜航档案" -Mode minimal
./scripts/init-novel.ps1 "夜航档案" -Mode full
./scripts/init-novel.ps1 "夜航档案" -Mode full -Clean
```

### Bash

```bash
./scripts/init-novel.sh "夜航档案" --mode minimal
./scripts/init-novel.sh "夜航档案" --mode full
./scripts/init-novel.sh "夜航档案" --mode full --clean
```

---

## 🤝 配套技能

推荐一起使用：

- `novel-humanizer`
  - 小说去 AI、人味化、对白修正、心理毛边
- `novel-write-style`
  - 强化悬疑 / 校园 / 仙侠 / 爽文等题材笔触
- `deep-research`
  - 仅在你要研究平台风向、爆款套路时使用

---

## ⚖️ 许可证

本项目遵循 **MIT License**。
