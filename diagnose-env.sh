#!/bin/bash
# 诊断环境变量加载问题

echo "======================================"
echo "环境变量诊断脚本"
echo "======================================"

cd "$(dirname "$0")"

echo -e "\n1. 检查 .env 文件是否存在："
if [ -f .env ]; then
    echo "✓ .env 文件存在"
    echo -e "\n2. .env 文件内容（数据库配置）："
    grep "INVENTREE_DB" .env | head -10
else
    echo "✗ .env 文件不存在"
    exit 1
fi

echo -e "\n3. 测试环境变量加载方式："

echo -e "\n方式 A: set -a; source .env; set +a"
(
    set -a
    source .env
    set +a
    echo "  INVENTREE_DB_ENGINE = $INVENTREE_DB_ENGINE"
    echo "  INVENTREE_DB_NAME = $INVENTREE_DB_NAME"
    echo "  INVENTREE_DB_HOST = $INVENTREE_DB_HOST"
)

echo -e "\n方式 B: export \$(cat .env | grep -v '^#' | xargs)"
(
    export $(cat .env | grep -v '^#' | xargs)
    echo "  INVENTREE_DB_ENGINE = $INVENTREE_DB_ENGINE"
    echo "  INVENTREE_DB_NAME = $INVENTREE_DB_NAME"
    echo "  INVENTREE_DB_HOST = $INVENTREE_DB_HOST"
)

echo -e "\n4. 测试 Python 能否读取环境变量："
echo -e "\n使用方式 A (set -a):"
(
    set -a
    source .env
    set +a
    cd src/backend
    source venv/bin/activate
    python -c "
import os
print(f'  INVENTREE_DB_ENGINE = {os.environ.get(\"INVENTREE_DB_ENGINE\", \"NOT SET\")}')
print(f'  INVENTREE_DB_NAME = {os.environ.get(\"INVENTREE_DB_NAME\", \"NOT SET\")}')
print(f'  INVENTREE_DB_HOST = {os.environ.get(\"INVENTREE_DB_HOST\", \"NOT SET\")}')
"
)

echo -e "\n使用方式 B (export + xargs):"
(
    export $(cat .env | grep -v '^#' | xargs)
    cd src/backend
    source venv/bin/activate
    python -c "
import os
print(f'  INVENTREE_DB_ENGINE = {os.environ.get(\"INVENTREE_DB_ENGINE\", \"NOT SET\")}')
print(f'  INVENTREE_DB_NAME = {os.environ.get(\"INVENTREE_DB_NAME\", \"NOT SET\")}')
print(f'  INVENTREE_DB_HOST = {os.environ.get(\"INVENTREE_DB_HOST\", \"NOT SET\")}')
"
)

echo -e "\n======================================"
echo "诊断完成"
echo "======================================"
