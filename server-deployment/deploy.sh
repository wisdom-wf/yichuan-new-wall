#!/bin/bash

# 宜川县域监测体系整合平台 - 服务器部署脚本
# 目标服务器: 43.153.213.134
# 访问路径: /ycjctx/

echo "========================================"
echo "  宜川县域监测体系整合平台部署脚本"
echo "  版本: v2.5.1"
echo "  部署路径: /ycjctx/"
echo "========================================"
echo ""

# 配置变量
SERVER_IP="43.153.213.134"
DEPLOY_PATH="/var/www/html/ycjctx"
LOCAL_PATH="/Volumes/works/my-projects/yichuan-new-wall/server-deployment"

echo "1. 准备部署文件..."
cd "$LOCAL_PATH"

# 创建压缩包
echo "   -> 创建部署包..."
tar -czf ycjctx-deployment.tar.gz *

echo "2. 连接服务器并部署..."
echo "   -> 正在连接到服务器 $SERVER_IP..."

# SSH连接并部署
sshpass -p "w00135950F" ssh ubuntu@$SERVER_IP << 'EOF'
    # 创建部署目录
    echo "   -> 创建部署目录..."
    sudo mkdir -p /var/www/html/ycjctx
    
    # 备份现有文件（如果存在）
    if [ -d "/var/www/html/ycjctx" ] && [ "$(ls -A /var/www/html/ycjctx)" ]; then
        echo "   -> 备份现有文件..."
        BACKUP_NAME="ycjctx-backup-$(date +%Y%m%d-%H%M%S)"
        sudo mv /var/www/html/ycjctx /var/www/html/$BACKUP_NAME
        sudo mkdir -p /var/www/html/ycjctx
    fi
EOF

echo "3. 上传文件..."
sshpass -p "w00135950F" scp ycjctx-deployment.tar.gz ubuntu@$SERVER_IP:/tmp/

# 在服务器上解压和配置
sshpass -p "w00135950F" ssh ubuntu@$SERVER_IP << 'EOF'
    echo "4. 解压和配置文件..."
    
    # 解压部署包
    cd /var/www/html/ycjctx
    sudo tar -xzf /tmp/ycjctx-deployment.tar.gz
    
    # 设置文件权限
    echo "   -> 设置文件权限..."
    sudo chown -R www-data:www-data /var/www/html/ycjctx
    sudo chmod -R 755 /var/www/html/ycjctx
    
    # 配置Nginx（如果nginx.conf存在）
    if [ -f "/var/www/html/ycjctx/nginx.conf" ]; then
        echo "   -> 配置Nginx..."
        sudo cp /var/www/html/ycjctx/nginx.conf /etc/nginx/sites-available/ycjctx
        sudo ln -sf /etc/nginx/sites-available/ycjctx /etc/nginx/sites-enabled/
        # 测试nginx配置
        sudo nginx -t
        if [ $? -eq 0 ]; then
            sudo systemctl reload nginx
            echo "   ✓ Nginx配置已更新"
        else
            echo "   ⚠ Nginx配置测试失败，请手动检查"
        fi
    fi
    
    # 清理临时文件
    sudo rm -f /tmp/ycjctx-deployment.tar.gz
    sudo rm -f /var/www/html/ycjctx/nginx.conf
    
    echo "   ✓ 部署完成!"
EOF

echo ""
echo "========================================"
echo "部署完成!"
echo "访问地址: http://43.153.213.134/ycjctx/"
echo "部署时间: $(date)"
echo "========================================"