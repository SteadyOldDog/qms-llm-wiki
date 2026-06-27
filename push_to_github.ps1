# ========================================
# QMS LLM Wiki GitHub 推送脚本
# ========================================

cd "D:\Documents\HermesProjects\qms-llm-wiki-site"

Write-Host "正在提交更改..." -ForegroundColor Cyan
git add .
git commit -m "更新 Wiki 内容 $(Get-Date -Format 'yyyy-MM-dd')" 2>&1

Write-Host "正在推送到 GitHub..." -ForegroundColor Cyan
git push -u origin master 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 推送成功！" -ForegroundColor Green
    Write-Host "仓库: https://github.com/SteadyOldDog/qms-llm-wiki" -ForegroundColor Gray
} else {
    Write-Host "❌ 推送失败，请检查网络连接" -ForegroundColor Red
}
