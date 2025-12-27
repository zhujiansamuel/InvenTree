# 路径问题修复说明

## 问题描述

初始版本的 `setup-dev.sh` 和 `setup-dev.bat` 脚本中，安装开发依赖的路径不正确：

```bash
# 错误的路径
pip install -r ../contrib/dev_reqs/requirements.txt  # ❌

# 正确的路径
pip install -r ../../contrib/dev_reqs/requirements.txt  # ✅
```

## 已修复的文件

1. ✅ `setup-dev.sh` - Linux/macOS 初始化脚本
2. ✅ `setup-dev.bat` - Windows 初始化脚本
3. ✅ 改进了环境变量加载（过滤注释）

## 修复详情

### 路径修复
当脚本执行到 `src/backend` 目录时，相对于项目根目录的路径应该是：
- `../../contrib/dev_reqs/requirements.txt` ✅

### 环境变量加载改进
```bash
# 之前
export $(cat ../../.env | xargs)

# 现在（过滤注释行）
export $(cat ../../.env | grep -v '^#' | xargs)
```

## 如何修复已有环境

如果你已经运行过 `setup-dev.sh` 但遇到错误：

### 方法 1：清理并重新初始化

```bash
# 1. 删除虚拟环境
cd src/backend
rm -rf venv
cd ../..

# 2. 拉取最新代码
git pull origin claude/document-inventory-tech-stack-zszYY

# 3. 重新初始化
./setup-dev.sh
```

### 方法 2：手动安装缺失的依赖

```bash
cd src/backend
source venv/bin/activate  # Linux/macOS
# 或 call venv\Scripts\activate.bat  # Windows

# 安装开发依赖
pip install -r ../../contrib/dev_reqs/requirements.txt
```

## 验证修复

运行以下命令验证环境是否正确：

```bash
cd src/backend
source venv/bin/activate
python -c "import pytest; print('开发环境配置成功！')"
```

如果看到 "开发环境配置成功！"，说明环境已正确配置。

## 下一步

环境修复后，继续按照 `QUICK_START.md` 的步骤：

1. ✅ 初始化完成
2. 📦 安装前端依赖: `cd src/frontend && npm install`
3. 🚀 启动服务（3个终端）
4. 🌐 访问 http://localhost:5173

---

**更新时间**: 2025-12-27
**版本**: v1.1 (路径修复版)
