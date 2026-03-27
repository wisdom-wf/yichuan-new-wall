@echo off
chcp 65001 >nul
title 宜川县域监测体系整合平台 - 启动程序

echo ========================================
echo   宜川县域监测体系整合平台 v2.5.2
echo ========================================
echo.

REM 检查Node.js是否安装
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 未检测到Node.js环境
    echo 请先安装Node.js LTS版本
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js环境检测正常
echo 正在启动服务器...

REM 进入部署包目录
cd /d "%~dp0.."

REM 检查http-server是否已安装
npm list -g http-server >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在安装http-server...
    npm install -g http-server
    if %errorlevel% neq 0 (
        echo 错误: http-server安装失败
        pause
        exit /b 1
    )
)

echo 启动服务器，端口: 8080
echo 访问地址: http://localhost:8080
echo 按 Ctrl+C 停止服务器

REM 启动http-server
http-server ./dist -p 8080 -a 0.0.0.0 --cors

pause