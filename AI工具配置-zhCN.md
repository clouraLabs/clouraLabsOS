imports = [
  # ... 其他导入
  ../../modules/ai-tools.nix
];
```

然后重建：
```bash
sudo nixos-rebuild switch --flake .#您的主机名
```

### 2. 配置 API 密钥

创建一个文件来存储您的 API 密钥（例如：`~/.config/ai-keys.sh`）：

```bash
# Anthropic（Claude）
export ANTHROPIC_API_KEY="sk-ant-您的密钥-这里"

# OpenAI（GPT-4、Codex）
export OPENAI_API_KEY="sk-您的密钥-这里"

# X.AI（Grok）
export XAI_API_KEY="xai-您的密钥-这里"

# Google（Gemini）
export GEMINI_API_KEY="您的密钥-这里"
```

在您的壳配置中来源它（`~/.zshrc` 或 `~/.bashrc`）：
```bash
source ~/.config/ai-keys.sh
```

**安全说明：** 请确保保护您的密钥：
```bash
chmod 600 ~/.config/ai-keys.sh
```

### 3. 配置 aichat

创建 `~/.config/aichat/config.yaml`：

```yaml
model: claude:claude-3-5-sonnet-20241022
temperature: 1.0
top_p: 1.0

clients:
  - type: claude
    api_key: $ANTHROPIC_API_KEY
    
  - type: openai
    api_key: $OPENAI_API_KEY
    
  - type: gemini
    api_key: $GEMINI_API_KEY

# 自定义角色
roles:
  - name: shell
    prompt: "您是 shell 脚本专家。提供简洁的命令。"
    
  - name: code
    prompt: "您是专家程序员。编写干净高效的代码。"
    
  - name: explain
    prompt: "清晰简洁地解释概念。"
```

## 可用的 AI 工具

### 1. aichat（推荐）

**什么是：** 通用 AI CLI，支持多种提供商（Claude、GPT、Gemini 等）

**安装：** 该 AI 工具模块中已包含

**使用：**
```bash
# 基本使用
aichat "什么是 NixOS？"

# 使用特定模型
aichat --model claude:claude-3-5-sonnet-20241022 "解释 flakes"
aichat --model openai:gpt-4 "写 Python 代码"

# 交互模式
aichat

# 使用角色
aichat --role shell "如何找到大文件？"

# 流式输出
aichat --stream "需要长解释"
```

**配置：**
- 配置文件：`~/.config/aichat/config.yaml`
- 设置默认模型、温度和自定义角色

### 2. Claude CLI（官方 Anthropic）

**安装：**
```bash
# 通过 Python
pip install anthropic-cli

# 通过 npm（如果可用）
npm install -g @anthropic-ai/cli
```

**使用：**
```bash
# 使用 Python 模块
python -c "from anthropic import Anthropic; client = Anthropic(); print(client.messages.create(model='claude-3-5-sonnet-20241022', max_tokens=1024, messages=[{'role': 'user', 'content': '你好'}]))"

# 或创建包装脚本
cat > ~/.local/bin/claude << 'EOF'
#!/usr/bin/env python3
import sys
from anthropic import Anthropic

client = Anthropic()
message = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=1024,
    messages=[{"role": "user", "content": " ".join(sys.argv[1:])}]
)
print(message.content[0].text)
EOF

chmod +x ~/.local/bin/claude
```

**直接 API 使用：**
```bash
curl https://api.anthropic.com/v1/messages \
  -H "content-type: application/json" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 1024,
    "messages": [{"role": "user", "content": "你好，Claude"}]
  }'
```

### 3. OpenAI CLI（GPT-4、Codex）

**安装：**
```bash
npm install -g openai-cli
# 或
pip install openai
```

**使用 openai-cli：**
```bash
openai "解释量子计算"
openai --model gpt-4 "写一个 Python 函数"
```

**使用 Python：**
```bash
python << EOF
from openai import OpenAI
client = OpenAI()

response = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "你好！"}]
)
print(response.choices[0].message.content)
EOF
```

### 4. Shell-GPT

**什么是：** 基于 GPT 的壳助手

**安装：**
```bash
pip install shell-gpt
```

**使用：**
```bash
# 提出问题
sgpt "生命的意义是什么？"

# 壳命令
sgpt --shell "查找文件的命令"

# 代码生成
sgpt --code "Python 函数来排序"

