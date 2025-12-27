# InvenTree 本地开发环境故障排查指南

## 常见问题及解决方案

### 1. Python 版本问题

#### 问题：Django 无法导入或版本不兼容

**错误信息：**
```
ImportError: Could not import Django. Are you sure it's installed?
```

**原因：**
- Python 版本太新（3.13+）或太旧（<3.11）
- InvenTree 推荐使用 Python 3.11 或 3.12

**解决方案：**

##### macOS 安装 Python 3.12：
```bash
# 使用 Homebrew
brew install python@3.12

# 验证安装
python3.12 --version

# 删除旧的虚拟环境
cd src/backend
rm -rf venv
cd ../..

# 重新初始化
./setup-dev.sh
```

##### 使用 pyenv（推荐）：
```bash
# 安装 pyenv
brew install pyenv

# 安装 Python 3.12
pyenv install 3.12.7

# 设置全局版本
pyenv global 3.12.7

# 添加到 shell 配置
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# 重新加载配置
source ~/.zshrc
```

---

### 2. 数据库配置问题

#### 问题：数据库配置未正确加载

**错误信息：**
```
django.core.exceptions.ImproperlyConfigured: settings.DATABASES is improperly configured.
Please supply the ENGINE value.
```

**原因：**
- 环境变量未正确加载
- `.env` 文件不存在或格式错误

**解决方案：**

##### 检查 `.env` 文件：
```bash
# 1. 确认文件存在
ls -la .env

# 2. 查看文件内容
cat .env

# 3. 验证关键配置
grep INVENTREE_DB .env
```

##### 手动测试环境变量：
```bash
cd src/backend
source venv/bin/activate

# 手动设置环境变量
export INVENTREE_DEBUG=True
export INVENTREE_DB_ENGINE=postgresql
export INVENTREE_DB_NAME=inventree
export INVENTREE_DB_USER=inventree
export INVENTREE_DB_PASSWORD=inventree123
export INVENTREE_DB_HOST=localhost
export INVENTREE_DB_PORT=5432

# 测试
python InvenTree/manage.py migrate
```

##### 重新创建 `.env` 文件：
```bash
# 删除旧文件
rm .env

# 复制模板
cp .env.local .env

# 编辑配置（如果需要）
nano .env
```

---

### 3. Docker 服务问题

#### 问题：无法连接到 PostgreSQL

**错误信息：**
```
could not connect to server: Connection refused
```

**解决方案：**

##### 检查 Docker 服务状态：
```bash
# 查看所有容器
docker-compose -f docker-compose.local.yml ps

# 查看 PostgreSQL 日志
docker-compose -f docker-compose.local.yml logs postgres

# 重启服务
docker-compose -f docker-compose.local.yml restart postgres
```

##### 测试数据库连接：
```bash
# 使用 psql 客户端
psql -h localhost -p 5432 -U inventree -d inventree
# 密码: inventree123

# 或使用 Docker exec
docker exec -it inventree-postgres psql -U inventree -d inventree
```

##### 完全重置 Docker 服务：
```bash
# 停止并删除所有容器和数据
docker-compose -f docker-compose.local.yml down -v

# 重新启动
docker-compose -f docker-compose.local.yml up -d

# 等待数据库启动
sleep 5

# 重新运行迁移
cd src/backend
source venv/bin/activate
cd ../..
set -a
source .env
set +a
cd src/backend
python InvenTree/manage.py migrate
```

---

### 4. 端口占用问题

#### 问题：端口已被占用

**错误信息：**
```
Error: That port is already in use.
```

**解决方案：**

##### macOS/Linux：
```bash
# 查找占用端口 8000 的进程
lsof -i :8000

# 杀死进程
kill -9 <PID>

# 查找占用端口 5432 的进程（PostgreSQL）
lsof -i :5432
```

##### 修改端口（可选）：
```bash
# 修改 .env 文件
# 将 PostgreSQL 端口改为其他值
INVENTREE_DB_PORT=5433

# 修改 docker-compose.local.yml
# 将端口映射改为 "5433:5432"
```

---

### 5. 虚拟环境问题

#### 问题：虚拟环境损坏或依赖缺失

**解决方案：**

##### 完全重建虚拟环境：
```bash
cd src/backend

# 删除虚拟环境
rm -rf venv

# 使用正确的 Python 版本创建
python3.12 -m venv venv
# 或
python3.11 -m venv venv

# 激活
source venv/bin/activate

# 验证 Python 版本
python --version

# 安装依赖
pip install --upgrade pip
pip install -r requirements.txt
pip install -r ../../contrib/dev_reqs/requirements.txt

# 验证 Django 安装
python -c "import django; print(django.VERSION)"
```

---

### 6. 前端问题

#### 问题：npm install 失败

**解决方案：**

```bash
cd src/frontend

# 清理缓存
npm cache clean --force

# 删除 node_modules
rm -rf node_modules package-lock.json

# 重新安装
npm install
```

#### 问题：Vite 启动失败

**解决方案：**

```bash
# 检查 Node.js 版本（需要 18+）
node --version

# 升级 Node.js（使用 nvm）
nvm install 20
nvm use 20

# 或使用 Homebrew
brew upgrade node
```

---

### 7. 权限问题

#### 问题：Permission denied

**解决方案：**

```bash
# 给脚本执行权限
chmod +x setup-dev.sh start-*.sh

# 如果 Docker 需要 sudo
# 将用户添加到 docker 组（仅 Linux）
sudo usermod -aG docker $USER
# 注销并重新登录
```

---

### 8. 数据库迁移问题

#### 问题：迁移失败或冲突

**解决方案：**

```bash
cd src/backend
source venv/bin/activate
cd ../..
set -a
source .env
set +a
cd src/backend

# 查看迁移状态
python InvenTree/manage.py showmigrations

# 回滚迁移
python InvenTree/manage.py migrate <app_name> <migration_number>

# 伪造迁移（谨慎使用）
python InvenTree/manage.py migrate --fake <app_name> <migration_number>

# 重置数据库（会删除所有数据）
python InvenTree/manage.py flush
python InvenTree/manage.py migrate
```

---

## 诊断检查清单

运行此检查清单以诊断问题：

```bash
# 1. 检查 Python 版本
python3 --version
python3.12 --version  # 如果有
python3.11 --version  # 如果有

# 2. 检查 Docker 服务
docker ps | grep inventree

# 3. 检查 .env 文件
cat .env | grep -v '^#' | grep INVENTREE_DB

# 4. 检查虚拟环境
cd src/backend
source venv/bin/activate
python --version
pip list | grep -i django

# 5. 测试数据库连接
psql -h localhost -p 5432 -U inventree -d inventree -c "SELECT version();"

# 6. 检查端口占用
lsof -i :8000
lsof -i :5432
lsof -i :6379

# 7. 验证环境变量
cd ../..
set -a
source .env
set +a
echo $INVENTREE_DB_ENGINE
echo $INVENTREE_DB_NAME
```

---

## 获取帮助

如果问题仍未解决：

1. **查看日志：**
   ```bash
   # Docker 日志
   docker-compose -f docker-compose.local.yml logs

   # Django 日志
   # 启动服务时会显示在终端
   ```

2. **查看文档：**
   - `QUICK_START.md` - 快速参考
   - `DEVELOPMENT_SETUP.md` - 详细设置
   - `TECH_STACK.md` - 技术栈

3. **官方资源：**
   - https://docs.inventree.org/
   - https://github.com/inventree/InvenTree/issues
   - https://discord.gg/inventree

---

**最后更新**: 2025-12-27
