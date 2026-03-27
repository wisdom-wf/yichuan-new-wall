@echo off
chcp 65001 >nul
echo ========================================
echo   宜川大屏系统 - 代理服务（调试模式）
echo ========================================
echo.

:: 检查Node.js是否安装
node -v >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Node.js，请先安装Node.js
    pause
    exit /b 1
)

echo [✓] Node.js已安装
node -v
echo.

:: 检查配置文件是否存在
if not exist "config.json" (
    echo [错误] 未找到配置文件 config.json
    pause
    exit /b 1
)

echo [✓] 配置文件存在
echo.

:: 安装依赖（如果需要）
if not exist "node_modules" (
    echo [*] 正在安装依赖...
    npm install express http-proxy-middleware cors
    if errorlevel 1 (
        echo [错误] 依赖安装失败
        pause
        exit /b 1
    )
    echo [✓] 依赖安装完成
) else (
    echo [✓] 依赖已安装
)

echo.
echo ========================================
echo [*] 正在启动调试版代理服务...
echo [*] 按 Ctrl+C 停止服务
echo ========================================
echo.

:: 启动调试版代理服务
node proxy-server-debug.js

pause
