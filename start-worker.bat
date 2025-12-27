@echo off
REM InvenTree 后台任务 Worker 启动脚本 (Windows)

echo ======================================
echo 启动 InvenTree 后台任务 Worker
echo ======================================

cd src\backend
call venv\Scripts\activate.bat

echo.
echo Django-Q Worker 启动中...
echo 按 Ctrl+C 停止 Worker
echo.

python InvenTree\manage.py qcluster