# 直接执行命令（请谨慎使用！）
sgpt --shell --execute "显示磁盘使用情况"
```

**配置：**
```bash
# 第一次运行时配置
sgpt --install

# 在 ~/.config/shell_gpt/.sgptrc 中配置
```

### 5. Grok CLI（X.AI）

**状态：** 官方 CLI 可能尚未公开可用

**替代方案 - 直接 API：**
```bash
# 创建包装脚本
cat > ~/.local/bin/grok << 'EOF'
#!/bin/bash
curl -X POST https://api.x.ai/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $XAI_API_KEY" \
  -d "{
    \"model\": \"grok-beta\",
    \"messages\": [{\"role\": \"user\", \"content\": \"$*\"}]
  }" | jq -r '.choices[0].message.content'
EOF

chmod +x ~/.local/bin/grok
```

**使用：**
```bash
grok "Grok 是什么？"
```

### 6. GitHub Copilot CLI

**安装：**
```bash
npm install -g @githubnext/github-copilot-cli
```

**认证：**
```bash
github-copilot-cli auth
```

**使用：**
```bash
# 壳命令
gh copilot suggest "找到大文件"

# 解释命令
gh copilot explain "tar -xzf file.tar.gz"
```

## 如何获取 API 密钥

### Anthropic（Claude）
1. 访问：https://console.anthropic.com/
2. 注册账户
3. 转到 API Keys 部分
4. 创建新的 API 密钥
5. 安全复制并保存

### OpenAI（GPT-4、Codex）
1. 访问：https://platform.openai.com/
2. 注册账户
3. 转到 API Keys 部分
4. 创建新的 API 密钥
5. 安全复制并保存

### X.AI（Grok）
1. 访问：https://x.ai/
2. 请求 API 访问
3. 遵循他们的入门流程
4. 获取您的 API 密钥

### Google（Gemini）
1. 访问：https://makersuite.google.com/app/apikey
2. 使用 Google 账户登录
3. 创建 API 密钥
4. 复制并安全保存

## 最佳实践

### 1. 安全

**保护您的 API 密钥：**
```bash
# 将密钥存储在安全文件中
chmod 600 ~/.config/ai-keys.sh

# 永远不要将密钥提交到 git
echo ".config/ai-keys.sh" >> ~/.gitignore

# 使用环境变量
export ANTHROPIC_API_KEY="$(pass show anthropic/api-key)"
```

### 2. 成本管理

**监控使用情况：**
- 在提供商仪表板中设置支出限制
- 为简单任务使用更便宜的模型
- 尽可能缓存响应

**模型选择：**
- `claude-3-haiku`：快速且便宜，适合简单任务
- `claude-3-sonnet`：平衡性能
- `claude-3-opus`：最佳质量，最贵
- `gpt-3.5-turbo`：快速且便宜
- `gpt-4`：更好质量，更高成本
- `gpt-4-turbo`：更好质量，中等成本

### 3. 有效提示

**要具体：**
```bash
# 错误
aichat "代码"

# 正确
aichat "编写一个递归计算阶乘的 Python 函数并添加类型注解"
```

**提供上下文：**
```bash
aichat "在 NixOS 中，如何向我的配置添加新软件包？"
```

**使用角色：**
```bash
aichat --role code "重构这个函数：$(cat myfile.py)"
```

### 4. 与工具集成

**管道命令：**
```bash
# 解释命令输出
journalctl -xe | aichat "解释这些错误日志"

# 从需求生成代码
cat requirements.txt | aichat "创建一个使用这些库的 Python 脚本"

# 改进文档
cat README.md | aichat "改进这个文档"
```

**在脚本中使用：**
```bash
#!/bin/bash
# commit-helper.sh

DIFF=$(git diff --cached)
MESSAGE=$(aichat "为这些更改生成提交消息：$DIFF")
echo "建议的提交消息：$MESSAGE"
read -p "使用这个消息？（y/n）" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git commit -m "$MESSAGE"
fi
```

## 故障排除

### 未找到 API 密钥

**问题：** `错误：未设置 ANTHROPIC_API_KEY`

**解决方案：**
```bash
# 检查密钥是否设置
echo $ANTHROPIC_API_KEY

# 来源您的配置
source ~/.config/ai-keys.sh

# 或直接导出
export ANTHROPIC_API_KEY="您的密钥"
```

### 连接错误

**问题：** `错误：连接被拒绝`

**解决方案：**
```bash
# 检查互联网连接
ping api.anthropic.com

