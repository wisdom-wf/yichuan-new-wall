# 宜川县域监测体系整合平台服务器部署说明

## 部署信息
- **版本**: v2.5.1
- **服务器IP**: 43.153.213.134
- **访问路径**: /ycjctx/
- **完整访问地址**: http://43.153.213.134/ycjctx/

## 部署包内容
```
server-deployment/
├── index.html          # 主页面文件
├── js/                # JavaScript文件
├── images/            # 图片资源
├── nginx.conf         # Nginx配置文件
└── deploy.sh          # 自动部署脚本
```

## 部署方式

### 方式一：自动部署（推荐）
```bash
# 在本地执行自动部署脚本
cd /Volumes/works/my-projects/yichuan-new-wall/server-deployment
./deploy.sh
```

### 方式二：手动部署
1. 将部署包上传到服务器：
```bash
scp -r /Volumes/works/my-projects/yichuan-new-wall/server-deployment/* root@43.153.213.134:/var/www/html/ycjctx/
```

2. 在服务器上设置权限：
```bash
ssh root@43.153.213.134
cd /var/www/html/ycjctx
chown -R www-data:www-data .
chmod -R 755 .
```

3. 配置Nginx（如果需要）：
```bash
# 复制nginx配置
cp nginx.conf /etc/nginx/sites-available/ycjctx
ln -s /etc/nginx/sites-available/ycjctx /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
```

## 访问验证
部署完成后，可通过以下地址访问：
- **主访问地址**: http://43.153.213.134/ycjctx/
- **备用访问地址**: http://43.153.213.134/ycjctx/index.html

## 注意事项
1. 确保服务器已安装Nginx
2. 确保服务器防火墙开放80端口
3. 如有SSL证书，可配置HTTPS访问
4. 部署脚本会自动备份现有文件

## 版本历史
- v2.5.1 (2026-03-11): 布局优化，消除右侧空白
- v2.5.0 (2026-03-11): 增加模块间距，重新分配宽度
- v2.4.2 (2026-03-11): 修复updateSoilData方法错误
- v2.4.1 (2026-03-11): 添加刷新按钮功能