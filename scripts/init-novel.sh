#!/bin/bash
# Novel Creator 2.0 初始化脚本
# 支持 minimal / full 两种模式，并在 --clean 时先备份旧工作区。

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$SKILL_DIR/output"
MEMORY_DIR="$SKILL_DIR/memory"
PLAN_DIR="$SKILL_DIR/plan"
BACKUP_DIR="$SKILL_DIR/backup"
MANIFEST_PATH="$SKILL_DIR/manifest.json"

usage() {
  cat << EOF
用法: $(basename "$0") <小说名称> [选项]

选项:
  --mode minimal|full   初始化模式，默认 full
  --clean               清理旧工作区（会先备份）
  -h, --help            显示帮助
EOF
}

write_markdown_file() {
  local path="$1"
  local content="$2"
  printf "%s\n" "$content" > "$path"
}

backup_workspace() {
  local timestamp
  timestamp="$(date +%Y%m%d-%H%M%S)"
  local target="$BACKUP_DIR/$timestamp"
  mkdir -p "$target"

  [ -e "$OUTPUT_DIR" ] && cp -R "$OUTPUT_DIR" "$target/"
  [ -e "$MEMORY_DIR" ] && cp -R "$MEMORY_DIR" "$target/"
  [ -e "$PLAN_DIR" ] && cp -R "$PLAN_DIR" "$target/"
  [ -e "$MANIFEST_PATH" ] && cp "$MANIFEST_PATH" "$target/"

  echo -e "${YELLOW}[备份]${NC} 已备份旧工作区到 $target"
}

NOVEL_NAME=""
MODE="full"
CLEAN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      MODE="$2"
      shift 2
      ;;
    --clean)
      CLEAN=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo -e "${RED}[错误]${NC} 未知选项: $1"
      usage
      exit 1
      ;;
    *)
      if [ -z "$NOVEL_NAME" ]; then
        NOVEL_NAME="$1"
      else
        echo -e "${RED}[错误]${NC} 意外参数: $1"
        usage
        exit 1
      fi
      shift
      ;;
  esac
done

if [ -z "$NOVEL_NAME" ]; then
  echo -e "${RED}[错误]${NC} 请提供小说名称"
  usage
  exit 1
fi

if [[ "$MODE" != "minimal" && "$MODE" != "full" ]]; then
  echo -e "${RED}[错误]${NC} --mode 仅支持 minimal 或 full"
  exit 1
fi

echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo -e "${CYAN}  Novel Creator 2.0 - 初始化工作区${NC}"
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo -e "  小说名称: ${GREEN}《${NOVEL_NAME}》${NC}"
echo -e "  初始化模式: ${GREEN}${MODE}${NC}"

mkdir -p "$BACKUP_DIR"

if [ "$CLEAN" = true ]; then
  if [ -e "$OUTPUT_DIR" ] || [ -e "$MEMORY_DIR" ] || [ -e "$PLAN_DIR" ] || [ -e "$MANIFEST_PATH" ]; then
    echo -e "${CYAN}[步骤]${NC} 备份旧工作区..."
    backup_workspace
  fi
  echo -e "${CYAN}[步骤]${NC} 清理旧工作区..."
  rm -rf "$OUTPUT_DIR" "$MEMORY_DIR" "$PLAN_DIR"
  rm -f "$MANIFEST_PATH"
fi

echo -e "${CYAN}[步骤]${NC} 创建目录..."
mkdir -p "$OUTPUT_DIR" "$MEMORY_DIR" "$PLAN_DIR"

echo -e "${CYAN}[步骤]${NC} 初始化 plan ..."
write_markdown_file "$PLAN_DIR/outline.md" "# 《${NOVEL_NAME}》大纲与规划

- 类型：待补全
- 模式：待补全
- 全书目标：待补全"

write_markdown_file "$PLAN_DIR/current_unit.md" "# 最小剧情单元档案 (CURRENT_UNIT)

记录最近 3-5 章的具体推进、冲突与任务。

## 核心任务
- 目标：待补全
- 涉及人物：待补全
- 关键博弈点：待补全
- 这个单元存在的意义：待补全

## 章节精细推演
| 章节 | 任务/计谋分解 | 这一章存在的意义 | 预期字数 | 关键细节/伏笔要求 |
|---|---|---|---|---|

