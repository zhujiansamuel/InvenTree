#!/bin/bash
# InvenTree 后台任务 Worker 启动脚本

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}======================================"
echo "启动 InvenTree 后台任务 Worker"
echo "======================================${NC}"

# 激活虚拟环境
cd src/backend
source venv/bin/activate

# 加载环境变量（使用更可靠的方式）
cd ../..
if [ -f .env ]; then
    set -a
    source .env
    set +a
else
    echo -e "${RED}错误: .env 文件不存在${NC}"
    echo "请先运行: ./setup-dev.sh"
    exit 1
fi
cd src/backend

# 启动 Django-Q Worker
echo -e "\n${GREEN}Django-Q Worker 启动中...${NC}"
echo -e "${YELLOW}按 Ctrl+C 停止 Worker${NC}"
echo ""

python InvenTree/manage.py qcluster
