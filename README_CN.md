# InvenTree 本地开发环境配置完成 ✅

我已经为你创建了完整的本地 PyCharm 开发环境配置！

## 📦 已创建的文件

### 核心配置文件
- ✅ `docker-compose.local.yml` - Docker 服务配置（PostgreSQL + Redis + pgAdmin）
- ✅ `.env.local` - 环境变量配置模板

### 启动脚本（Linux/macOS）
- ✅ `setup-dev.sh` - 一键初始化脚本
- ✅ `start-backend.sh` - 启动后端 Django 服务器
- ✅ `start-worker.sh` - 启动后台任务 Worker
- ✅ `start-frontend.sh` - 启动前端 Vite 开发服务器

### 启动脚本（Windows）
- ✅ `setup-dev.bat` - 一键初始化脚本
- ✅ `start-backend.bat` - 启动后端 Django 服务器
- ✅ `start-worker.bat` - 启动后台任务 Worker
- ✅ `start-frontend.bat` - 启动前端 Vite 开发服务器

### 文档
- ✅ `QUICK_START.md` - 快速开始指南（一页速查）
- ✅ `DEVELOPMENT_SETUP.md` - 完整开发环境设置指南
- ✅ `TECH_STACK.md` - 完整技术栈文档

---

## 🚀 快速开始

### 对于 Linux/macOS 用户：

```bash
# 1. 赋予脚本执行权限
chmod +x *.sh

# 2. 一键初始化
./setup-dev.sh

# 3. 安装前端依赖
cd src/frontend && npm install && cd ../..

# 4. 启动服务（打开3个终端）
./start-backend.sh   # 终端 1
./start-worker.sh    # 终端 2
./start-frontend.sh  # 终端 3
```

### 对于 Windows 用户：

```cmd
# 1. 一键初始化
setup-dev.bat

# 2. 安装前端依赖
cd src\frontend
npm install
cd ..\..

# 3. 启动服务（打开3个命令行窗口）
start-backend.bat   # 窗口 1
start-worker.bat    # 窗口 2
start-frontend.bat  # 窗口 3
```

---

## 🌐 访问应用

初始化完成后，你可以访问：

| 服务 | 地址 | 凭据 |
|------|------|------|
| 🌐 **前端应用** | http://localhost:5173 | admin / admin123 |
| 🔌 **后端 API** | http://localhost:8000/api/ | - |
| 🛠️ **Django Admin** | http://localhost:8000/admin/ | admin / admin123 |
| 📚 **API 文档** | http://localhost:8000/api/schema/redoc/ | - |
| 🐘 **pgAdmin** | http://localhost:5050 | admin@inventree.local / admin |

---

## 🐳 Docker 服务说明

### 已配置的服务：

1. **PostgreSQL 17**
   - 端口：`5432`
   - 数据库：`inventree`
   - 用户：`inventree`
   - 密码：`inventree123`

2. **Redis 7**
   - 端口：`6379`
   - 用于缓存和异步任务队列

3. **pgAdmin 4**（可选）
   - 端口：`5050`
   - 用于可视化管理 PostgreSQL

### Docker 命令：

```bash
# 启动所有服务
docker-compose -f docker-compose.local.yml up -d

# 停止所有服务
docker-compose -f docker-compose.local.yml down

# 查看服务状态
docker-compose -f docker-compose.local.yml ps

# 查看日志
docker-compose -f docker-compose.local.yml logs -f

# 启动包含 pgAdmin
docker-compose -f docker-compose.local.yml --profile tools up -d
```

---

## 🔧 PyCharm 配置

### 1. Python 解释器
1. 打开 `Settings → Project → Python Interpreter`
2. 添加现有环境：`src/backend/venv/bin/python`（或 Windows: `venv\Scripts\python.exe`）

### 2. Django 支持
1. 打开 `Settings → Languages & Frameworks → Django`
2. 勾选 `Enable Django Support`
3. 设置：
   - Django project root: `src/backend/InvenTree`
   - Settings: `InvenTree/settings.py`
   - Manage script: `manage.py`

### 3. 运行配置

#### Django Server
- Type: `Django Server`
- Host: `0.0.0.0`
- Port: `8000`
- Working directory: `src/backend`
- Environment: `INVENTREE_DEBUG=True`

#### Worker
- Type: `Python`
- Script: `src/backend/InvenTree/manage.py`
- Parameters: `qcluster`
- Working directory: `src/backend`

#### Frontend
- Type: `npm`
- Package.json: `src/frontend/package.json`
- Command: `run`
- Scripts: `dev`

---

## 📁 项目结构

