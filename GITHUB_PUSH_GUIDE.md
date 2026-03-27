# 推送到 GitHub 指南

## 快速推送（推荐）

### 方式一：使用自动化脚本

1. **在 GitHub 上创建仓库**
   - 访问：https://github.com/new
   - 仓库名称：`yichuan-new-wall`
   - 设为私有仓库（可选）
   - **不要**勾选"Add a README file"、".gitignore"或"Choose a license"
   - 点击 "Create repository"

2. **运行推送脚本**
   ```bash
   ./push-to-github.sh
   ```

3. **完成！**
   - 访问：https://github.com/wfanang/yichuan-new-wall

---

### 方式二：手动推送

如果你更喜欢手动操作，请按以下步骤：

#### 1. 创建 GitHub 仓库
- 访问 https://github.com/new
- 仓库名：`yichuan-new-wall`
- 设为私有（可选）
- **不要初始化任何文件**
- 点击创建

#### 2. 添加远程仓库并推送

在终端中执行以下命令：

```bash
# 添加远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin git@github.com:YOUR_USERNAME/yichuan-new-wall.git

# 确保分支名为 main
git branch -M main

# 推送到 GitHub
git push -u origin main
```

---

## 首次推送后的更新

以后如需更新代码到 GitHub：

```bash
git add .
git commit -m "你的提交信息"
git push origin main
```

---

## 常见问题

### Q1: 提示 "remote origin already exists"
**解决**：先删除再添加
```bash
git remote remove origin
git remote add origin git@github.com:wfanang/yichuan-new-wall.git
```

### Q2: 推送失败，提示认证错误
**解决**：使用 HTTPS 方式
```bash
git remote set-url origin https://github.com/wfanang/yichuan-new-wall.git
git push -u origin main
```

### Q3: 如何使用 SSH？
**解决**：确保已配置 SSH key
```bash
# 检查 SSH key
ls -la ~/.ssh/

# 如果没有，生成新的 SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# 将公钥添加到 GitHub
cat ~/.ssh/id_ed25519.pub
# 复制输出内容到 GitHub Settings -> SSH and GPG keys
```

---

## 项目统计

- ✅ 已清理 3001 端口代理相关代码
- ✅ 已创建 .gitignore 文件
- ✅ 已创建 README.md
- ✅ 已初始化 Git 仓库
- ✅ 已提交所有文件

**总计**: 约 100+ 文件已准备就绪
