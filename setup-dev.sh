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

# 检查 Python 版本
echo -e "\n${YELLOW}[3/8] 检查 Python 3.11 或 3.12...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}错误: 请先安装 Python 3.11 或 3.12${NC}"
    echo "macOS 安装方法: brew install python@3.12"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d'.' -f1)
PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d'.' -f2)

PYTHON_CMD=python3

# 检查版本是否合适
if [ "$PYTHON_MAJOR" -eq 3 ] && ([ "$PYTHON_MINOR" -eq 11 ] || [ "$PYTHON_MINOR" -eq 12 ]); then
    echo -e "${GREEN}✓ Python ${PYTHON_VERSION} 已安装${NC}"
elif [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -ge 13 ]; then
    echo -e "${YELLOW}警告: Python ${PYTHON_VERSION} 可能太新，InvenTree 推荐使用 Python 3.11 或 3.12${NC}"
    echo -e "${YELLOW}尝试寻找兼容版本...${NC}"

    if command -v python3.12 &> /dev/null; then
        PYTHON_CMD=python3.12
        PYTHON_VERSION=$(python3.12 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
        echo -e "${GREEN}✓ 找到 Python 3.12，将使用此版本${NC}"
    elif command -v python3.11 &> /dev/null; then
        PYTHON_CMD=python3.11
        PYTHON_VERSION=$(python3.11 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
        echo -e "${GREEN}✓ 找到 Python 3.11，将使用此版本${NC}"
    else
        echo -e "${YELLOW}未找到 Python 3.11/3.12，继续使用 Python ${PYTHON_VERSION}${NC}"
        echo -e "${YELLOW}如果遇到问题，请安装: brew install python@3.12${NC}"
    fi
else
    echo -e "${RED}错误: Python ${PYTHON_VERSION} 版本过低，需要 3.11 或更高${NC}"
    echo "macOS 安装方法: brew install python@3.12"
    exit 1
fi

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
    echo "使用 $PYTHON_CMD 创建虚拟环境..."
    $PYTHON_CMD -m venv venv
    echo -e "${GREEN}✓ 虚拟环境已创建 (Python $PYTHON_VERSION)${NC}"
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

# 加载环境变量（使用显式导出方式）
echo "加载环境变量..."
cd ../..
if [ -f .env ]; then
    # 方法：逐行读取并导出
    while IFS='=' read -r key value; do
        # 跳过注释和空行
        if [[ ! $key =~ ^#  && -n $key ]]; then
            # 移除前后空格
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)
            # 导出变量
            export "$key=$value"
        fi
    done < .env
    echo -e "${GREEN}✓ 环境变量已加载${NC}"
else
    echo -e "${RED}错误: .env 文件不存在${NC}"
    exit 1
fi

# 验证关键环境变量
if [ -z "$INVENTREE_DB_ENGINE" ]; then
    echo -e "${RED}错误: INVENTREE_DB_ENGINE 未设置${NC}"
    echo "当前环境变量："
    env | grep INVENTREE_DB || true
    exit 1
fi

echo "数据库配置："
echo "  ENGINE: $INVENTREE_DB_ENGINE"
echo "  NAME: $INVENTREE_DB_NAME"
echo "  HOST: $INVENTREE_DB_HOST"

cd src/backend
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