```
InvenTree/
├── src/
│   ├── backend/              # Django 后端
│   │   ├── InvenTree/        # 主应用
│   │   │   ├── stock/        # ✨ 库存管理模块
│   │   │   ├── part/         # ✨ 零件管理模块
│   │   │   ├── build/        # ✨ 生产模块
│   │   │   ├── order/        # ✨ 订单模块
│   │   │   └── company/      # ✨ 公司模块
│   │   └── venv/             # Python 虚拟环境
│   └── frontend/             # React 前端
│       ├── src/
│       │   ├── pages/        # 页面组件
│       │   ├── tables/       # 表格组件
│       │   └── components/   # 通用组件
│       └── package.json
├── docker-compose.local.yml  # ✅ Docker 配置
├── .env.local                # ✅ 环境变量模板
├── setup-dev.sh/bat          # ✅ 初始化脚本
├── start-*.sh/bat            # ✅ 启动脚本
├── QUICK_START.md            # ✅ 快速开始
├── DEVELOPMENT_SETUP.md      # ✅ 完整指南
└── TECH_STACK.md             # ✅ 技术栈文档
```

---

## 📚 技术栈概览

### 后端
- **Python 3.11+** + **Django 5.2.9**
- **Django REST Framework 3.16.1**
- **PostgreSQL 17** / MySQL / SQLite
- **Redis 7** (缓存 + 队列)
- **Django-Q** (异步任务)
- **django-mptt** (树状结构)

### 前端
- **React 19.1.2** + **TypeScript 5.8+**
- **Vite 7.1.11** (构建工具)
- **Mantine 8.2.7** (UI 框架)
- **Zustand 5.0.8** (状态管理)
- **TanStack Query 5.56+** (数据获取)
- **React Router 6.26+** (路由)

详细技术栈说明请查看 `TECH_STACK.md`

---

## 🎯 库存管理核心特性

InvenTree 的库存管理采用层次化设计：

### 数据模型
```
零件分类 (PartCategory)
  └── 零件 (Part)
      └── 库存项 (StockItem)
          ├── 批次号
          ├── 序列号
          ├── 数量
          ├── 状态
          └── 库位

库位 (StockLocation)
  ├── 层级结构（树状）
  ├── 库位类型
  └── 内部/外部库位
```

### 核心功能
- ✅ 多层级库位管理（树状结构）
- ✅ 批次和序列号追踪
- ✅ 库存状态管理
- ✅ 库存变动历史记录
- ✅ 质量测试记录
- ✅ 到期日期管理
- ✅ BOM（物料清单）管理
- ✅ 采购/销售订单集成

---

## 🛠️ 常用命令

### Django 管理
```bash
cd src/backend
source venv/bin/activate  # Linux/macOS
# 或 call venv\Scripts\activate.bat  # Windows

# 数据库迁移
python InvenTree/manage.py migrate

# 创建超级用户
python InvenTree/manage.py createsuperuser

# Django Shell
python InvenTree/manage.py shell

# 运行测试
python InvenTree/manage.py test
```

### 前端开发
```bash
cd src/frontend

# 开发模式（热重载）
npm run dev

# 构建生产版本
npm run build

# 编译国际化
npm run compile
```

---

## ❓ 故障排查

### 端口被占用

**Linux/macOS:**
```bash
lsof -i :8000  # 查看占用端口的进程
kill -9 <PID>  # 杀死进程
```

**Windows:**
```cmd
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

### 数据库连接失败
```bash
# 检查 Docker 服务
docker-compose -f docker-compose.local.yml ps

# 重启数据库
docker-compose -f docker-compose.local.yml restart postgres

# 查看数据库日志
docker-compose -f docker-compose.local.yml logs -f postgres
```

### 完全重置
```bash
# 停止并删除所有数据
docker-compose -f docker-compose.local.yml down -v

# 清理 Python 缓存
find . -type d -name __pycache__ -exec rm -rf {} +
rm -rf data/

# 重新初始化
./setup-dev.sh  # 或 setup-dev.bat
```

---

## 📖 下一步

1. **阅读完整文档**
   - `QUICK_START.md` - 快速参考
   - `DEVELOPMENT_SETUP.md` - 详细设置指南
   - `TECH_STACK.md` - 技术栈详解

2. **配置 PyCharm**
   - 设置 Python 解释器
   - 启用 Django 支持
   - 创建运行配置

3. **开始开发**
   - 修改代码会自动重载
   - 使用 Django Admin 管理数据
   - 通过 API 文档了解接口

4. **参考官方文档**
   - https://docs.inventree.org/
   - https://docs.inventree.org/en/latest/api/
   - https://docs.inventree.org/en/latest/develop/

---

## 🤝 获取帮助

- **官方文档**: https://docs.inventree.org/
- **GitHub Issues**: https://github.com/inventree/InvenTree/issues
- **Discord 社区**: https://discord.gg/inventree
- **Reddit**: https://www.reddit.com/r/InvenTree/

---

## 📝 许可证

InvenTree 使用 MIT 许可证。

---

**祝你开发愉快！** 🚀

如果遇到任何问题，请查看 `DEVELOPMENT_SETUP.md` 中的故障排查部分，
或访问官方文档获取更多帮助。
