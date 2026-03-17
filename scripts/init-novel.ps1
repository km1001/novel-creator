<#
.SYNOPSIS
初始化 Novel Creator 2.0 工作区
.DESCRIPTION
支持 minimal / full 两种模式，创建 output、plan、memory、manifest.json，
并在清空旧工作区前自动备份到 backup/ 时间戳目录。
#>
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$NovelName,

    [ValidateSet("minimal", "full")]
    [string]$Mode = "full",

    [switch]$Clean
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BaseDir = Split-Path -Parent $ScriptDir
$OutputDir = Join-Path $BaseDir "output"
$MemoryDir = Join-Path $BaseDir "memory"
$PlanDir = Join-Path $BaseDir "plan"
$BackupDir = Join-Path $BaseDir "backup"
$ManifestPath = Join-Path $BaseDir "manifest.json"

Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Novel Creator 2.0 - 初始化工作区" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  小说名称: 《$NovelName》" -ForegroundColor Green
Write-Host "  初始化模式: $Mode" -ForegroundColor Green

function Write-MarkdownFile {
    param(
        [string]$Path,
        [string]$Content
    )
    Set-Content -Path $Path -Value $Content -Encoding UTF8
}

function Backup-Workspace {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $target = Join-Path $BackupDir $timestamp
    New-Item -ItemType Directory -Path $target -Force | Out-Null

    foreach ($path in @($OutputDir, $MemoryDir, $PlanDir, $ManifestPath)) {
        if (Test-Path $path) {
            Copy-Item -Path $path -Destination $target -Recurse -Force
        }
    }

    Write-Host "[备份] 已备份旧工作区到 $target" -ForegroundColor Yellow
}

if ($Clean) {
    if ((Test-Path $OutputDir) -or (Test-Path $MemoryDir) -or (Test-Path $PlanDir) -or (Test-Path $ManifestPath)) {
        Write-Host "[步骤] 备份旧工作区..." -ForegroundColor Cyan
        Backup-Workspace
    }
    Write-Host "[步骤] 清除旧的输出文件..." -ForegroundColor Cyan
    if (Test-Path $OutputDir) { Remove-Item "$OutputDir\*.md" -Force -Recurse -ErrorAction SilentlyContinue }
    Write-Host "[步骤] 清理旧 memory 和 plan..." -ForegroundColor Cyan
    if (Test-Path $MemoryDir) { Remove-Item $MemoryDir -Force -Recurse -ErrorAction SilentlyContinue }
    if (Test-Path $PlanDir) { Remove-Item $PlanDir -Force -Recurse -ErrorAction SilentlyContinue }
    if (Test-Path $ManifestPath) { Remove-Item $ManifestPath -Force -ErrorAction SilentlyContinue }
}

Write-Host "[步骤] 创建目录..." -ForegroundColor Cyan
if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir | Out-Null }
if (-not (Test-Path $MemoryDir)) { New-Item -ItemType Directory -Path $MemoryDir | Out-Null }
if (-not (Test-Path $PlanDir)) { New-Item -ItemType Directory -Path $PlanDir | Out-Null }
if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir | Out-Null }

Write-Host "[步骤] 初始化 plan 计划系统..." -ForegroundColor Cyan
Write-MarkdownFile -Path "$PlanDir\outline.md" -Content "# 《$NovelName》大纲与规划`n`n- 类型：待补全`n- 模式：待补全`n- 全书目标：待补全"
Write-MarkdownFile -Path "$PlanDir\current_unit.md" -Content "# 最小剧情单元档案 (CURRENT_UNIT)`n`n记录最近 3-5 章的具体推进、冲突与任务。`n`n## 核心任务`n- 目标：待补全`n- 涉及人物：待补全`n- 关键博弈点：待补全`n- 这个单元存在的意义：待补全`n`n## 章节精细推演`n| 章节 | 任务/计谋分解 | 这一章存在的意义 | 预期字数 | 关键细节/伏笔要求 |`n|---|---|---|---|---|`n`n## 单元 / 事件完成后的合理性复盘`n- 这个单元存在的意义是否真正完成：待复盘`n- 删掉本单元后，故事会不会更紧：待复盘`n- 人物行为是否前后一致：待复盘`n- 事件推进是否过巧：待复盘`n- 题材容错标准：纪实类文学严格检查；网络爽文允许小 bug，但不允许关键因果断裂"
Write-MarkdownFile -Path "$PlanDir\style_guide.md" -Content "# 文风预热卡 (STYLE_GUIDE)`n`n- 题材：待确认`n- 叙事温度：待提炼`n- 句式节奏：待提炼`n- 对白习惯：待提炼`n- 常用意象/词汇场：待提炼`n- 禁忌写法：待提炼`n- 去 AI 注意点：待提炼`n- 本书专属偏好：待提炼"

