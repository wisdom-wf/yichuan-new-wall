@echo off
title 宜川大屏系统启动器
color 0A

echo ========================================
echo   宜川县域监测体系整合平台
echo   大屏展示系统启动器
echo ========================================
echo.

:: 检查是否以管理员身份运行
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [信息] 已获得管理员权限
) else (
    echo [警告] 建议以管理员身份运行此脚本
    echo.
)

:: 检查Nginx是否已安装
if exist "C:\nginx\nginx.exe" (
    echo [信息] 检测到Nginx安装
    set NGINX_PATH=C:\nginx\nginx.exe
) else (
    echo [错误] 未找到Nginx，请先安装Nginx
    echo 下载地址: https://nginx.org/en/download.html
    echo.
    pause
    exit /b 1
)

:: 检查部署文件是否存在
if exist "dist\index.html" (
    echo [信息] 部署文件检查通过
) else (
    echo [错误] 未找到部署文件，请确保在正确的目录下运行
    echo 需要包含dist文件夹
    echo.
    pause
    exit /b 1
)

:: 启动Nginx
echo.
echo [信息] 正在启动Nginx服务...
echo 配置文件路径: %cd%\nginx.conf
echo 网站根目录: %cd%\dist
echo.

:: 复制配置文件（如果存在）
if exist "nginx.conf" (
    echo [信息] 复制Nginx配置文件...
    copy "nginx.conf" "C:\nginx\conf\nginx.conf" /Y >nul
)

:: 启动Nginx服务
%NGINX_PATH% -c "C:\nginx\conf\nginx.conf"

if %errorLevel% == 0 (
    echo [成功] Nginx服务启动成功！
    echo.
    echo ========================================
    echo 访问地址: http://localhost
    echo 系统分辨率: 7680×1080
    echo ========================================
    echo.
    echo 按任意键打开浏览器访问系统...
    pause >nul
    
    :: 打开浏览器
    start http://localhost
    
    echo.
    echo 系统已启动，请不要关闭此窗口
    echo 如需停止服务，请运行 stop-server.bat
    echo.
    pause
) else (
    echo [错误] Nginx启动失败，请检查配置
    echo.
    pause
)