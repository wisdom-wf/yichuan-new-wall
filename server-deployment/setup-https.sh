#!/bin/bash
# 宜川大屏HTTPS部署脚本

echo "开始配置HTTPS访问..."

# 备份原配置
sudo cp /etc/nginx/sites-enabled/wisdomdance.conf /etc/nginx/sites-enabled/wisdomdance.conf.backup

# 在现有配置中添加ycjctx路径
sudo sed -i '/location \/ {/i\
    # 宜川县域监测体系整合平台\
    location /ycjctx/ {\
        alias /var/www/html/ycjctx/;\
        index index.html;\
        try_files \$uri \$uri/ /ycjctx/index.html;\
        \
        # 静态资源配置\
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)\$ {\
            expires 1y;\
            add_header Cache-Control "public, immutable";\
            add_header Access-Control-Allow-Origin "*";\
        }\
    }\
    \
' /etc/nginx/sites-enabled/wisdomdance.conf

# 测试配置
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "Nginx配置测试通过"
    # 重新加载Nginx
    sudo systemctl reload nginx
    echo "Nginx已重新加载"
    
    # 测试HTTPS访问
    curl -I https://www.wisdomdance.cn/ycjctx/ 2>/dev/null | head -1
    
    echo "部署完成！"
    echo "访问地址: https://www.wisdomdance.cn/ycjctx/"
else
    echo "Nginx配置测试失败，恢复原配置"
    sudo cp /etc/nginx/sites-enabled/wisdomdance.conf.backup /etc/nginx/sites-enabled/wisdomdance.conf
    sudo nginx -t && sudo systemctl reload nginx
fi