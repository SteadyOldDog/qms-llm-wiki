# ========================================
# QMS LLM Wiki GitHub 推送脚本
# ========================================
# 用法：在 PowerShell 中运行此脚本
# .\push_to_github.ps1

cd "D:\Documents\HermesProjects\qms-llm-wiki-site"

Write-Host "请粘贴你的 GitHub Personal Access Token:" -ForegroundColor Yellow
$token = Read-Host

# 配置远程仓库
git remote set-url origin "https://${token}@github.com/SteadyOldDog/qms-llm-wiki.git"

# 推送
Write-Host "正在推送代码到 GitHub..." -ForegroundColor Cyan
git push -u origin master

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 推送成功！" -ForegroundColor Green
    Write-Host "仓库地址：https://github.com/SteadyOldDog/qms-llm-wiki" -ForegroundColor Green
    Write-Host "网站地址：https://steadyolddog.github.io/qms-llm-wiki/" -ForegroundColor Green
} else {
    Write-Host "❌ 推送失败，请检查网络连接" -ForegroundColor Red
}
