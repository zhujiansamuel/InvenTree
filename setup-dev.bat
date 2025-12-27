@echo off
REM InvenTree 本地开发环境初始化脚本 (Windows)

echo ======================================
echo InvenTree 本地开发环境初始化
echo ======================================

REM 检查 Docker
echo.
echo [1/8] 检查 Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 请先安装 Docker Desktop
    pause
    exit /b 1
)
echo ✓ Docker 已安装

REM 检查 Python
echo.
echo [2/8] 检查 Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 请先安装 Python 3.11+
    pause
    exit /b 1
)
echo ✓ Python 已安装

REM 检查 Node.js
echo.
echo [3/8] 检查 Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 请先安装 Node.js 18+
    pause
    exit /b 1
)
echo ✓ Node.js 已安装

REM 启动 Docker 服务
echo.
echo [4/8] 启动 Docker 服务...
docker-compose -f docker-compose.local.yml up -d
echo ✓ Docker 服务已启动

REM 等待数据库启动
echo.
echo 等待数据库启动...
timeout /t 5 /nobreak >nul

REM 创建 Python 虚拟环境
echo.
echo [5/8] 设置 Python 虚拟环境...
cd src\backend
if not exist "venv" (
    python -m venv venv
    echo ✓ 虚拟环境已创建
) else (
    echo ✓ 虚拟环境已存在
)

REM 安装 Python 依赖
echo.
echo [6/8] 安装 Python 依赖...
call venv\Scripts\activate.bat
python -m pip install --upgrade pip
pip install -r requirements.txt
pip install -r ..\..\contrib\dev_reqs\requirements.txt
echo ✓ Python 依赖已安装

REM 复制环境变量文件
echo.
echo 复制环境变量配置...
cd ..\..
if not exist ".env" (
    copy .env.local .env
    echo ✓ 环境变量文件已创建
) else (
    echo ! .env 文件已存在，未覆盖
)

REM 运行数据库迁移
echo.
echo [7/8] 运行数据库迁移...
cd src\backend
call venv\Scripts\activate.bat
python InvenTree\manage.py migrate
python InvenTree\manage.py collectstatic --noinput
echo ✓ 数据库迁移完成

cd ..\..

echo.
echo ======================================
echo ✓ 初始化完成！
echo ======================================
echo.
echo 后续步骤：
echo 1. 安装前端依赖:
echo    cd src\frontend
echo    npm install
echo.
echo 2. 启动后端开发服务器:
echo    start-backend.bat
echo.
echo 3. 启动前端开发服务器:
echo    start-frontend.bat
echo.
echo 4. 访问应用:
echo    - 前端: http://localhost:5173
echo    - 后端 API: http://localhost:8000/api/
echo    - Django Admin: http://localhost:8000/admin/
echo.
echo 5. 默认管理员账号:
echo    - 用户名: admin
echo    - 密码: admin123
echo.
pause
