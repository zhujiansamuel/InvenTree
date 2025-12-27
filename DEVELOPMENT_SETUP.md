# InvenTree 本地开发环境设置指南

本指南帮助你在本地 PyCharm 中设置 InvenTree 开发环境。

## 前置要求

### 必需软件
- **Docker** 和 **Docker Compose** （用于运行数据库和 Redis）
- **Python 3.11+** （建议 3.11 或 3.12）
- **Node.js 18+** 和 **npm**
- **Git**

### 推荐软件
- **PyCharm Professional** （或 VS Code）
- **pgAdmin** 或其他 PostgreSQL 客户端

---

## 快速开始

### 1. 一键初始化（推荐）

```bash
chmod +x setup-dev.sh start-backend.sh start-worker.sh start-frontend.sh
./setup-dev.sh
```

这个脚本会自动完成：
- 启动 Docker 服务（PostgreSQL + Redis）
- 创建 Python 虚拟环境
- 安装后端依赖
- 运行数据库迁移
- 创建初始管理员账号

### 2. 安装前端依赖

```bash
cd src/frontend
npm install
```

### 3. 启动服务

打开 **3 个终端窗口**，分别运行：

#### 终端 1 - 后端 Django 服务器
```bash
./start-backend.sh
```
访问: http://localhost:8000

#### 终端 2 - 后台任务 Worker
```bash
./start-worker.sh
```

#### 终端 3 - 前端 Vite 开发服务器
```bash
./start-frontend.sh
```
访问: http://localhost:5173

---

## 手动设置步骤

如果你想手动配置，或者自动脚本失败，请按照以下步骤操作：

### 步骤 1: 启动 Docker 服务

```bash
# 启动 PostgreSQL 和 Redis
docker-compose -f docker-compose.local.yml up -d

# 查看服务状态
docker-compose -f docker-compose.local.yml ps

# 查看日志
docker-compose -f docker-compose.local.yml logs -f
```

**服务端口：**
- PostgreSQL: `localhost:5432`
- Redis: `localhost:6379`
- pgAdmin (可选): http://localhost:5050

### 步骤 2: 设置后端环境

```bash
cd src/backend

# 创建虚拟环境
python3 -m venv venv

# 激活虚拟环境
source venv/bin/activate  # Linux/macOS
# 或
venv\Scripts\activate     # Windows

# 安装依赖
pip install --upgrade pip
pip install -r requirements.txt
pip install -r ../../contrib/dev_reqs/requirements.txt
```

### 步骤 3: 配置环境变量

```bash
# 回到项目根目录
cd ../..

# 复制环境变量模板
cp .env.local .env

# 编辑 .env 文件（如需要）
# 修改数据库密码、管理员账号等
```

### 步骤 4: 初始化数据库

```bash
cd src/backend
source venv/bin/activate

# 加载环境变量
export $(cat ../../.env | grep -v '^#' | xargs)

# 运行迁移
python InvenTree/manage.py migrate

# 收集静态文件
python InvenTree/manage.py collectstatic --noinput

# 创建超级用户（如果 .env 中没有配置）
python InvenTree/manage.py createsuperuser
```

### 步骤 5: 启动后端服务

```bash
# 启动 Django 开发服务器
python InvenTree/manage.py runserver 0.0.0.0:8000
```

**在新终端中启动 Worker:**
```bash
cd src/backend
source venv/bin/activate
export $(cat ../../.env | grep -v '^#' | xargs)
python InvenTree/manage.py qcluster
```

### 步骤 6: 启动前端服务

```bash
cd src/frontend

# 安装依赖（首次）
npm install

# 启动开发服务器
npm run dev
```

---

## PyCharm 配置

### 1. 配置 Python 解释器

1. `File` → `Settings` → `Project` → `Python Interpreter`
2. 点击齿轮图标 → `Add`
3. 选择 `Existing Environment`
4. 选择 `src/backend/venv/bin/python`

### 2. 配置 Django 支持

1. `File` → `Settings` → `Languages & Frameworks` → `Django`
2. 勾选 `Enable Django Support`
3. 设置：
   - **Django project root**: `src/backend/InvenTree`
   - **Settings**: `InvenTree/settings.py`
   - **Manage script**: `manage.py`

### 3. 配置运行/调试配置

#### Django Server 配置
1. `Run` → `Edit Configurations`
2. 点击 `+` → `Django Server`
3. 设置：
   - **Name**: `InvenTree Django`
   - **Host**: `0.0.0.0`
   - **Port**: `8000`
   - **Environment variables**:
     ```
     PYTHONUNBUFFERED=1;INVENTREE_DEBUG=True
     ```
   - **Working directory**: `src/backend`
   - **Python interpreter**: 选择刚才配置的虚拟环境

#### Django Q Worker 配置
1. 点击 `+` → `Python`
2. 设置：
   - **Name**: `InvenTree Worker`
   - **Script path**: `src/backend/InvenTree/manage.py`
   - **Parameters**: `qcluster`
   - **Working directory**: `src/backend`

### 4. 配置 JavaScript/TypeScript

