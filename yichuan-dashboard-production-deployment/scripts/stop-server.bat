@echo off
chcp 65001 >nul
title 宜川县域监测体系整合平台 - 停止程序

echo 正在停止服务器...
echo.

REM 查找并终止http-server进程
for /f "tokens=2 delims=," %%i in ('tasklist /fi "imagename eq node.exe" /fo csv ^| findstr "http-server"') do (
    set pid=%%i
    goto :kill_process
)

:kill_process
if defined pid (
    echo 终止进程 PID: %pid%
    taskkill /pid %pid% /f >nul 2>&1
    if %errorlevel% equ 0 (
        echo 服务器已停止
    ) else (
        echo 无法终止进程
    )
) else (
    echo 未找到运行中的服务器进程
)

echo.
pause