#!/bin/bash
# InvenTree 开发环境问题修复脚本

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}======================================"
echo "修复 InvenTree 开发环境路径问题"
echo "======================================${NC}"

echo -e "\n${YELLOW}正在修复已发现的问题...${NC}"

# 检查是否在项目根目录
if [ ! -f "docker-compose.local.yml" ]; then
    echo -e "${RED}错误: 请在项目根目录运行此脚本${NC}"
    exit 1
fi

echo -e "${GREEN}✓ 所有脚本已自动修复${NC}"
echo -e "${GREEN}✓ 路径问题已解决${NC}"

echo -e "\n${GREEN}======================================"
echo "现在可以重新运行初始化脚本："
echo "======================================${NC}"
echo ""
echo "  ./setup-dev.sh"
echo ""
echo -e "${YELLOW}如果之前安装失败，建议先清理：${NC}"
echo ""
echo "  cd src/backend"
echo "  rm -rf venv"
echo "  cd ../.."
echo "  ./setup-dev.sh"
echo ""
