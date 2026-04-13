<#
.SYNOPSIS
初始化 novel-creator 3.0 工作区
.DESCRIPTION
支持 minimal / full 两种模式，创建 output、plan、memory、manifest.json，
并在清空旧工作区前自动备份到 backup/ 时间戳目录。
#>
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$NovelName,

    [ValidateSet("minimal", "full")]
    [string]$Mode = "full",

    [switch]$Clean,

    [string]$TargetDir = "."
)

$ResolvedTargetDir = if ([System.IO.Path]::IsPathRooted($TargetDir)) {
    $TargetDir
} else {
    Join-Path (Get-Location) $TargetDir
}

if (-not (Test-Path -LiteralPath $ResolvedTargetDir)) {
    New-Item -ItemType Directory -Path $ResolvedTargetDir -Force | Out-Null
}

$BaseDir = (Resolve-Path -LiteralPath $ResolvedTargetDir).Path
$SkillDir = Split-Path -Parent $PSScriptRoot
$InitTemplateDir = Join-Path $SkillDir "assets\init"
$OutputDir = Join-Path $BaseDir "output"
$MemoryDir = Join-Path $BaseDir "memory"
$PlanDir = Join-Path $BaseDir "plan"
$BackupDir = Join-Path $BaseDir "backup"
$ManifestPath = Join-Path $BaseDir "manifest.json"

Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  novel-creator 3.0 - 初始化工作区" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  小说名称: 《$NovelName》" -ForegroundColor Green
Write-Host "  初始化模式: $Mode" -ForegroundColor Green
Write-Host "  工作目录: $BaseDir" -ForegroundColor Green

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
    Write-Host "[步骤] 清除旧的输出目录..." -ForegroundColor Cyan
    if (Test-Path $OutputDir) { Remove-Item $OutputDir -Force -Recurse -ErrorAction SilentlyContinue }
    Write-Host "[步骤] 清理旧 memory 和 plan..." -ForegroundColor Cyan
    if (Test-Path $MemoryDir) { Remove-Item $MemoryDir -Force -Recurse -ErrorAction SilentlyContinue }
    if (Test-Path $PlanDir) { Remove-Item $PlanDir -Force -Recurse -ErrorAction SilentlyContinue }
    if (Test-Path $ManifestPath) { Remove-Item $ManifestPath -Force -ErrorAction SilentlyContinue }
}

function Get-TemplateContent {
    param(
        [string]$TemplateName,
        [hashtable]$Replacements
    )

    $templatePath = Join-Path $InitTemplateDir $TemplateName
    $content = Get-Content -LiteralPath $templatePath -Raw -Encoding UTF8

    foreach ($key in $Replacements.Keys) {
        $content = $content.Replace("{{${key}}}", $Replacements[$key])
    }

    return $content
}

Write-Host "[步骤] 创建目录..." -ForegroundColor Cyan
if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir | Out-Null }
if (-not (Test-Path $MemoryDir)) { New-Item -ItemType Directory -Path $MemoryDir | Out-Null }
if (-not (Test-Path $PlanDir)) { New-Item -ItemType Directory -Path $PlanDir | Out-Null }
if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir | Out-Null }

$templateReplacements = @{
    NOVEL_NAME = $NovelName
    MODE = $Mode
    CREATED_AT = (Get-Date).ToString("s")
}

Write-Host "[步骤] 初始化 plan 计划系统..." -ForegroundColor Cyan
Write-MarkdownFile -Path "$PlanDir\outline.md" -Content (Get-TemplateContent -TemplateName "outline.md" -Replacements $templateReplacements)
Write-MarkdownFile -Path "$PlanDir\current_unit.md" -Content (Get-TemplateContent -TemplateName "current_unit.md" -Replacements $templateReplacements)
Write-MarkdownFile -Path "$PlanDir\style_guide.md" -Content (Get-TemplateContent -TemplateName "style_guide.md" -Replacements $templateReplacements)

if ($Mode -eq "full") {
    Write-MarkdownFile -Path "$PlanDir\current_arc.md" -Content (Get-TemplateContent -TemplateName "current_arc.md" -Replacements $templateReplacements)
}

Write-Host "[步骤] 初始化 memory 记忆库..." -ForegroundColor Cyan
Write-MarkdownFile -Path "$MemoryDir\roles.md" -Content (Get-TemplateContent -TemplateName "roles.md" -Replacements $templateReplacements)
Write-MarkdownFile -Path "$MemoryDir\plot_points.md" -Content (Get-TemplateContent -TemplateName "plot_points.md" -Replacements $templateReplacements)
Write-MarkdownFile -Path "$MemoryDir\story_bible.md" -Content (Get-TemplateContent -TemplateName "story_bible.md" -Replacements $templateReplacements)

if ($Mode -eq "full") {
    Write-MarkdownFile -Path "$MemoryDir\locations.md" -Content (Get-TemplateContent -TemplateName "locations.md" -Replacements $templateReplacements)
    Write-MarkdownFile -Path "$MemoryDir\errors.md" -Content (Get-TemplateContent -TemplateName "errors.md" -Replacements $templateReplacements)
    Write-MarkdownFile -Path "$MemoryDir\foreshadowing.md" -Content (Get-TemplateContent -TemplateName "foreshadowing.md" -Replacements $templateReplacements)
    Write-MarkdownFile -Path "$MemoryDir\items.md" -Content (Get-TemplateContent -TemplateName "items.md" -Replacements $templateReplacements)
}

New-Item -ItemType File -Path "$OutputDir\.gitkeep" -Force | Out-Null
Set-Content -Path $ManifestPath -Value (Get-TemplateContent -TemplateName "manifest.json" -Replacements $templateReplacements) -Encoding UTF8

Write-Host "`n[信息] 《$NovelName》工作区初始化完成！" -ForegroundColor Green
Write-Host "后续步骤:"
Write-Host "  1. 确认题材与模式"
Write-Host "  2. 先执行文风预热，填写 plan/style_guide.md"
Write-Host "  3. 再开始样章或正文创作"
