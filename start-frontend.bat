@echo off
REM InvenTree 前端开发服务器启动脚本 (Windows)

echo ======================================
echo 启动 InvenTree 前端开发服务器
echo ======================================

cd src\frontend

REM 检查依赖
if not exist "node_modules" (
    echo 未检测到 node_modules，正在安装依赖...
    npm install
)

REM 启动 Vite 开发服务器
echo.
echo ======================================
echo Vite 开发服务器启动中...
echo ======================================
echo 访问地址: http://localhost:5173
echo.
echo 按 Ctrl+C 停止服务器
echo.

npm run dev
