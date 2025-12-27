# InvenTree 快速开始指南 ⚡

## 一分钟快速启动

### Linux / macOS

```bash
# 1. 一键初始化
chmod +x *.sh
./setup-dev.sh

# 2. 安装前端依赖
cd src/frontend && npm install && cd ../..

# 3. 启动服务（打开3个终端）
./start-backend.sh   # 终端 1：后端
./start-worker.sh    # 终端 2：Worker
./start-frontend.sh  # 终端 3：前端
```

### Windows

```cmd
# 1. 一键初始化
setup-dev.bat

# 2. 安装前端依赖
cd src\frontend
npm install
cd ..\..

# 3. 启动服务（打开3个命令行窗口）
start-backend.bat   # 窗口 1：后端
start-worker.bat    # 窗口 2：Worker
start-frontend.bat  # 窗口 3：前端
```

---

## 访问应用

| 服务 | 地址 | 凭据 |
|------|------|------|
| 🌐 **前端应用** | http://localhost:5173 | admin / admin123 |
| 🔌 **API 文档** | http://localhost:8000/api/schema/redoc/ | - |
| 🛠️ **Django Admin** | http://localhost:8000/admin/ | admin / admin123 |
| 🐘 **pgAdmin** | http://localhost:5050 | admin@inventree.local / admin |

---

## PyCharm 配置速查

### 1. Python 解释器
`Settings → Project → Python Interpreter`
→ 选择 `src/backend/venv/bin/python` (或 `venv\Scripts\python.exe`)

### 2. Django 支持
`Settings → Languages & Frameworks → Django`
- ✅ Enable Django Support
- Django project root: `src/backend/InvenTree`
- Settings: `InvenTree/settings.py`

### 3. 运行配置

#### Django Server
```
Type: Django Server
Host: 0.0.0.0
Port: 8000
Working directory: src/backend
Environment: INVENTREE_DEBUG=True
```

#### Worker
```
Type: Python
Script: src/backend/InvenTree/manage.py
Parameters: qcluster
Working directory: src/backend
```

#### Frontend
```
Type: npm
Package.json: src/frontend/package.json
Command: run
Scripts: dev
```

---

## 常用命令

### Docker
```bash
# 启动服务
docker-compose -f docker-compose.local.yml up -d

# 停止服务
docker-compose -f docker-compose.local.yml down

# 查看日志
docker-compose -f docker-compose.local.yml logs -f postgres
```

### Django
```bash
cd src/backend
source venv/bin/activate  # Linux/macOS
# 或
call venv\Scripts\activate.bat  # Windows

# 迁移
python InvenTree/manage.py migrate

# 创建超级用户
python InvenTree/manage.py createsuperuser

# Django Shell
python InvenTree/manage.py shell

# 运行测试
python InvenTree/manage.py test
```

### 前端
```bash
cd src/frontend

# 开发模式
npm run dev

# 构建
npm run build

# 编译国际化
npm run compile
```

---

## 故障排查

### ❌ 端口被占用
```bash
# Linux/macOS
lsof -i :8000
kill -9 <PID>

# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

### ❌ 数据库连接失败
```bash
# 检查 Docker 状态
docker-compose -f docker-compose.local.yml ps

# 重启数据库
docker-compose -f docker-compose.local.yml restart postgres
```

### ❌ 迁移错误
```bash
# 显示迁移状态
python InvenTree/manage.py showmigrations

# 回滚迁移
python InvenTree/manage.py migrate <app> <migration_number>
```

### 🔄 完全重置
```bash
# 停止并删除所有数据
docker-compose -f docker-compose.local.yml down -v

# 删除缓存
find . -type d -name __pycache__ -exec rm -rf {} +
rm -rf data/

# 重新初始化
./setup-dev.sh  # Linux/macOS
# 或
setup-dev.bat   # Windows
```

---

## 项目结构

```
InvenTree/
├── src/
│   ├── backend/              # Django 后端
│   │   ├── InvenTree/        # 主应用目录
│   │   │   ├── stock/        # 库存模块
│   │   │   ├── part/         # 零件模块
│   │   │   ├── build/        # 生产模块
│   │   │   ├── order/        # 订单模块
│   │   │   └── company/      # 公司模块
│   │   ├── venv/             # Python 虚拟环境
│   │   └── requirements.txt  # Python 依赖
│   └── frontend/             # React 前端
│       ├── src/
│       │   ├── pages/        # 页面组件
│       │   ├── tables/       # 表格组件
│       │   └── components/   # 通用组件
│       ├── package.json      # Node 依赖
│       └── vite.config.ts    # Vite 配置
├── docker-compose.local.yml  # Docker 配置
├── .env.local                # 环境变量模板
├── .env                      # 实际环境变量（自动生成）
├── setup-dev.sh              # 初始化脚本
├── start-backend.sh          # 后端启动脚本
├── start-worker.sh           # Worker 启动脚本
└── start-frontend.sh         # 前端启动脚本
```

---

## 开发工作流

### 后端开发
1. 修改 Python 代码 → 自动重载
2. 修改模型 → 运行 `makemigrations` + `migrate`
3. 添加依赖 → 更新 `requirements.txt`

### 前端开发
1. 修改 React/TypeScript 代码 → 自动热重载
2. 添加依赖 → 运行 `npm install <package>`
3. 修改样式 → Vite 自动更新

### 数据库开发
1. 连接到 PostgreSQL
   ```bash
   psql -h localhost -p 5432 -U inventree -d inventree
   # 密码: inventree123
   ```
2. 或使用 pgAdmin: http://localhost:5050

---

## 下一步

- 📖 阅读完整文档: [DEVELOPMENT_SETUP.md](DEVELOPMENT_SETUP.md)
- 🌐 官方文档: https://docs.inventree.org/
- 💬 社区支持: https://discord.gg/inventree
- 🐛 报告问题: https://github.com/inventree/InvenTree/issues

---

**祝开发愉快！** 🚀
