# InvenTree 技术栈文档

> InvenTree 开源库存管理系统完整技术栈说明

## 📋 目录
- [架构概览](#架构概览)
- [后端技术栈](#后端技术栈)
- [前端技术栈](#前端技术栈)
- [数据库与缓存](#数据库与缓存)
- [库存管理核心设计](#库存管理核心设计)
- [DevOps 工具链](#devops-工具链)

---

## 🏗️ 架构概览

InvenTree 采用 **前后端分离架构**：

```
┌─────────────────────────────────────────────────────────┐
│                     用户界面层                           │
│  ┌──────────────────┐      ┌──────────────────┐        │
│  │  React 前端       │      │  移动端 App      │        │
│  │  (TypeScript)    │      │  (Flutter)       │        │
│  └────────┬─────────┘      └────────┬─────────┘        │
└───────────┼─────────────────────────┼──────────────────┘
            │                         │
            └────────────┬────────────┘
                         │ REST API
┌────────────────────────┼──────────────────────────────┐
│                        ▼                               │
│                  API Gateway                           │
│          (Django REST Framework)                       │
│                                                        │
│  ┌──────────────────────────────────────────────┐    │
│  │           Django 应用层                        │    │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐│    │
│  │  │ Stock  │ │  Part  │ │ Build  │ │ Order  ││    │
│  │  │ 库存   │ │  零件  │ │ 生产   │ │ 订单   ││    │
│  │  └────────┘ └────────┘ └────────┘ └────────┘│    │
│  └──────────────────┬───────────────────────────┘    │
│                     │                                 │
│                     ▼                                 │
│           ┌─────────────────────┐                     │
│           │   Django ORM        │                     │
│           └─────────┬───────────┘                     │
└─────────────────────┼─────────────────────────────────┘
                      │
        ┌─────────────┼─────────────┐
        │             │             │
        ▼             ▼             ▼
   PostgreSQL      Redis        文件存储
   (主数据库)     (缓存/队列)   (Media/Static)
```

---

## 🐍 后端技术栈

### 核心框架
| 技术 | 版本 | 用途 |
|------|------|------|
| **Python** | 3.11+ | 主要编程语言 |
| **Django** | 5.2.9 | Web 框架 |
| **Django REST Framework** | 3.16.1 | REST API 构建 |
| **Gunicorn** | 23.0.0 | WSGI 应用服务器 |

### 数据库与 ORM
| 技术 | 用途 |
|------|------|
| **Django ORM** | 对象关系映射 |
| **django-mptt** | 树状结构管理（MPTT 算法） |
| **PostgreSQL** | 首选数据库（生产环境） |
| **MySQL** | 备选数据库 |
| **SQLite** | 开发/测试数据库 |

### 异步任务与缓存
| 技术 | 用途 |
|------|------|
| **Django-Q** | 异步任务队列 |
| **Redis** | 缓存 + 消息队列 |
| **django-redis** | Redis 集成 |

### 认证与授权
| 技术 | 用途 |
|------|------|
| **django-allauth** | 用户认证（OAuth, SAML, MFA） |
| **django-oauth-toolkit** | OAuth2 提供商 |
| **django-otp** | 两步验证 |
| **@github/webauthn-json** | WebAuthn 支持 |

### API 与文档
| 技术 | 用途 |
|------|------|
| **DRF (Django REST Framework)** | REST API |
| **drf-simplejwt** | JWT 令牌认证 |
| **OpenAPI / Swagger** | API 文档 |

### 数据处理
| 技术 | 用途 |
|------|------|
| **django-money** | 货币处理 |
| **django-filter** | 查询过滤 |
| **Pillow** | 图像处理 |
| **python-barcode** | 条码生成 |
| **qrcode** | 二维码生成 |

### 其他后端工具
| 技术 | 用途 |
|------|------|
| **django-cleanup** | 自动清理文件 |
| **django-taggit** | 标签系统 |
| **django-cors-headers** | CORS 处理 |
| **structlog** | 结构化日志 |
| **django-dbbackup** | 数据库备份 |
| **django-ical** | 日历导出 |

---

## ⚛️ 前端技术栈

### 核心框架
| 技术 | 版本 | 用途 |
|------|------|------|
| **React** | 19.1.2 | UI 框架 |
| **TypeScript** | 5.8+ | 类型安全的 JavaScript |
| **Vite** | 7.1.11 | 构建工具 |

### UI 框架与组件
| 技术 | 版本 | 用途 |
|------|------|------|
| **Mantine** | 8.2.7 | 完整 UI 组件库 |
| **Mantine DataTable** | 8.2.0 | 数据表格 |
| **Mantine Charts** | 8.2.7 | 图表组件 |
| **@tabler/icons-react** | 3.17.0 | 图标库 |
| **Font Awesome** | 7.0.0 | 图标库 |

### 状态管理与数据获取
| 技术 | 版本 | 用途 |
|------|------|------|
| **Zustand** | 5.0.8 | 轻量级状态管理 |
| **TanStack Query** | 5.56.2 | 数据获取与缓存 |
| **Axios** | 1.8.4 | HTTP 客户端 |

### 路由与表单
| 技术 | 版本 | 用途 |
|------|------|------|
| **React Router** | 6.26.2 | 路由管理 |
| **React Hook Form** | 7.62.0 | 表单处理 |

### 代码编辑器
| 技术 | 版本 | 用途 |
|------|------|------|
| **CodeMirror** | 6.x | 代码编辑器核心 |
| **@uiw/react-codemirror** | 4.25.1 | React 集成 |

### 国际化
| 技术 | 版本 | 用途 |
|------|------|------|
| **Lingui** | 5.3+ | i18n 框架 |
| **@lingui/react** | 5.3.1 | React 集成 |

### 其他前端工具
| 技术 | 用途 |
|------|------|
| **Day.js** | 日期处理 |
| **Recharts** | 图表库 |
| **html5-qrcode** | 二维码扫描 |
| **qrcode** | 二维码生成 |
| **react-grid-layout** | 拖拽布局 |
| **react-window** | 虚拟滚动 |
| **DOMPurify** | XSS 防护 |
| **Sentry** | 错误追踪 |

---

## 💾 数据库与缓存

### 数据库支持
```yaml
生产环境推荐:
  - PostgreSQL 17      # 首选，功能最完整
  - MySQL 8.0+         # 备选

开发/测试环境:
  - SQLite 3           # 轻量级，无需独立服务
```

### Redis 用途
- **缓存**: 会话、查询结果、API 响应
- **消息队列**: 异步任务队列（Django-Q）
- **实时数据**: WebSocket 支持

### 存储后端
| 类型 | 支持 |
|------|------|
| **本地文件系统** | ✅ 默认 |
| **AWS S3** | ✅ 支持 |
| **SFTP** | ✅ 支持 |
| **自定义** | ✅ Django Storage 接口 |

---

## 📦 库存管理核心设计

### 数据模型层次

```
库存管理数据模型
│
├── Part（零件模块）
│   ├── PartCategory (零件分类) - MPTT 树状结构
│   ├── Part (零件主数据)
│   ├── PartParameter (零件参数)
│   ├── BOMItem (物料清单)
│   ├── PartTestTemplate (测试模板)
│   └── PartPricing (定价信息)
│
├── Stock（库存模块）
│   ├── StockLocationType (库位类型)
│   ├── StockLocation (库位) - MPTT 树状结构
│   │   └── 特性：层级化、可分类、支持外部库位
│   ├── StockItem (库存项)
│   │   ├── 数量管理
│   │   ├── 批次/序列号追踪
│   │   ├── 状态管理（可用/隔离/损坏等）
│   │   ├── 到期日期
│   │   └── 多级结构（parent-child）
│   ├── StockItemTracking (库存历史)
│   └── StockItemTestResult (测试结果)
│
├── Build（生产模块）
│   ├── Build (生产订单)
│   └── BuildItem (生产物料)
│
├── Order（订单模块）
│   ├── PurchaseOrder (采购订单)
│   ├── SalesOrder (销售订单)
│   └── ReturnOrder (退货订单)
│
└── Company（公司模块）
    ├── Company (公司主数据)
    ├── SupplierPart (供应商零件)
    └── Contact (联系人)
```

### 核心算法

#### MPTT（Modified Preorder Tree Traversal）
- **用途**: 零件分类、库位层级
- **优势**: 高效的树查询（子树、祖先）
- **实现**: django-mptt

#### 库存追踪
```python
# 每次库存变动都会记录
StockItemTracking:
  - 数量变化
  - 操作类型（入库/出库/移库/盘点等）
  - 操作用户
  - 时间戳
  - 备注
```

#### 状态机
```python
# 库存状态
StockStatus:
  - OK (10)              # 正常
  - ATTENTION (50)       # 注意
  - DAMAGED (55)         # 损坏
  - DESTROYED (60)       # 报废
  - REJECTED (65)        # 拒收
  - LOST (70)            # 丢失
  - QUARANTINED (75)     # 隔离
  - RETURNED (85)        # 退货
```

### 关键特性

#### 1. 批次和序列号管理
```python
StockItem:
  batch: str           # 批次号
  serial: str          # 序列号（唯一）
  quantity: Decimal    # 数量（批次模式允许 >1）
```

#### 2. 库位管理
```python
StockLocation:
  parent: ForeignKey   # 父库位（支持无限层级）
  structural: bool     # 结构性库位（不直接存储库存）
  external: bool       # 外部库位
  location_type: FK    # 库位类型
```

#### 3. 库存分配
```python
# 库存可分配给：
- SalesOrder（销售订单）
- Build（生产订单）
- Customer（客户）
- 安装到其他 StockItem（组装件）
```

#### 4. 质量管理
```python
PartTestTemplate:      # 零件测试模板
  - required: bool     # 是否必需
  - key: str           # 测试键
  - template: str      # 模板名称

StockItemTestResult:   # 测试结果
  - test: FK           # 测试模板
  - result: bool       # 通过/失败
  - value: str         # 测试值
  - date: DateTime     # 测试日期
```

---

## 🚀 DevOps 工具链

### 容器化
| 工具 | 用途 |
|------|------|
| **Docker** | 容器运行时 |
| **Docker Compose** | 多容器编排 |
| **Multi-stage builds** | 优化镜像大小 |

### CI/CD
| 工具 | 用途 |
|------|------|
| **GitHub Actions** | 自动化构建、测试、部署 |
| **Codecov** | 代码覆盖率 |
| **SonarCloud** | 代码质量分析 |

### 测试
| 工具 | 用途 |
|------|------|
| **Django Test** | 后端单元测试 |
| **Playwright** | 前端 E2E 测试 |
| **pytest** | Python 测试框架 |
| **nyc** | JavaScript 代码覆盖率 |

### 代码质量
| 工具 | 用途 |
|------|------|
| **Ruff** | Python 代码检查 |
| **ESLint** | JavaScript/TypeScript 检查 |
| **Prettier** | 代码格式化 |
| **pre-commit** | Git 钩子 |

### 翻译
| 工具 | 用途 |
|------|------|
| **Crowdin** | 众包翻译平台 |
| **Lingui** | 前端国际化 |
| **Django i18n** | 后端国际化 |

### 部署
| 平台 | 支持 |
|------|------|
| **Docker Hub** | ✅ 官方镜像 |
| **Digital Ocean** | ✅ 一键部署 |
| **Bare Metal** | ✅ 手动安装 |
| **Packager.io** | ✅ 系统包 |

---

## 📊 性能优化

### 后端优化
- **查询优化**: `select_related()`, `prefetch_related()`
- **数据库索引**: 关键字段建立索引
- **缓存策略**: Redis 缓存查询结果
- **异步任务**: 耗时操作移至后台队列
- **分页**: API 默认分页限制

### 前端优化
- **代码分割**: Vite 动态导入
- **虚拟滚动**: react-window 处理大列表
- **懒加载**: 图片、组件按需加载
- **Tree Shaking**: 自动移除未使用代码
- **Memoization**: React.memo, useMemo

---

## 🔒 安全特性

### 认证安全
- ✅ 多因素认证 (MFA)
- ✅ WebAuthn / FIDO2
- ✅ OAuth 2.0 / SAML
- ✅ 密码策略
- ✅ 登录限制

### API 安全
- ✅ JWT 令牌
- ✅ CORS 配置
- ✅ 速率限制
- ✅ 权限系统
- ✅ XSS 防护 (DOMPurify)

### 数据安全
- ✅ 数据库加密
- ✅ 文件上传验证
- ✅ SQL 注入防护
- ✅ CSRF 保护
- ✅ 安全的会话管理

---

## 📈 可扩展性

### 插件系统
```python
# InvenTree 支持自定义插件
PluginBase:
  - API 扩展
  - 事件钩子
  - 自定义面板
  - 条码处理器
  - 标签打印
  - 报表模板
```

### 集成能力
- ✅ REST API（完整 CRUD）
- ✅ Webhook 事件
- ✅ 第三方认证
- ✅ 自定义存储后端
- ✅ 外部插件系统

---

## 🌐 浏览器支持

| 浏览器 | 最低版本 |
|--------|----------|
| Chrome | 90+ |
| Firefox | 88+ |
| Safari | 14+ |
| Edge | 90+ |

---

## 📝 许可证

- **项目许可**: MIT License
- **依赖许可**: 各组件遵循各自许可证

---

## 🔗 相关链接

- **官方文档**: https://docs.inventree.org/
- **API 文档**: https://docs.inventree.org/en/latest/api/
- **插件开发**: https://docs.inventree.org/en/latest/plugins/
- **源代码**: https://github.com/inventree/InvenTree
- **Docker Hub**: https://hub.docker.com/r/inventree/inventree

---

**最后更新**: 2025-12-27
