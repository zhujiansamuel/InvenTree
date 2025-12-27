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

# 加载环境变量
export $(cat ../../.env | grep -v '^#' | xargs)

# 启动 Django-Q Worker
echo -e "\n${GREEN}Django-Q Worker 启动中...${NC}"
echo -e "${YELLOW}按 Ctrl+C 停止 Worker${NC}"
echo ""

python InvenTree/manage.py qcluster