1. `File` → `Settings` → `Languages & Frameworks` → `Node.js`
2. 确保 Node.js 解释器已配置
3. 配置前端运行配置：
   - `Run` → `Edit Configurations`
   - 点击 `+` → `npm`
   - **Name**: `InvenTree Frontend`
   - **Package.json**: `src/frontend/package.json`
   - **Command**: `run`
   - **Scripts**: `dev`

---

## 访问应用

启动所有服务后：

| 服务 | 地址 | 说明 |
|------|------|------|
| **前端应用** | http://localhost:5173 | Vite 开发服务器（热重载）|
| **后端 API** | http://localhost:8000/api/ | Django REST API |
| **Django Admin** | http://localhost:8000/admin/ | Django 管理后台 |
| **API 文档** | http://localhost:8000/api/schema/redoc/ | ReDoc API 文档 |
| **PostgreSQL** | localhost:5432 | 数据库（需客户端连接）|
| **Redis** | localhost:6379 | 缓存服务 |
| **pgAdmin** | http://localhost:5050 | 数据库管理工具（可选）|

### 默认登录凭据
- **用户名**: `admin`
- **密码**: `admin123`

（在 `.env` 文件中配置）

---

## 常用命令

### Docker 管理

```bash
# 启动服务
docker-compose -f docker-compose.local.yml up -d

# 停止服务
docker-compose -f docker-compose.local.yml down

# 查看日志
docker-compose -f docker-compose.local.yml logs -f postgres
docker-compose -f docker-compose.local.yml logs -f redis

# 重启服务
docker-compose -f docker-compose.local.yml restart

# 启动包含 pgAdmin
docker-compose -f docker-compose.local.yml --profile tools up -d

# 清理数据（危险！会删除所有数据）
docker-compose -f docker-compose.local.yml down -v
```

### Django 管理

```bash
cd src/backend
source venv/bin/activate
export $(cat ../../.env | grep -v '^#' | xargs)

# 运行迁移
python InvenTree/manage.py migrate

# 创建超级用户
python InvenTree/manage.py createsuperuser

# 收集静态文件
python InvenTree/manage.py collectstatic

# 进入 Django Shell
python InvenTree/manage.py shell

# 运行测试
python InvenTree/manage.py test

# 创建迁移文件
python InvenTree/manage.py makemigrations

# 查看 SQL
python InvenTree/manage.py sqlmigrate stock 0001
```

### 前端管理

```bash
cd src/frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build

# 编译国际化
npm run compile

# 提取翻译字符串
npm run extract
```

### 数据库操作

```bash
# 连接到 PostgreSQL（需要 psql 客户端）
psql -h localhost -p 5432 -U inventree -d inventree
# 密码: inventree123

# 或使用 Docker exec
docker exec -it inventree-postgres psql -U inventree -d inventree

# 备份数据库
docker exec inventree-postgres pg_dump -U inventree inventree > backup.sql

# 恢复数据库
docker exec -i inventree-postgres psql -U inventree inventree < backup.sql
```

---

## 开发工作流

### 1. 修改后端代码
- Django 开发服务器会自动重载
- 如果修改了模型，运行: `python manage.py makemigrations && python manage.py migrate`

### 2. 修改前端代码
- Vite 会自动热重载
- 浏览器会立即反映更改

### 3. 添加 Python 依赖
```bash
cd src/backend
source venv/bin/activate
pip install <package>
pip freeze > requirements-new.txt  # 或更新 requirements.txt
```

### 4. 添加 JavaScript 依赖
```bash
cd src/frontend
npm install <package>
# package.json 会自动更新
```

---

## 故障排查

### 数据库连接失败
```bash
# 检查 Docker 服务状态
docker-compose -f docker-compose.local.yml ps

# 查看数据库日志
docker-compose -f docker-compose.local.yml logs postgres

# 重启数据库
docker-compose -f docker-compose.local.yml restart postgres
```

### 端口被占用
```bash
# 检查端口占用 (Linux/macOS)
lsof -i :8000
lsof -i :5173
lsof -i :5432

# 停止占用进程
kill -9 <PID>
```

### 迁移错误
```bash
# 回滚迁移
python manage.py migrate stock <migration_number>

# 显示迁移状态
python manage.py showmigrations

# 伪造迁移（谨慎使用）
python manage.py migrate --fake stock <migration_number>
```

### 清理并重置

```bash
# 1. 停止所有服务
docker-compose -f docker-compose.local.yml down -v

# 2. 清理 Python 缓存
find . -type d -name __pycache__ -exec rm -rf {} +
find . -type f -name "*.pyc" -delete

# 3. 删除数据目录
rm -rf data/

# 4. 重新初始化
./setup-dev.sh
```

---

## 生产环境部署

开发完成后，参考官方文档进行生产环境部署：
- https://docs.inventree.org/en/latest/start/docker/
- https://docs.inventree.org/en/latest/start/install/

---

## 其他资源

- **官方文档**: https://docs.inventree.org/
- **API 文档**: https://docs.inventree.org/en/latest/api/
- **开发指南**: https://docs.inventree.org/en/latest/develop/contributing/
- **GitHub**: https://github.com/inventree/InvenTree
- **Discord**: https://discord.gg/inventree

---

## 许可证

InvenTree 使用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。