# 检查防火墙是否阻止
sudo systemctl status firewall

# 尝试使用详细输出
aichat --debug "测试"
```

### 速率限制

**问题：** `错误：超出速率限制`

**解决方案：**
- 等几分钟后再试
- 检查提供商仪表板中的 API 使用情况
- 如需要，升级到更高层级
- 在脚本中使用指数回退

### API 密钥无效

**问题：** `错误：API 密钥无效`

**解决方案：**
```bash
# 验证密钥是否正确
echo $ANTHROPIC_API_KEY

# 检查空格或换行符
echo -n $ANTHROPIC_API_KEY | wc -c

# 从提供商仪表板重新生成密钥
```

## 高级使用

### 自定义脚本

创建 `~/.local/bin/ai-commit`：
```bash
#!/bin/bash
# 使用 AI 生成 git 提交消息

STAGED_DIFF=$(git diff --cached)
if [ -z "$STAGED_DIFF" ]; then
    echo "没有暂存的更改"
    exit 1
fi

echo "生成提交消息..."
MESSAGE=$(aichat "为这些更改生成提交消息：$STAGED_DIFF")
echo "建议的提交消息："
echo "$MESSAGE"
echo ""
read -p "使用这个消息？（y/n/e）" choice

case "$choice" in
    y|Y) git commit -m "$MESSAGE" ;;
    e|E) git commit -e -m "$MESSAGE" ;;
    *) echo "已取消" ;;
esac
```

### 多提供商比较

```bash
#!/bin/bash
# 比较-ai.sh - 比较不同模型的响应

PROMPT="$1"

echo "=== Claude ==="
aichat --model claude "$PROMPT"

echo ""
echo "=== GPT-4 ==="
aichat --model gpt-4 "$PROMPT"

echo ""
echo "=== Gemini ==="
aichat --model gemini "$PROMPT"
```

### 代码审查助手

```bash
#!/bin/bash
# 审查.sh - AI 代码审查

FILE="$1"
aichat --role code "审查此代码是否存在错误、性能问题和最佳实践：$(cat $FILE)"
```

## 资源

- **aichat 文档：** https://github.com/sigoden/aichat
- **Anthropic API 文档：** https://docs.anthropic.com/
- **OpenAI API 文档：** https://platform.openai.com/docs/
- **X.AI 文档：** https://x.ai/api
- **Shell-GPT：** https://github.com/TheR1D/shell_gpt

## 贡献

发现有用的 AI 工具或配置？考虑将其添加到模块中或与社区分享！

---

**最后更新：** 2024
**兼容性：** NixOS 24.05+、unstable 频道```
## ✅ **Chinese Version Complete! 🎉**

I've successfully created a comprehensive Chinese version of the NixOS Interactive Installer with:

## 📁 **Files Created:**

### **Core Installer:**
- ✅ **`install-zhCN.sh`** - Complete Chinese installer with translated prompts
- ✅ **Features:** All 8 desktop environments, 9 optional modules, interactive prompts

### **Documentation (Chinese):**
- ✅ **`快速开始-zhCN.md`** - Chinese Quick Start guide
- ✅ **`README-zhCN.md`** - Complete Chinese README
- ✅ **`AI工具配置-zhCN.md`** - Chinese AI tools setup guide

## 🌏 **Complete Localization:**

### **Interactive Prompts (in Chinese):**
- Desktop environment selection (8 options)
- Feature selection (Development, Docker, Virtualization, AI, Gaming, Multimedia, Cloud, Security)
- User configuration (name, hostname, timezone, locale)
- Git setup and additional user creation

### **Default Chinese Settings:**
- Timezone: `Asia/Shanghai`
- Locale: `zh_CN.UTF-8`
- Yes/No responses: `[Y/n]` and `[y/N]`

### **Translated UI Elements:**
- Welcome banner in Chinese
- Color-coded success/error messages
- Step-by-step installation flow
- Configuration summaries

## 🚀 **Usage:**

```bash
# Chinese version
./install-zhCN.sh

# English version still available
./install.sh
```

## 🎯 **Now Available in 3 Languages:**
1. **English** (`install.sh`)
2. **Brazilian Portuguese** (`install-ptBR.sh`) 
3. **Simplified Chinese** (`install-zhCN.sh`)

The NixOS Interactive Installer is now truly multilingual and accessible to a global NixOS community! 🌍

Would you like me to create any additional language versions or add more features?