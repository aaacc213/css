@echo off

REM ================ Node.js和npm安装脚本 ================
REM 此脚本将下载并安装最新版本的Node.js和npm
REM 安装完成后，您需要重新打开命令提示符才能使用Node.js和npm
REM =====================================================

echo 正在检查是否已安装Node.js...
where node >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Node.js已安装。版本信息:
    node -v
    echo npm已安装。版本信息:
    npm -v
    echo 如果需要更新Node.js，请访问官方网站下载最新版本。
    pause
    exit /b 0
)

echo 未找到Node.js。开始下载和安装...

REM 创建临时目录
if not exist temp mkdir temp
cd temp

REM 下载Node.js安装程序 (64位)
echo 正在下载Node.js安装程序...
powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/latest/node-v20.12.2-x64.msi' -OutFile 'node-installer.msi'"
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 下载Node.js安装程序失败。
    cd ..
    rmdir /s /q temp
    pause
    exit /b 1
)

REM 安装Node.js
echo 正在安装Node.js...
msiexec /i node-installer.msi /qn /norestart
if %ERRORLEVEL% NEQ 0 (
    echo 错误: 安装Node.js失败。
    cd ..
    rmdir /s /q temp
    pause
    exit /b 1
)

echo Node.js安装成功!

REM 清理临时文件
echo 正在清理临时文件...
cd ..
rmdir /s /q temp

REM 添加Node.js到PATH环境变量 (可能需要重启命令提示符)
echo 正在配置环境变量...
setx PATH "%PATH%;C:\Program Files\nodejs\" /M
if %ERRORLEVEL% NEQ 0 (
    echo 警告: 配置环境变量失败。您可能需要手动将Node.js添加到PATH。
)

REM 验证安装
echo 安装完成。请重新打开命令提示符并运行以下命令验证安装:
 echo node -v
 echo npm -v

pause