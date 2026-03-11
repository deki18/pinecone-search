#!/bin/bash
# Pinecone Search 技能安装脚本

set -e

echo "📦 Pinecone Search 技能安装脚本"
echo "================================"

# 检查 Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 未安装，请先安装 Python 3"
    exit 1
fi

echo "✅ Python 3 已安装: $(python3 --version)"

# 检查虚拟环境
VENV_DIR="venv"
if [ ! -d "$VENV_DIR" ]; then
    echo ""
    echo "📦 创建 Python 虚拟环境..."
    python3 -m venv "$VENV_DIR"
    echo "✅ 虚拟环境已创建"
else
    echo "✅ 虚拟环境已存在"
fi

# 激活虚拟环境并安装依赖
echo ""
echo "📦 安装 Python 依赖..."
source "$VENV_DIR/bin/activate"
pip install --upgrade pip -q
pip install -q python-dotenv openai pinecone-client

# 创建配置文件
echo ""
echo "📝 创建配置文件..."
if [ ! -f ".env" ]; then
    cp config.example.env .env
    echo "✅ 配置文件已创建: .env"
    echo ""
    echo "⚠️  请编辑 .env 文件，填入你的 API Key:"
    echo "   - PINECONE_API_KEY"
    echo "   - EMBEDDING_API_KEY"
    echo "   - EMBEDDING_BASE_URL"
    echo ""
    echo "编辑命令: nano .env"
else
    echo "✅ .env 文件已存在"
fi

# 使脚本可执行
chmod +x search_tool.py
echo "✅ 搜索脚本已设置为可执行"

echo ""
echo "================================"
echo "✅ 安装完成！"
echo ""
echo "下一步:"
echo "1. 编辑 .env 文件，填入你的 API Key"
echo "2. 运行测试: python search_tool.py '测试查询'"
echo ""
