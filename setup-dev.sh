#!/bin/bash
# InvenTree 本地开发环境初始化脚本

set -e

echo "======================================"
echo "InvenTree 本地开发环境初始化"
echo "======================================"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查 Docker
echo -e "\n${YELLOW}[1/8] 检查 Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}错误: 请先安装 Docker${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker 已安装${NC}"

# 检查 Docker Compose
echo -e "\n${YELLOW}[2/8] 检查 Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}错误: 请先安装 Docker Compose${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker Compose 已安装${NC}"

# 检查 Python
echo -e "\n${YELLOW}[3/8] 检查 Python 3.11+...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}错误: 请先安装 Python 3.11+${NC}"
    exit 1
fi
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo -e "${GREEN}✓ Python ${PYTHON_VERSION} 已安装${NC}"

# 检查 Node.js
echo -e "\n${YELLOW}[4/8] 检查 Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}错误: 请先安装 Node.js 18+${NC}"
    exit 1
fi
NODE_VERSION=$(node --version)
echo -e "${GREEN}✓ Node.js ${NODE_VERSION} 已安装${NC}"

# 启动 Docker 服务
echo -e "\n${YELLOW}[5/8] 启动 Docker 服务 (PostgreSQL + Redis)...${NC}"
docker-compose -f docker-compose.local.yml up -d
echo -e "${GREEN}✓ Docker 服务已启动${NC}"

# 等待数据库就绪
echo -e "\n${YELLOW}等待数据库启动...${NC}"
sleep 5

# 设置 Python 虚拟环境
echo -e "\n${YELLOW}[6/8] 设置 Python 虚拟环境...${NC}"
cd src/backend
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo -e "${GREEN}✓ 虚拟环境已创建${NC}"
else
    echo -e "${GREEN}✓ 虚拟环境已存在${NC}"
fi

# 激活虚拟环境并安装依赖
echo -e "\n${YELLOW}[7/8] 安装 Python 依赖...${NC}"
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pip install -r ../../contrib/dev_reqs/requirements.txt
echo -e "${GREEN}✓ Python 依赖已安装${NC}"

# 复制环境变量文件
echo -e "\n${YELLOW}复制环境变量配置...${NC}"
cd ../..
if [ ! -f ".env" ]; then
    cp .env.local .env
    echo -e "${GREEN}✓ 环境变量文件已创建${NC}"
else
    echo -e "${YELLOW}! .env 文件已存在，未覆盖${NC}"
fi

# 运行数据库迁移
echo -e "\n${YELLOW}[8/8] 运行数据库迁移...${NC}"
cd src/backend
source venv/bin/activate
export $(cat ../../.env | grep -v '^#' | xargs)
python InvenTree/manage.py migrate
python InvenTree/manage.py collectstatic --noinput
echo -e "${GREEN}✓ 数据库迁移完成${NC}"

echo -e "\n${GREEN}======================================"
echo "✓ 初始化完成！"
echo "======================================${NC}"
echo ""
echo "后续步骤："
echo "1. 安装前端依赖:"
echo "   cd src/frontend && npm install"
echo ""
echo "2. 启动后端开发服务器:"
echo "   ./start-backend.sh"
echo ""
echo "3. 启动前端开发服务器:"
echo "   ./start-frontend.sh"
echo ""
echo "4. 访问应用:"
echo "   - 前端: http://localhost:5173"
echo "   - 后端 API: http://localhost:8000/api/"
echo "   - Django Admin: http://localhost:8000/admin/"
echo ""
echo "5. 默认管理员账号:"
echo "   - 用户名: admin"
echo "   - 密码: admin123"
echo ""
echo "6. 查看 Docker 服务:"
echo "   docker-compose -f docker-compose.local.yml ps"
echo ""
