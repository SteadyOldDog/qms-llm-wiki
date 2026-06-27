# ========================================
# QMS LLM Wiki 同步脚本
# 将 wiki 源文件同步到部署目录并重建网站
# ========================================

$wiki = "D:\Documents\HermesProjects\qms-llm-wiki"
$site = "D:\Documents\HermesProjects\qms-llm-wiki-site"
$docs = "$site\docs"

Write-Host "正在同步 Wiki 文件..." -ForegroundColor Cyan

# 清理 docs 目录
Remove-Item "$docs\*" -Recurse -Force -ErrorAction SilentlyContinue

# 复制核心文件
Copy-Item "$wiki\index.md" "$docs\index.md" -Force
Copy-Item "$wiki\log.md" "$docs\log.md" -Force
Copy-Item "$wiki\SCHEMA.md" "$docs\SCHEMA.md" -Force

# 复制各分类目录
$dirs = @("entities", "concepts", "comparisons", "queries")
foreach ($d in $dirs) {
    $src = "$wiki\$d"
    $dst = "$docs\$d"
    if (Test-Path $src) {
        New-Item -Path $dst -ItemType Directory -Force | Out-Null
        Copy-Item "$src\*.md" "$dst\" -Force -ErrorAction SilentlyContinue
        $count = (Get-ChildItem "$dst\*.md" -ErrorAction SilentlyContinue | Measure-Object).Count
        Write-Host "  $d/: $count 个文件" -ForegroundColor Gray
    }
}

# 复制原始资料
$rawSrc = "$wiki\raw"
$rawDst = "$docs\raw"
if (Test-Path $rawSrc) {
    New-Item -Path $rawDst -ItemType Directory -Force | Out-Null
    Get-ChildItem "$rawSrc\*.md" -Recurse | ForEach-Object {
        $rel = $_.FullName.Replace("$rawSrc\", "")
        $targetDir = "$rawDst\$(Split-Path $rel -Parent)"
        if (!(Test-Path $targetDir)) { New-Item -Path $targetDir -ItemType Directory -Force | Out-Null }
        Copy-Item $_.FullName "$rawDst\$rel" -Force
    }
    Write-Host "  raw/: 已复制" -ForegroundColor Gray
}

Write-Host "文件同步完成！" -ForegroundColor Green

# 重建网站
Write-Host "正在重建网站..." -ForegroundColor Cyan
cd $site
mkdocs build --clean 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    $htmlCount = (Get-ChildItem "$site\site" -Recurse -Filter "*.html" | Measure-Object).Count
    Write-Host "✅ 网站重建成功！共 $htmlCount 个 HTML 页面" -ForegroundColor Green
    Write-Host "网站目录: $site\site" -ForegroundColor Gray
} else {
    Write-Host "❌ 网站重建失败" -ForegroundColor Red
}