## 单元 / 事件完成后的合理性复盘
- 这个单元存在的意义是否真正完成：待复盘
- 删掉本单元后，故事会不会更紧：待复盘
- 人物行为是否前后一致：待复盘
- 事件推进是否过巧：待复盘
- 题材容错标准：纪实类文学严格检查；网络爽文允许小 bug，但不允许关键因果断裂"

write_markdown_file "$PLAN_DIR/style_guide.md" "# 文风预热卡 (STYLE_GUIDE)

- 题材：待确认
- 叙事温度：待提炼
- 句式节奏：待提炼
- 对白习惯：待提炼
- 常用意象/词汇场：待提炼
- 禁忌写法：待提炼
- 去 AI 注意点：待提炼
- 本书专属偏好：待提炼"

if [ "$MODE" = "full" ]; then
  write_markdown_file "$PLAN_DIR/current_arc.md" "# 当前大单元剧集/阶段档案 (CURRENT_ARC)

记录当前卷/当前阶段的核心目标、势力、冲突与回收点。

- 起止规划：待补全
- 本篇章核心目标/作用：待补全
- 这个篇章存在的意义：待补全
- 发生地：待补全

## 篇章完成后的合理性复盘
- 是否完成了本篇章存在的意义：待复盘
- 人物行为是否合理：待复盘
- 因果链是否清楚：待复盘
- 题材容错标准：纪实类文学原则上不允许明显 bug；网络爽文允许轻微便利性 bug，但不得伤及主线逻辑"
fi

echo -e "${CYAN}[步骤]${NC} 初始化 memory ..."
write_markdown_file "$MEMORY_DIR/roles.md" "# 角色档案 (ROLES)

> 说明：现实题材至少记录【性别】；奇幻/科幻/异种题材额外记录【种族/物种】。如无特殊设定，可写“人类”。

| 角色姓名 | 首次出场 | 性别 | 种族/物种 | 年龄/外表年龄 | 身份/阵营 | 当前等级/实力 | 核心性格/动机 | 标志性特征 | 状态 | 关键经历/近期目的 |
|---|---|---|---|---|---|---|---|---|---|---|"

write_markdown_file "$MEMORY_DIR/plot_points.md" "# 关键情节档案 (PLOT_POINTS)
| 情节编号 | 关联章节 | 事件摘要 | 涉及关键角色 | 后续长远影响 | 状态 |
|---|---|---|---|---|---|"

write_markdown_file "$MEMORY_DIR/story_bible.md" "# 故事圣经 (STORY_BIBLE)

## 1. 基础世界背景

## 2. 力量/等级体系
| 境界/级别 | 能力特征 | 寿命上限 | 突破难度与标志 |
|---|---|---|---|

## 3. 核心社会规则与禁忌"

if [ "$MODE" = "full" ]; then
  write_markdown_file "$MEMORY_DIR/locations.md" "# 地点档案 (LOCATIONS)
| 地点名称 | 首次出场 | 所属势力 | 环境/氛围特征 | 重要历史事件 | 状态 |
|---|---|---|---|---|---|"

  write_markdown_file "$MEMORY_DIR/errors.md" "# 穿帮与错误修正日志 (ERRORS)
| 错误ID | 发生章节 | 严重性 | 穿帮/逻辑漏洞描述 | 影响与修正方案 | 状态 |
|---|---|---|---|---|---|"

  write_markdown_file "$MEMORY_DIR/foreshadowing.md" "# 伏笔与暗线管理 (FORESHADOWING)
| 伏笔编号 | 埋设章节 | 抛出的线索/悬念表象 | 设计目的/暗线真相 | 计划回收节点 | 状态 |
|---|---|---|---|---|---|"

  write_markdown_file "$MEMORY_DIR/items.md" "# 物品与线索档案 (ITEMS)
| 物品名称 | 获得章节 | 物品类型 | 特征效果与副作用 | 当前持有者 | 状态 | 流转与消耗记录 |
|---|---|---|---|---|---|---|"
fi

touch "$OUTPUT_DIR/.gitkeep"

cat > "$MANIFEST_PATH" << EOF
{
  "novel_name": "${NOVEL_NAME}",
  "init_mode": "${MODE}",
  "created_at": "$(date +%Y-%m-%dT%H:%M:%S)",
  "current_chapter": 0,
  "current_arc": "",
  "status": "active"
}
EOF

echo -e "\n${GREEN}[信息]${NC} 《${NOVEL_NAME}》工作区初始化完成！"
echo "后续步骤:"
echo "  1. 先做文风预热，填写 plan/style_guide.md"
echo "  2. 再开始样章或正文创作"
