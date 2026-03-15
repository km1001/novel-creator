<div align="center">
   
# 🎭 novel-creator skill

### 你的个人智能长篇小说创作引擎

融合智能大纲规划、深度全网调研平台与严谨持续记忆系统的小说创作助理。

</div>

---

## ✨ 核心特性

- **网文/文学双模式**
  - **文学模式**：悬疑/现实等题材。5问精细引导，重情绪渲染，极大降低AI文字痕迹，每章3000-5000字。
  - **网文模式**：系统/修仙等爽文。提示词自动完善，强化爽点与打脸节奏，每章2000-3000字。
- **强制的 `memory` 记忆管理**：七大文件(`roles` / `locations` / `plot_points` / `story_bible` / `errors` / `foreshadowing` / `items`)保驾护航，人设备忘不崩坏，暗线伏笔不烂尾。
- **深度全网调研 (deep-research)**：开篇前自动分析市面同类爆款题材的流行写法套路，提供 2-5 种参考架构给用户精选。
- **内置大量小说写作指南与经典模板**：好不仅是对情节好，对话、悬念、场面描写均包含具体指南。

## 🚀 快速开始

1. **直接召唤 AI 并发送指令**：
   ```
   帮我用 novel-creator 创作一部小说
   ```

2. **阶段零：环境检测与续写判定**
   - AI 启动后会立刻检测当前目录是否已有以前的创作设定（即是否存在 `memory/`）。
   - 如果有记录，将询问你是否**继续创作**，或者推翻**开一本新书**。

3. **阶段一：需求调研与双模式确认**
   - **大纲采集**：如果有明确大纲，直接扔给 AI；如果没有，AI 会进行经典的"5问循序引导"。
   - **全网调研**：AI 会自动查阅相关最爆款写作流派（借助 `deep-research`）。
   - **风格选定**：你决定到底走**网文模式**，还是**文学模式**。

4. **阶段二：智能梳理与《大纲》《角色/物品档案》生成**
   在开始疯狂码字前，AI 会建立 `output` 和 `memory` 目录，生成全书框架大纲、记录初始人设、设定核心悬念和底层逻辑，向你做最后确认。

5. **阶段三：创作节奏选择与逐章发生**
   你可以告诉 AI 是**先写一章试试看**、**连写X章后停下看反馈**，还是**直接全自动爆更到完结**。在整个修改反馈期间，如果你改变了主线走向或某位角色的生死，AI 都会主动更新 `memory` 中的全书设定。

---

## 📂 结构与资源使用

```
novel-creator/
├── SKILL.md                 # 核心技能逻辑
├── README.md

├── references/              # AI写作大脑（10份方法论集大成者）
│   ├── chapter-guide.md     # 10种强力开场技巧与结构
│   ├── consistency.md       # 连贯性保证机制
│   ├── content-expansion.md # 7种水字数/扩充场景技巧
│   ├── dialogue-writing.md  # 摆脱AI冰冷对话指南
│   ├── ...

├── assets/                  # 各类初始系统模板与报告框架
│   ├── chapter-template.md  # 有针对战斗/高潮反转/突破的专用模板
│   ├── outline-template.md  # 全书大纲脉络
│   ├── memory-template.md   # 7大记忆库雏形
│   └── ...

├── scripts/                 # 工具箱
│   ├── init-novel.sh        # Mac/Linux 一键建档空工作区脚本
│   ├── init-novel.ps1       # Windows 一键建档空工作区脚本
│   └── check_chapter_wordcount.py # 去除Markdown标签的真空汉字计数器

└── plan/                    # 计划系统，宏观与微观剧情推进
    ├── outline.md           # 全书总大纲与规划
    ├── current_arc.md       # 大阶段剧集模块
    ├── current_unit.md      # 最小剧集单元

└── memory/                  # 运行过程中自动推演更新的记忆系统
    ├── roles.md             # 角色档案
    ├── locations.md         # 地点档案
    ├── plot_points.md       # 情节关键节点日志
    ├── story_bible.md       # 底层世界观与设定集
    ├── errors.md            # 断层/穿帮错题本
    ├── foreshadowing.md     # 伏笔与暗线填坑督导表
    └── items.md             # 关键物品与线索流转账本
```

---

## 🛠️ 安装

将此整个目录放入 AI Agent 工具支持技能的指定 `skills` 目录（例如 `~/.claude/skills/novel-creator/` 或者 `~/.agents/skills/novel-creator/` ）。

*注意: 需同时安装并开启 `deep-research` (用于最新题材智能调研) 和 `humanizer-zh` (用于深度去AI味润色) 技能。*

---

## 🤝 鸣谢与许可

本项目是对以下两个优秀的开源 Agent Skill 的合并与深度定制升级版本：
- **[chinese-novelist](https://github.com/penglonghuang/chinese-novelist-skill)** (MIT License)
- **[novel-generator](https://clawhub.ai/ITYHG/novel-generator)** (MIT License)

感谢原作者们的卓越贡献！

### ⚖️ 许可证

本项目遵循 **MIT License**。您可以自由地使用、修改和分发。
