# 宜川大屏系统 (Yichuan Dashboard System)

宜川县水利监测体系整合平台 - 大屏展示系统

## 项目简介

本项目是宜川县水利监测体系整合平台的大屏展示系统，包含以下核心功能模块：

- 📹 **视频监控墙** - 基于高德地图的 GIS 展示，标注河道、水库、果园、城区监控点位
- 👥 **视频会议** - 显示 20 个参会单位在线状态
- 🌤️ **气象云图** - 气象监测数据展示
- 💧 **土壤墒情监测** - 6 个监测点位，7 项土壤指标实时显示
- 🗺️ **应急资源分布** - 应急资源地图展示

## 技术栈

- **前端框架**: Vue.js
- **UI 库**: Element UI
- **地图服务**: 高德地图 API
- **构建工具**: Webpack + Vite
- **服务器**: Node.js + Express

## 项目结构

```
yichuan-new-wall/
├── dashboard-app/              # 前端应用源码
│   ├── src/
│   │   ├── components/        # 组件目录
│   │   ├── views/            # 页面视图
│   │   ├── router/           # 路由配置
│   │   └── main.js           # 入口文件
│   ├── dist/                 # 构建输出目录
│   └── package.json          # 依赖配置
├── server-deployment/         # 服务器部署文件
├── yichuan-dashboard-production-deployment/  # 生产环境部署包
└── 部署包/                    # Windows 部署包
```

## 快速开始

### 安装依赖

```bash
cd dashboard-app
npm install
```

### 开发模式

```bash
npm run serve
```

### 生产构建

```bash
npm run build
```

## 部署说明

### 开发环境部署

1. 安装 Node.js v18+ 
2. 克隆项目到本地
3. 进入 `dashboard-app` 目录
4. 运行 `npm install`
5. 运行 `npm run serve`
6. 访问 `http://localhost:8080`

### 生产环境部署

详见各部署包中的文档：
- `server-deployment/DEPLOYMENT.md` - Linux 服务器部署指南
- `yichuan-dashboard-production-deployment/` - 生产环境部署包
- `部署包/` - Windows 部署包

## 系统要求

- **分辨率**: 7680×1080 (超宽屏)
- **浏览器**: Chrome 90+ / Edge 90+
- **Node.js**: v18.x LTS 或更高版本

## 更新日志

### v2.0.0 (2026-03-27)
- ✅ 清理 3001 端口代理相关代码
- ✅ 优化项目结构
- ✅ 完善部署文档

## 注意事项

⚠️ **重要**: 本项目已移除所有与 3001 端口代理相关的代码和配置文件。如需使用代理服务，请自行配置。

## 开发者

- GitHub: [@wfanang](https://github.com/wfanang)

## License

MIT
