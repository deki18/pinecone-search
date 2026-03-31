# Pinecone 文档上传与向量嵌入功能升级计划（精简版）

## 项目概述
将 pinecone-search 升级为支持 TXT、Markdown 文件上传的完整知识库系统，同时保持文件数量精简以适应 ClawHub 限制。

## 技术参考标准
- **OpenAI**: 文本嵌入最佳实践
- **LangChain**: RecursiveCharacterTextSplitter 分块策略
- **Pinecone**: 批量 upsert 和元数据管理

---

## 解决方案：单文件 + 模块化设计

### 核心思路
将所有功能集中在 **2-3 个 Python 文件** 中，通过类和方法组织代码，而非分散的模块。

### 文件结构（精简后）
```
pinecone-search/
├── pinecone_tool.py      # 核心模块：配置+加载+分割+嵌入+客户端（单文件）
├── upload.py             # 上传 CLI 命令
├── search.py             # 搜索 CLI 命令（现有功能整合）
├── config.example.env    # 配置示例
├── requirements.txt      # 依赖
└── SKILL.md              # Skill 定义
```

**总计：6 个文件**（符合 ClawHub 限制）

---

## Phase 1: 核心模块设计（pinecone_tool.py）

### 1.1 类结构设计
```python
# 单文件内通过类组织功能

class Config:
    """配置管理（Pydantic）"""
    
class DocumentLoader:
    """文档加载器（支持 TXT/Markdown）"""
    
class TextSplitter:
    """递归字符文本分割器"""
    
class EmbeddingClient:
    """向量嵌入客户端（批量+重试）"""
    
class PineconeManager:
    """Pinecone 管理（连接+upsert+查询）"""
    
class KnowledgeBase:
    """知识库主类（整合所有功能）"""
```

### 1.2 技术实现细节

#### 文档加载器
- **TXT**: 自动编码检测（chardet），流式读取
- **Markdown**: 保留标题层级，提取 frontmatter

#### 文本分割器（参考 LangChain）
```python
# 递归分割策略
separators = ["\n\n", "\n", "。", ". ", " ", ""]
chunk_size = 1000  # tokens
chunk_overlap = 200  # 20% 重叠
```

#### 向量嵌入
- 批量嵌入：100 条/批次
- 退避重试：指数退避 3 次
- 速率限制：RPM 控制

#### Pinecone Upsert
- 批次大小：100 vectors
- 元数据：source, filename, chunk_index, total_chunks
- ID 生成：{filename_hash}_{chunk_index}

---

## Phase 2: CLI 命令

### upload.py
```bash
python upload.py path/to/file.txt
python upload.py ./docs/ --recursive --namespace project-a
python upload.py file.md --chunk-size 512 --overlap 100
```

### search.py（整合现有功能）
```bash
python search.py "查询内容"
python search.py "查询" --namespace project-a --top-k 5
```

---

## Phase 3: 关键代码示例

### 递归文本分割
```python
def split_text(self, text: str) -> List[str]:
    """递归字符分割"""
    separators = ["\n\n", "\n", "。", ". ", " ", ""]
    
    chunks = []
    for sep in separators:
        if sep == "":
            # 最后按字符分割
            for i in range(0, len(text), self.chunk_size):
                chunks.append(text[i:i + self.chunk_size])
            return chunks
            
        parts = text.split(sep)
        if len(parts) > 1:
            # 递归处理每个部分
            for part in parts:
                if self._token_count(part) > self.chunk_size:
                    chunks.extend(self.split_text(part))
                else:
                    chunks.append(part)
            return self._merge_chunks(chunks)  # 合并小 chunks
    
    return chunks
```

### 批量嵌入
```python
def embed_batch(self, texts: List[str]) -> List[List[float]]:
    """批量嵌入，自动分批次"""
    all_embeddings = []
    
    for i in range(0, len(texts), self.batch_size):
        batch = texts[i:i + self.batch_size]
        
        for attempt in range(3):  # 重试 3 次
            try:
                response = self.client.embeddings.create(
                    model=self.model,
                    input=batch
                )
                all_embeddings.extend([d.embedding for d in response.data])
                break
            except RateLimitError:
                time.sleep(2 ** attempt)  # 指数退避
                
    return all_embeddings
```

---

## Phase 4: 依赖管理

### requirements.txt
```
openai>=1.0.0
pinecone-client>=3.0.0
python-dotenv>=1.0.0
tiktoken>=0.5.0
pydantic>=2.0.0
chardet>=5.0.0
```

---

## 实施步骤

1. **创建 pinecone_tool.py**（核心模块，~400 行）
2. **重构 search.py**（使用核心模块）
3. **创建 upload.py**（上传命令，~150 行）
4. **更新 SKILL.md**（添加上传功能说明）
5. **更新 requirements.txt**
6. **测试验证**

---

## 优势

| 方面 | 说明 |
|------|------|
| 文件数量 | 仅 6 个文件，符合 ClawHub 限制 |
| 代码组织 | 单文件内类模块化，维护性好 |
| 功能完整 | 保留所有大厂标准实践 |
| 易用性 | CLI 命令简洁直观 |
