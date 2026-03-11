# Pinecone Search 技能

快速入门指南：

## 1. 安装依赖

```bash
./setup.sh
```

## 2. 配置 API Key

编辑 `.env` 文件，填入你的 API Key：

```env
PINECONE_API_KEY=your_pinecone_key
EMBEDDING_API_KEY=your_embedding_key
EMBEDDING_BASE_URL=https://api.vectorengine.ai/v1
```

## 3. 使用搜索

```bash
# 激活虚拟环境
source venv/bin/activate

# 执行搜索
python search_tool.py "你的查询"
```

## 4. 在 OpenClaw 中使用

当用户提到"规范"、"标准"、"施工"或"查询资料"时自动触发搜索功能。

---

详细文档请查看 [SKILL.md](./SKILL.md)
