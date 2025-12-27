#!/bin/bash
# InvenTree 后端开发服务器启动脚本

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}======================================"
echo "启动 InvenTree 后端开发服务器"
echo "======================================${NC}"

# 检查 Docker 服务
echo -e "\n${YELLOW}检查 Docker 服务状态...${NC}"
if ! docker ps | grep -q inventree-postgres; then
    echo -e "${YELLOW}Docker 服务未运行，正在启动...${NC}"
    docker-compose -f docker-compose.local.yml up -d
    sleep 3
fi

# 激活虚拟环境
echo -e "\n${YELLOW}激活 Python 虚拟环境...${NC}"
cd src/backend
source venv/bin/activate

# 加载环境变量（使用显式导出方式）
echo -e "${YELLOW}加载环境变量...${NC}"
cd ../..
if [ -f .env ]; then
    # 逐行读取并导出
    while IFS='=' read -r key value; do
        if [[ ! $key =~ ^# && -n $key ]]; then
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)
            export "$key=$value"
        fi
    done < .env
    echo -e "${GREEN}✓ 环境变量已加载${NC}"
else
    echo -e "${RED}错误: .env 文件不存在${NC}"
    echo "请先运行: ./setup-dev.sh"
    exit 1
fi
cd src/backend

# 运行迁移（如果需要）
echo -e "${YELLOW}检查数据库迁移...${NC}"
python InvenTree/manage.py migrate

# 启动 Django 开发服务器
echo -e "\n${GREEN}======================================"
echo "Django 开发服务器启动中..."
echo "======================================${NC}"
echo -e "访问地址: ${GREEN}http://localhost:8000${NC}"
echo -e "Admin: ${GREEN}http://localhost:8000/admin/${NC}"
echo -e "API: ${GREEN}http://localhost:8000/api/${NC}"
echo ""
echo -e "${YELLOW}按 Ctrl+C 停止服务器${NC}"
echo ""

python InvenTree/manage.py runserver 0.0.0.0:8000
