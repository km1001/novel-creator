<#
.SYNOPSIS
初始化 Novel Creator 工作区
.DESCRIPTION
为新小说创建 output 和 memory 目录，并初始化7个记忆库文件。
.PARAMETER NovelName
小说的名称
.PARAMETER Clean
清除旧输出和记忆库
#>
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$NovelName,
    
    [switch]$Clean
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BaseDir = Split-Path -Parent $ScriptDir
$OutputDir = Join-Path $BaseDir "output"
$MemoryDir = Join-Path $BaseDir "memory"
$PlanDir = Join-Path $BaseDir "plan"

Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Novel Creator - 初始化工作区" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  小说名称: 《$NovelName》" -ForegroundColor Green

if ($Clean) {
    Write-Host "[步骤] 清除旧的输出文件..." -ForegroundColor Cyan
    if (Test-Path $OutputDir) { Remove-Item "$OutputDir\*.md" -Force -Recurse -ErrorAction SilentlyContinue }
    Write-Host "[步骤] 清理旧 memory 和 plan..." -ForegroundColor Cyan
    if (Test-Path $MemoryDir) { Remove-Item $MemoryDir -Force -Recurse -ErrorAction SilentlyContinue }
    if (Test-Path $PlanDir) { Remove-Item $PlanDir -Force -Recurse -ErrorAction SilentlyContinue }
}

Write-Host "[步骤] 创建目录..." -ForegroundColor Cyan
if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir | Out-Null }
if (-not (Test-Path $MemoryDir)) { New-Item -ItemType Directory -Path $MemoryDir | Out-Null }
if (-not (Test-Path $PlanDir)) { New-Item -ItemType Directory -Path $PlanDir | Out-Null }

Write-Host "[步骤] 初始化 memory 记忆库..." -ForegroundColor Cyan

Set-Content -Path "$MemoryDir\roles.md" -Value "# 角色档案 (ROLES)`n| 角色姓名 | 首次出场 | 身份/阵营 | 当前等级/实力 | 核心性格/动机 | 标志性特征 | 状态 (活跃/退场/死亡) | 关键经历/近期目的 |`n|---|---|---|---|---|---|---|---|" -Encoding UTF8
Set-Content -Path "$MemoryDir\locations.md" -Value "# 地点档案 (LOCATIONS)`n| 地点名称 | 首次出场 | 所属势力 | 环境/氛围特征 (感官描写) | 重要历史事件 | 状态 (正常/封禁/已毁/废弃) |`n|---|---|---|---|---|---|" -Encoding UTF8
Set-Content -Path "$MemoryDir\plot_points.md" -Value "# 关键情节档案 (PLOT_POINTS)`n| 情节编号 | 关联章节 | 事件摘要 | 涉及关键角色 | 后续长远影响 | 状态 (持续影响/已完结平息) |`n|---|---|---|---|---|---|" -Encoding UTF8
Set-Content -Path "$MemoryDir\story_bible.md" -Value "# 故事圣经 (STORY_BIBLE)`n## 1. 基础世界背景`n`n## 2. 力量/等级体系`n| 境界/级别 | 能力特征 | 寿命上限 | 突破难度与标志 |`n|---|---|---|---|`n`n## 3. 核心社会规则与禁忌" -Encoding UTF8
Set-Content -Path "$MemoryDir\errors.md" -Value "# 穿帮与错误修正日志 (ERRORS)`n| 错误ID | 发生章节 | 严重性 | 穿帮/逻辑漏洞描述 | 影响与修正方案 | 状态 (待解决/已修正规避) |`n|---|---|---|---|---|---|" -Encoding UTF8
Set-Content -Path "$MemoryDir\foreshadowing.md" -Value "# 伏笔与暗线管理 (FORESHADOWING)`n| 伏笔编号 | 埋设章节 | 抛出的线索/悬念表象 | 设计目的/暗线真相(只有你懂) | 计划回收节点 | 状态 (未回收/部分暗示/已完全回收) |`n|---|---|---|---|---|---|" -Encoding UTF8
Set-Content -Path "$MemoryDir\items.md" -Value "# 物品与线索档案 (ITEMS)`n| 物品名称 | 获得章节 | 物品类型 | 特征效果与副作用 | 当前持有者 | 状态 (完好/受损/已消耗/已销毁/遗失) | 流转与消耗记录 |`n|---|---|---|---|---|---|---|" -Encoding UTF8

Write-Host "[步骤] 初始化 plan 计划系统..." -ForegroundColor Cyan

Set-Content -Path "$PlanDir\outline.md" -Value "# 《大纲与规划》 (OUTLINE)`n全书总大纲与各卷摘要。根据大纲粗略规划后续写作方向和大致剧情。" -Encoding UTF8
Set-Content -Path "$PlanDir\current_unit.md" -Value "# 最小剧情单元档案 (CURRENT_UNIT)`n记录最近 3-5 章的具体微观任务、计谋或局部冲突。创作时优先读取此文件。" -Encoding UTF8
Set-Content -Path "$PlanDir\current_arc.md" -Value "# 当前大单元剧集/阶段档案 (CURRENT_ARC)`n记录当前剧情单元（卷/大剧集）的核心设计、背景与势力。" -Encoding UTF8

New-Item -ItemType File -Path "$OutputDir\.gitkeep" -Force | Out-Null

Write-Host "`n[信息] 《$NovelName》工作区初始化完成！" -ForegroundColor Green
Write-Host "后续步骤:"
Write-Host "  向 AI 发送指令: 帮我写一部名为《$NovelName》的小说。"
