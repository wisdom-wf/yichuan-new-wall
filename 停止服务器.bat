@echo off
title 宜川大屏系统 - 停止服务
color 0C

echo ========================================
echo   宜川县域监测体系整合平台
echo   停止服务脚本
echo ========================================
echo.

:: 检查Nginx进程
echo [信息] 正在检查Nginx服务状态...
tasklist | findstr nginx >nul
if %errorLevel% == 0 (
    echo [信息] 检测到Nginx正在运行
) else (
    echo [信息] Nginx服务未运行
    echo.
    pause
    exit /b 0
)

:: 停止Nginx服务
echo.
echo [信息] 正在停止Nginx服务...
echo.

:: 方式1：使用nginx -s stop命令
if exist "C:\nginx\nginx.exe" (
    echo [信息] 使用Nginx命令停止服务...
    C:\nginx\nginx.exe -s stop
    timeout /t 3 /nobreak >nul
)

:: 方式2：强制结束进程（备用方案）
echo [信息] 检查并强制结束残留进程...
taskkill /f /im nginx.exe >nul 2>&1

:: 验证停止状态
tasklist | findstr nginx >nul
if %errorLevel% == 0 (
    echo [警告] 部分Nginx进程仍在运行，可能需要手动结束
) else (
    echo [成功] Nginx服务已完全停止
)

echo.
echo ========================================
echo 服务停止完成
echo ========================================
echo.
pause