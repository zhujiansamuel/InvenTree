@echo off
REM InvenTree 后端开发服务器启动脚本 (Windows)

echo ======================================
echo 启动 InvenTree 后端开发服务器
echo ======================================

REM 检查 Docker 服务
echo.
echo 检查 Docker 服务状态...
docker ps | findstr inventree-postgres >nul 2>&1
if errorlevel 1 (
    echo Docker 服务未运行，正在启动...
    docker-compose -f docker-compose.local.yml up -d
    timeout /t 3 /nobreak >nul
)

REM 激活虚拟环境
echo.
echo 激活 Python 虚拟环境...
cd src\backend
call venv\Scripts\activate.bat

REM 检查数据库迁移
echo 检查数据库迁移...
python InvenTree\manage.py migrate

REM 启动 Django 开发服务器
echo.
echo ======================================
echo Django 开发服务器启动中...
echo ======================================
echo 访问地址: http://localhost:8000
echo Admin: http://localhost:8000/admin/
echo API: http://localhost:8000/api/
echo.
echo 按 Ctrl+C 停止服务器
echo.

python InvenTree\manage.py runserver 0.0.0.0:8000
