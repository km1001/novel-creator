#!/bin/bash
# 小说初始化脚本 (novel-creator)
# 为新小说创建 output 和 memory 目录，并初始化7个记忆库文件。
# 用法: ./init-novel.sh <小说名称> [--clean]

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

usage() {
    cat << EOF
用法: $(basename "$0") <小说名称> [选项]

为一部新小说初始化工作区。

参数:
  小说名称     小说的名称

选项:
  --clean      清除旧的记忆文件和输出（重新开始）
  -h, --help   显示此帮助信息

示例:
  $(basename "$0") 逆天丹帝
  $(basename "$0") 都市之王 --clean
EOF
}

NOVEL_NAME=""
CLEAN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --clean) CLEAN=true; shift ;;
        -h|--help) usage; exit 0 ;;
        -*) echo -e "${RED}[错误]${NC} 未知选项: $1"; usage; exit 1 ;;
        *)
            if [ -z "$NOVEL_NAME" ]; then
                NOVEL_NAME="$1"
            else
                echo -e "${RED}[错误]${NC} 意外参数: $1"; usage; exit 1
            fi
            shift ;;
    esac
done

if [ -z "$NOVEL_NAME" ]; then
    echo -e "${RED}[错误]${NC} 请提供小说名称"
    usage
    exit 1
fi

echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo -e "${CYAN}  Novel Creator - 初始化工作区${NC}"
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo -e "  小说名称: ${GREEN}《${NOVEL_NAME}》${NC}"

if [ "$CLEAN" = true ]; then
    echo -e "${CYAN}[步骤]${NC} 清除旧的输出文件..."
    rm -rf "$OUTPUT_DIR"/*.md 2>/dev/null || true
    echo -e "${CYAN}[步骤]${NC} 清理旧 memory 和 plan..."
    rm -rf "$MEMORY_DIR" 2>/dev/null || true
    rm -rf "$PLAN_DIR" 2>/dev/null || true
fi

echo -e "${CYAN}[步骤]${NC} 创建目录目录..."
mkdir -p "$OUTPUT_DIR"
mkdir -p "$MEMORY_DIR"
mkdir -p "$PLAN_DIR"

echo -e "${CYAN}[步骤]${NC} 从模板初始化 memory 记忆库..."

# Since memory-template is complex, we just create empty initial structures with headers. 
# AI will populate them.

cat > "$MEMORY_DIR/roles.md" << 'EOF'
# 角色档案 (ROLES)
| 角色姓名 | 首次出场 | 身份/阵营 | 当前等级/实力 | 核心性格/动机 | 标志性特征 | 状态 (活跃/退场/死亡) | 关键经历/近期目的 |
|---|---|---|---|---|---|---|---|
EOF

cat > "$MEMORY_DIR/locations.md" << 'EOF'
# 地点档案 (LOCATIONS)
| 地点名称 | 首次出场 | 所属势力 | 环境/氛围特征 (感官描写) | 重要历史事件 | 状态 (正常/封禁/已毁/废弃) |
|---|---|---|---|---|---|
EOF

cat > "$MEMORY_DIR/plot_points.md" << 'EOF'
# 关键情节档案 (PLOT_POINTS)
| 情节编号 | 关联章节 | 事件摘要 | 涉及关键角色 | 后续长远影响 | 状态 (持续影响/已完结平息) |
|---|---|---|---|---|---|
EOF

cat > "$MEMORY_DIR/story_bible.md" << 'EOF'
# 故事圣经 (STORY_BIBLE)
## 1. 基础世界背景

## 2. 力量/等级体系
| 境界/级别 | 能力特征 | 寿命上限 | 突破难度与标志 |
|---|---|---|---|

## 3. 核心社会规则与禁忌
EOF

cat > "$MEMORY_DIR/errors.md" << 'EOF'
# 穿帮与错误修正日志 (ERRORS)
| 错误ID | 发生章节 | 严重性 | 穿帮/逻辑漏洞描述 | 影响与修正方案 | 状态 (待解决/已修正规避) |
|---|---|---|---|---|---|
EOF

cat > "$MEMORY_DIR/foreshadowing.md" << 'EOF'
# 伏笔与暗线管理 (FORESHADOWING)
| 伏笔编号 | 埋设章节 | 抛出的线索/悬念表象 | 设计目的/暗线真相(只有你懂) | 计划回收节点 | 状态 (未回收/部分暗示/已完全回收) |
|---|---|---|---|---|---|
EOF

cat > "$MEMORY_DIR/items.md" << 'EOF'
# 物品与线索档案 (ITEMS)
| 物品名称 | 获得章节 | 物品类型 | 特征效果与副作用 | 当前持有者 | 状态 (完好/受损/已消耗/已销毁/遗失) | 流转与消耗记录 |
|---|---|---|---|---|---|---|
EOF

echo -e "${CYAN}[步骤]${NC} 初始化 plan 计划系统..."

cat > "$PLAN_DIR/outline.md" << 'EOF'
# 《大纲与规划》 (OUTLINE)
全书总大纲与各卷摘要。根据大纲粗略规划后续写作方向和大致剧情。
EOF

cat > "$PLAN_DIR/current_unit.md" << 'EOF'
# 最小剧情单元档案 (CURRENT_UNIT)
记录最近 3-5 章的具体微观任务、计谋或局部冲突。创作时优先读取此文件。
EOF

cat > "$PLAN_DIR/current_arc.md" << 'EOF'
# 当前期单元剧集/阶段档案 (CURRENT_ARC)
记录当前剧情单元（卷/大剧集）的核心设计。
EOF

touch "$OUTPUT_DIR/.gitkeep"

echo -e "\n${GREEN}[信息]${NC} 《${NOVEL_NAME}》工作区初始化完成！"
echo "后续步骤:"
echo "  向 AI 发送指令: 帮我写一部名为《${NOVEL_NAME}》的小说。"
