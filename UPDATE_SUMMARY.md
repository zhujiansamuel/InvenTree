# 更新摘要 - 修复 Python 版本和环境变量问题

## ✅ 已提交的修改

### 1. **Python 版本智能检测** (`setup-dev.sh`)

**问题：** Python 3.14 太新，Django 可能不兼容

**修复：**
- ✅ 自动检测 Python 版本
- ✅ 推荐使用 Python 3.11 或 3.12
- ✅ 如果检测到 Python 3.13+，自动尝试查找 `python3.12` 或 `python3.11`
- ✅ 清晰的错误提示和安装指南（macOS Homebrew）

**修改内容：**
```bash
# 现在会自动检测并使用合适的 Python 版本
- 自动查找 python3.12
- 自动查找 python3.11
- 如果都没有，提示用户安装
```

### 2. **改进环境变量加载方式**

**问题：** `export $(cat .env | xargs)` 在某些情况下不可靠

**修复（3个文件）：**
- ✅ `setup-dev.sh` - 初始化脚本
- ✅ `start-backend.sh` - 后端启动脚本
- ✅ `start-worker.sh` - Worker 启动脚本

**改进方式：**
```bash
# 之前（不可靠）
export $(cat ../../.env | grep -v '^#' | xargs)

# 现在（更可靠）
cd ../..
set -a        # 自动导出所有变量
source .env   # 加载 .env 文件
set +a        # 关闭自动导出
cd src/backend
```

### 3. **添加验证步骤** (`setup-dev.sh`)

**新增功能：**
- ✅ 检查 `.env` 文件是否存在
- ✅ 验证关键环境变量（如 `INVENTREE_DB_ENGINE`）
- ✅ 更好的错误消息和故障排查提示

### 4. **新增故障排查文档** (`TROUBLESHOOTING.md`)

**包含内容：**
- 🔧 常见问题及解决方案
  - Python 版本问题
  - 数据库配置问题
  - Docker 服务问题
  - 端口占用问题
  - 虚拟环境问题
  - 前端问题
  - 权限问题
  - 数据库迁移问题
- 📋 诊断检查清单
- 💡 获取帮助的资源链接

---

## 🚀 你接下来需要做什么

### 步骤 1：拉取最新代码

```bash
cd /Users/syu/PycharmProjects/InvenTree
git pull origin claude/document-inventory-tech-stack-zszYY
```

### 步骤 2：检查并安装正确的 Python 版本

```bash
# 检查当前版本
python3 --version
python3.12 --version
python3.11 --version
```

**如果你有 Python 3.14，需要安装 3.12：**

```bash
# 使用 Homebrew
brew install python@3.12

# 验证安装
python3.12 --version
```

### 步骤 3：清理旧的虚拟环境

```bash
cd src/backend
rm -rf venv
cd ../..
```

### 步骤 4：重新初始化

```bash
# 运行更新后的初始化脚本
./setup-dev.sh
```

**脚本现在会：**
1. ✅ 自动检测并使用 Python 3.12（如果可用）
2. ✅ 使用正确的方式加载环境变量
3. ✅ 验证环境变量是否正确设置
4. ✅ 提供更好的错误提示

### 步骤 5：安装前端依赖

```bash
cd src/frontend
npm install
cd ../..
```

### 步骤 6：启动服务

**打开 3 个终端窗口：**

```bash
# 终端 1
./start-backend.sh

# 终端 2
./start-worker.sh

# 终端 3
./start-frontend.sh
```

---

## 🔍 如果仍有问题

### 快速诊断

```bash
# 1. 验证 Python 版本
cd src/backend
source venv/bin/activate
python --version  # 应该显示 3.11.x 或 3.12.x

# 2. 验证 Django 安装
python -c "import django; print(django.VERSION)"

# 3. 验证环境变量
cd ../..
set -a
source .env
set +a
echo $INVENTREE_DB_ENGINE  # 应该显示 postgresql
echo $INVENTREE_DB_NAME    # 应该显示 inventree

# 4. 测试数据库连接
psql -h localhost -p 5432 -U inventree -d inventree
# 密码: inventree123
```

### 查看完整的故障排查指南

```bash
cat TROUBLESHOOTING.md
# 或在浏览器中打开
```

---

## 📚 相关文档

| 文档 | 用途 |
|------|------|
| `TROUBLESHOOTING.md` | 🆕 **完整的故障排查指南** |
| `QUICK_START.md` | 快速开始指南 |
| `DEVELOPMENT_SETUP.md` | 详细设置文档 |
| `PATH_FIX.md` | 路径修复说明 |
| `TECH_STACK.md` | 技术栈文档 |

---

## 📝 本次更新的技术细节

### 为什么改用 `set -a; source .env; set +a`？

**原因：**
1. **更可靠**：`source` 命令会正确处理引号、特殊字符和多行值
2. **符合标准**：这是推荐的 shell 环境变量加载方式
3. **避免问题**：`xargs` 可能会错误解析某些值

**原理：**
- `set -a`：开启 `allexport` 选项，所有变量自动导出到环境
- `source .env`：执行 .env 文件，设置变量
- `set +a`：关闭 `allexport` 选项

### Python 版本检测逻辑

```bash
1. 检查 python3 --version
2. 如果是 3.11 或 3.12 → ✅ 使用
3. 如果是 3.13+ → 警告并尝试查找 python3.12 或 python3.11
4. 如果 < 3.11 → ❌ 错误退出
```

---

## 🎯 预期结果

运行 `./setup-dev.sh` 后，你应该看到：

```bash
[3/8] 检查 Python 3.11 或 3.12...
✓ 找到 Python 3.12，将使用此版本

[6/8] 设置 Python 虚拟环境...
使用 python3.12 创建虚拟环境...
✓ 虚拟环境已创建 (Python 3.12)

[8/8] 运行数据库迁移...
加载环境变量...
✓ 环境变量已加载
Operations to perform:
  Apply all migrations: ...
Running migrations:
  ...
✓ 数据库迁移完成

✓ 初始化完成！
```

---

## ❓ 常见问题

### Q: 我还是遇到 Django 导入错误怎么办？

**A:** 确保虚拟环境使用的是正确的 Python 版本：
```bash
cd src/backend
source venv/bin/activate
python --version  # 必须是 3.11.x 或 3.12.x
```

### Q: 环境变量还是没有加载怎么办？

**A:** 手动测试：
```bash
cd /Users/syu/PycharmProjects/InvenTree
set -a
source .env
set +a
echo $INVENTREE_DB_ENGINE
```

### Q: 我需要删除所有数据重新开始吗？

**A:** 不需要，只需要：
```bash
# 删除虚拟环境
rm -rf src/backend/venv

# 重新初始化
./setup-dev.sh
```

数据库数据会保留在 Docker 卷中。

---

**更新时间**: 2025-12-27 09:15 UTC
**提交哈希**: `65c9b55`
**分支**: `claude/document-inventory-tech-stack-zszYY`
