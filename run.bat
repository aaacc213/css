@echo off

REM ================ 部署前注意事项 ================
REM 1. 确保您已经安装了Node.js和npm
REM 2. 确保您已经在GitHub上创建了对应的仓库
REM 3. 首次运行时，Git可能会提示您输入GitHub的用户名和密码或个人访问令牌
REM 4. 脚本中的 -f 参数用于强制推送，仅在首次部署时可能需要
REM 5. 部署完成后，您的网站通常会在几分钟内上线
REM ==============================================

REM 检查是否安装了Node.js和npm
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 未找到Node.js。请先运行install_nodejs.bat安装Node.js和npm。
    pause
    exit /b 1
)

where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 未找到npm。请先运行install_nodejs.bat安装Node.js和npm。
    pause
    exit /b 1
)

REM 获取用户输入的GitHub用户名和仓库名
set /p github_username=请输入您的GitHub用户名: 
set /p github_repo=请输入您的GitHub仓库名: 

REM 初始化npm项目
if not exist package.json (
    echo 正在初始化npm项目...
npm init -y
    if %ERRORLEVEL% NEQ 0 (
        echo 错误: 初始化npm项目失败。
        pause
        exit /b 1
    )
)

REM 创建.gitignore文件
if not exist .gitignore (
    echo 正在创建.gitignore文件...
    echo node_modules/ > .gitignore
    echo package-lock.json >> .gitignore
    echo .DS_Store >> .gitignore
    echo 已创建.gitignore文件。
)

REM 安装gh-pages工具
npm list gh-pages || npm install gh-pages --save-dev
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 安装gh-pages失败。
    pause
    exit /b 1
)

REM 配置package.json
echo 正在配置package.json...
node -e "const fs = require('fs'); const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8')); pkg.homepage = 'https://%github_username%.github.io/%github_repo%/'; pkg.scripts = pkg.scripts || {}; pkg.scripts.deploy = 'gh-pages -d .'; fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));"
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 配置package.json失败。
    pause
    exit /b 1
)

REM 初始化Git仓库
if not exist .git (
    echo 正在初始化Git仓库...
    git init
    if %ERRORLEVEL% NEQ 0 (
        echo 错误: 初始化Git仓库失败。
        pause
        exit /b 1
    )
)

REM 提交代码
echo 正在提交代码...
git add .
git commit -m "Deploy to GitHub Pages"
if %ERRORLEVEL% NEQ 0 (
    echo 警告: 提交代码失败，可能是没有修改内容。
)

REM 关联GitHub远程仓库
git remote | findstr /i origin >nul
if %ERRORLEVEL% NEQ 0 (
    echo 正在关联GitHub远程仓库...
    git remote add origin https://github.com/%github_username%/%github_repo%.git
    if %ERRORLEVEL% NEQ 0 (
        echo 错误: 关联GitHub远程仓库失败。
        pause
        exit /b 1
    )
)

REM 推送代码到GitHub
echo 正在推送代码到GitHub...
git push -u origin main -f
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 推送代码到GitHub失败。
    pause
    exit /b 1
)

REM 部署网站到GitHub Pages
echo 正在部署网站到GitHub Pages...
npm run deploy
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 部署网站失败。
    pause
    exit /b 1
)

echo 部署成功! 您的网站将很快在 https://%github_username%.github.io/%github_repo%/ 可用。
pause