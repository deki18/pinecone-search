# Pinecone Search - 向量知识库搜索技能

**Pinecone 向量搜索工具**，用于搜索本地知识库中的规范、标准、施工等文档。

## 📌 功能描述

这个技能提供向量数据库搜索功能，支持通过自然语言查询来搜索存储在工作知识库中的文档和数据。

**核心特性：**
- 🧠 基于语义理解的向量搜索
- 📁 支持自定义索引名称和命名空间
- 🔧 可配置的向量模型和 API
- 🎯 精确的相似度评分
- 📊 返回结构化搜索结果

## 🚀 使用方法

### 快速开始

1. **配置环境变量**
   ```bash
   cp config.example.env .env
   # 编辑 .env 文件，填入你的配置
   ```

2. **运行搜索**
   ```bash
   python search_tool.py "你的查询"
   python search_tool.py "查询内容" --top-k 5
   ```

### 作为 OpenClaw 技能使用

当用户提到以下关键词时自动触发：
- "规范"、"标准"、"施工"
- "查询资料"
- 任何需要搜索知识库的场景

## ⚙️ 配置说明

### 环境变量（.env 文件）

必须配置以下环境变量：

```env
# Pinecone API Key
PINECONE_API_KEY=your_pinecone_api_key

# 向量嵌入 API Key
EMBEDDING_API_KEY=your_embedding_api_key

# 向量嵌入 API 地址
EMBEDDING_BASE_URL=https://api.vectorengine.ai/v1

# 向量嵌入模型（可自定义）
EMBEDDING_MODEL=text-embedding-3-large

# Pinecone 索引名称
INDEX_NAME=workspace

# Pinecone 命名空间（可选，用于隔离不同数据）
NAMESPACE=design-standard
```

### 可选配置

- **INDEX_NAME**: 你的 Pinecone 索引名称
- **NAMESPACE**: 数据命名空间（用于隔离不同项目/用途的数据）
- **EMBEDDING_MODEL**: 使用的向量模型（默认 text-embedding-3-large）

## 🔧 工具接口

### 命令行调用

```bash
# 基础搜索
python search_tool.py "查询内容"

# 自定义返回数量
python search_tool.py "查询内容" --top-k 5
```

### 参数说明

- `query` (必需): 搜索查询文本
- `--top-k` (可选): 返回结果数量，默认 3

## 📖 使用示例

### 场景 1：查询施工规范
```bash
python search_tool.py "混凝土浇筑标准是什么？"
```

### 场景 2：查找安全规范
```bash
python search_tool.py "施工现场安全注意事项"
```

### 场景 3：搜索技术文档
```bash
python search_tool.py "API 接口设计规范"
```

### 场景 4：在 OpenClaw 中使用
```
用户："帮我查一下最新的施工规范"
AI: 正在调用 Pinecone Search... [显示搜索结果]
```

## 🔍 返回结果格式

```json
[
  {
    "rank": 1,
    "score": 0.89,
    "text": "文档内容...",
    "source": "文档来源"
  },
  {
    "rank": 2,
    "score": 0.85,
    "text": "文档内容...",
    "source": "文档来源"
  }
]
```

## ⚠️ 注意事项

1. **敏感信息保护**
   - 不要将 `.env` 文件提交到版本控制系统
   - 在技能目录中提供 `config.example.env` 模板

2. **API 配置**
   - 必须配置有效的 Pinecone 和嵌入 API Key
   - 确保 API Key 有足够的权限

3. **索引配置**
   - 确保索引已创建并可访问
   - 检查命名空间是否存在（如果配置了命名空间）

## 🛠️ 技术栈

- **Python 3.7+**
- **Pinecone SDK**
- **OpenAI Python SDK** (用于向量嵌入)
- **python-dotenv** (环境变量管理)

## 📝 示例输出

```
🔍 正在搜索: 混凝土浇筑标准

============================================================
【结果 #1】
匹配度: 0.8934
来源: 施工规范_2024.pdf
内容:
  混凝土浇筑应符合以下标准：
  1. 坍落度测试应控制在 160±20mm
  2. 浇筑后 12小时内必须覆盖保湿
  3. 养护时间不少于 7天
------------------------------------------------------------
【结果 #2】
匹配度: 0.8567
来源: 质量检查手册.pdf
内容:
  混凝土强度检测：
  - 3天试块强度应达到设计强度的 75%
  - 7天试块强度应达到设计强度的 90%
  - 28天试块强度应达到设计强度的 100%
------------------------------------------------------------
```

## 🔄 更新日志

- **v1.0.0** (2026-03-09)
  - 初始版本发布
  - 支持基础向量搜索功能
  - 可配置的索引和命名空间

## 📄 许可证

MIT License

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📞 支持

如有问题，请创建 GitHub Issue 或联系维护者。