if ($Mode -eq "full") {
    Write-MarkdownFile -Path "$PlanDir\current_arc.md" -Content "# 当前大单元剧集/阶段档案 (CURRENT_ARC)`n`n记录当前卷/当前阶段的核心目标、势力、冲突与回收点。`n`n- 起止规划：待补全`n- 本篇章核心目标/作用：待补全`n- 这个篇章存在的意义：待补全`n- 发生地：待补全`n`n## 篇章完成后的合理性复盘`n- 是否完成了本篇章存在的意义：待复盘`n- 人物行为是否合理：待复盘`n- 因果链是否清楚：待复盘`n- 题材容错标准：纪实类文学原则上不允许明显 bug；网络爽文允许轻微便利性 bug，但不得伤及主线逻辑"
}

Write-Host "[步骤] 初始化 memory 记忆库..." -ForegroundColor Cyan
Write-MarkdownFile -Path "$MemoryDir\roles.md" -Content "# 角色档案 (ROLES)`n`n> 说明：现实题材至少记录【性别】；奇幻/科幻/异种题材额外记录【种族/物种】。如无特殊设定，可写“人类”。`n`n| 角色姓名 | 首次出场 | 性别 | 种族/物种 | 年龄/外表年龄 | 身份/阵营 | 当前等级/实力 | 核心性格/动机 | 标志性特征 | 状态 | 关键经历/近期目的 |`n|---|---|---|---|---|---|---|---|---|---|---|"
Write-MarkdownFile -Path "$MemoryDir\plot_points.md" -Content "# 关键情节档案 (PLOT_POINTS)`n| 情节编号 | 关联章节 | 事件摘要 | 涉及关键角色 | 后续长远影响 | 状态 |`n|---|---|---|---|---|---|"
Write-MarkdownFile -Path "$MemoryDir\story_bible.md" -Content "# 故事圣经 (STORY_BIBLE)`n`n## 1. 基础世界背景`n`n## 2. 力量/等级体系`n| 境界/级别 | 能力特征 | 寿命上限 | 突破难度与标志 |`n|---|---|---|---|`n`n## 3. 核心社会规则与禁忌"

if ($Mode -eq "full") {
    Write-MarkdownFile -Path "$MemoryDir\locations.md" -Content "# 地点档案 (LOCATIONS)`n| 地点名称 | 首次出场 | 所属势力 | 环境/氛围特征 | 重要历史事件 | 状态 |`n|---|---|---|---|---|---|"
    Write-MarkdownFile -Path "$MemoryDir\errors.md" -Content "# 穿帮与错误修正日志 (ERRORS)`n| 错误ID | 发生章节 | 严重性 | 穿帮/逻辑漏洞描述 | 影响与修正方案 | 状态 |`n|---|---|---|---|---|---|"
    Write-MarkdownFile -Path "$MemoryDir\foreshadowing.md" -Content "# 伏笔与暗线管理 (FORESHADOWING)`n| 伏笔编号 | 埋设章节 | 抛出的线索/悬念表象 | 设计目的/暗线真相 | 计划回收节点 | 状态 |`n|---|---|---|---|---|---|"
    Write-MarkdownFile -Path "$MemoryDir\items.md" -Content "# 物品与线索档案 (ITEMS)`n| 物品名称 | 获得章节 | 物品类型 | 特征效果与副作用 | 当前持有者 | 状态 | 流转与消耗记录 |`n|---|---|---|---|---|---|---|"
}

New-Item -ItemType File -Path "$OutputDir\.gitkeep" -Force | Out-Null

$manifest = [ordered]@{
    novel_name = $NovelName
    init_mode = $Mode
    created_at = (Get-Date).ToString("s")
    current_chapter = 0
    current_arc = ""
    status = "active"
}
$manifest | ConvertTo-Json | Set-Content -Path $ManifestPath -Encoding UTF8

Write-Host "`n[信息] 《$NovelName》工作区初始化完成！" -ForegroundColor Green
Write-Host "后续步骤:"
Write-Host "  1. 确认题材与模式"
Write-Host "  2. 先执行文风预热，填写 plan/style_guide.md"
Write-Host "  3. 再开始样章或正文创作"
