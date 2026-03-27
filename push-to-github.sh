#!/bin/bash

# 宜川大屏系统 - 推送到 GitHub 脚本
# 使用方法：
# 1. 在 GitHub 上创建仓库：https://github.com/new
# 2. 仓库名：yichuan-new-wall
# 3. 复制此脚本并修改 YOUR_USERNAME 为你的 GitHub 用户名
# 4. 运行脚本

echo "======================================"
echo "推送宜川大屏系统到 GitHub"
echo "======================================"
echo ""

# 设置你的 GitHub 用户名
YOUR_USERNAME="wfanang"
REPO_NAME="yichuan-new-wall"

echo "正在添加远程仓库..."
git remote add origin git@github.com:${YOUR_USERNAME}/${REPO_NAME}.git

echo ""
echo "正在推送代码到 GitHub..."
git branch -M main
git push -u origin main

echo ""
echo "======================================"
echo "✅ 推送完成！"
echo "======================================"
echo ""
echo "访问以下地址查看你的项目："
echo "https://github.com/${YOUR_USERNAME}/${REPO_NAME}"
echo ""
echo "如需更新代码，运行："
echo "  git push origin main"
echo ""
