#!/bin/bash
# InvenTree 前端开发服务器启动脚本

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}======================================"
echo "启动 InvenTree 前端开发服务器"
echo "======================================${NC}"

cd src/frontend

# 检查依赖
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}未检测到 node_modules，正在安装依赖...${NC}"
    npm install
fi

# 启动 Vite 开发服务器
echo -e "\n${GREEN}======================================"
echo "Vite 开发服务器启动中..."
echo "======================================${NC}"
echo -e "访问地址: ${GREEN}http://localhost:5173${NC}"
echo ""
echo -e "${YELLOW}按 Ctrl+C 停止服务器${NC}"
echo ""

npm run dev
