# AI CLI Tools Setup Guide

This guide explains how to set up and use AI CLI tools (Claude, GPT/Codex, Grok) on your NixOS system.

## Overview

The installer includes an optional AI Tools module that provides:
- **aichat** - Multi-provider AI CLI (supports Claude, GPT, Gemini, and more)
- Python, Node.js, and Rust environments for installing additional AI tools
- Pre-configured shell aliases for quick access

## Quick Start

### 1. Installation

If you selected "AI Tools" during installation, the module is already configured. If not, you can add it manually:

Edit `hosts/YOUR_HOSTNAME/configuration.nix`:
```nix
imports = [
  # ... other imports
  ../../modules/ai-tools.nix
];
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME
```

### 2. Set Up API Keys

Create a file to store your API keys (e.g., `~/.config/ai-keys.sh`):

```bash
# Anthropic (Claude)
export ANTHROPIC_API_KEY="sk-ant-your-key-here"

# OpenAI (GPT-4, Codex)
export OPENAI_API_KEY="sk-your-key-here"

# X.AI (Grok)
export XAI_API_KEY="xai-your-key-here"

# Google (Gemini)
export GEMINI_API_KEY="your-key-here"
```

Source it in your shell config (`~/.zshrc` or `~/.bashrc`):
```bash
source ~/.config/ai-keys.sh
```

**Security Note:** Make sure to protect your keys:
```bash
chmod 600 ~/.config/ai-keys.sh
```

### 3. Configure aichat

Create `~/.config/aichat/config.yaml`:

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

# Custom roles
roles:
  - name: shell
    prompt: "You are a shell scripting expert. Provide concise commands."
    
  - name: code
    prompt: "You are an expert programmer. Write clean, efficient code."
    
  - name: explain
    prompt: "Explain concepts clearly and concisely."
```

## Available AI Tools

### 1. aichat (Recommended)

**What it is:** Universal AI CLI that supports multiple providers (Claude, GPT, Gemini, etc.)

**Installation:** Already included in the AI tools module

**Usage:**
```bash
# Basic chat
aichat "What is NixOS?"

# Use specific model
aichat --model claude:claude-3-5-sonnet-20241022 "Explain flakes"
aichat --model openai:gpt-4 "Write a Python script"

# Interactive mode
aichat

# With role
aichat --role shell "How to find large files?"

# Stream response
aichat --stream "Explain Nix language"

# Using shell aliases (if configured)
ai "What is the weather?"
claude "Explain functional programming"
gpt "Write a bash script"
```

**Configuration:**
- Config file: `~/.config/aichat/config.yaml`
- Set default model, temperature, and custom roles

### 2. Claude CLI (Official Anthropic)

**Installation:**
```bash
# Via Python
pip install anthropic

# Via npm (if available)
npm install -g @anthropic-ai/cli
```

**Usage:**
```bash
# Using Python module
python -c "from anthropic import Anthropic; client = Anthropic(); print(client.messages.create(model='claude-3-5-sonnet-20241022', max_tokens=1024, messages=[{'role': 'user', 'content': 'Hello'}]))"

# Or create a wrapper script
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

**Direct API Usage:**
```bash
curl https://api.anthropic.com/v1/messages \
  -H "content-type: application/json" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 1024,
    "messages": [{"role": "user", "content": "Hello, Claude"}]
  }'
```

### 3. OpenAI CLI (GPT-4, Codex)

**Installation:**
```bash
npm install -g openai-cli
# or
pip install openai
```

**Usage with openai-cli:**
```bash
openai "Explain quantum computing"
openai --model gpt-4 "Write a Python function"
```

**Usage with Python:**
```bash
python << EOF
from openai import OpenAI
client = OpenAI()

response = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "Hello!"}]
)
print(response.choices[0].message.content)
EOF
```

### 4. Shell-GPT

**What it is:** GPT-powered shell assistant

**Installation:**
```bash
pip install shell-gpt
```

**Usage:**
```bash
# Ask questions
sgpt "What is the meaning of life?"

# Shell commands
sgpt --shell "Find all files larger than 1GB"

# Code generation
sgpt --code "Python function to sort a list"

# Execute commands directly (use with caution!)
sgpt --shell --execute "Show disk usage"
```

**Configuration:**
```bash
# Set up on first run
sgpt --install

# Configure in ~/.config/shell_gpt/.sgptrc
```

### 5. Grok CLI (X.AI)

**Status:** Official CLI may not be publicly available yet

**Alternative - Direct API:**
```bash
# Create wrapper script
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

**Usage:**
```bash
grok "What is Grok?"
```

### 6. GitHub Copilot CLI

**Installation:**
```bash
npm install -g @githubnext/github-copilot-cli
```

**Authentication:**
```bash
github-copilot-cli auth
```

**Usage:**
```bash
# Shell commands
gh copilot suggest "find large files"

# Explain commands
gh copilot explain "tar -xzf file.tar.gz"
```

## Getting API Keys

### Anthropic (Claude)
1. Visit: https://console.anthropic.com/
2. Sign up for an account
3. Go to API Keys section
4. Create a new API key
5. Copy and save it securely

### OpenAI (GPT-4, Codex)
1. Visit: https://platform.openai.com/
2. Sign up for an account
3. Go to API Keys section
4. Create a new API key
5. Copy and save it securely

### X.AI (Grok)
1. Visit: https://x.ai/
2. Request API access
3. Follow their onboarding process
4. Get your API key

### Google (Gemini)
1. Visit: https://makersuite.google.com/app/apikey
2. Sign in with Google account
3. Create an API key
4. Copy and save it securely

## Best Practices

### 1. Security

**Protect your API keys:**
```bash
# Store keys in a secure file
chmod 600 ~/.config/ai-keys.sh

# Never commit keys to git
echo ".config/ai-keys.sh" >> ~/.gitignore

# Use environment variables
export ANTHROPIC_API_KEY="$(pass show anthropic/api-key)"
```

### 2. Cost Management

**Monitor usage:**
- Set spending limits in provider dashboards
- Use cheaper models for simple tasks
- Cache responses when possible

**Model selection:**
- `claude-3-haiku`: Fast and cheap for simple tasks
- `claude-3-sonnet`: Balanced performance
- `claude-3-opus`: Best quality, most expensive
- `gpt-3.5-turbo`: Fast and cheap
- `gpt-4`: Better quality, higher cost

### 3. Effective Prompting

**Be specific:**
```bash
# Bad
aichat "code"

# Good
aichat "Write a Python function that calculates factorial recursively with type hints"
```

**Provide context:**
```bash
aichat "In NixOS, how do I add a new package to my configuration?"
```

**Use roles:**
```bash
aichat --role code "Refactor this function: $(cat myfile.py)"
```

### 4. Integration with Tools

**Pipe commands:**
```bash
# Explain command output
journalctl -xe | aichat "Explain these error logs"

# Generate code from requirements
cat requirements.txt | aichat "Create a Python script that uses these libraries"

# Improve documentation
cat README.md | aichat "Improve this documentation"
```

**Use in scripts:**
```bash
#!/bin/bash
# commit-helper.sh

DIFF=$(git diff --cached)
MESSAGE=$(aichat "Generate a concise git commit message for: $DIFF")
echo "Suggested commit message: $MESSAGE"
read -p "Use this message? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git commit -m "$MESSAGE"
fi
```

## Troubleshooting

### API Key Not Found

**Problem:** `Error: ANTHROPIC_API_KEY not set`

**Solution:**
```bash
# Check if key is set
echo $ANTHROPIC_API_KEY

# Source your config
source ~/.config/ai-keys.sh

# Or export directly
export ANTHROPIC_API_KEY="your-key"
```

### Connection Errors

**Problem:** `Error: Connection refused`

**Solution:**
```bash
# Check internet connection
ping api.anthropic.com

# Check if firewall is blocking
sudo systemctl status firewall

# Try with verbose output
aichat --debug "test"
```

### Rate Limiting

**Problem:** `Error: Rate limit exceeded`

**Solution:**
- Wait a few minutes before retrying
- Check your API usage in provider dashboard
- Upgrade to higher tier if needed
- Use exponential backoff in scripts

### Invalid API Key

**Problem:** `Error: Invalid API key`

**Solution:**
```bash
# Verify key is correct
echo $ANTHROPIC_API_KEY

# Check for extra spaces or newlines
echo -n $ANTHROPIC_API_KEY | wc -c

# Regenerate key from provider dashboard
```

## Advanced Usage

### Custom Scripts

Create `~/.local/bin/ai-commit`:
```bash
#!/bin/bash
# Generate git commit messages using AI

STAGED_DIFF=$(git diff --cached)
if [ -z "$STAGED_DIFF" ]; then
    echo "No staged changes"
    exit 1
fi

echo "Generating commit message..."
MESSAGE=$(aichat "Generate a conventional commit message for these changes. Be concise and follow format 'type(scope): description'. Changes: $STAGED_DIFF")

echo "Suggested commit:"
echo "$MESSAGE"
echo ""
read -p "Use this message? (y/n/e) " choice

case "$choice" in
    y|Y) git commit -m "$MESSAGE" ;;
    e|E) git commit -e -m "$MESSAGE" ;;
    *) echo "Cancelled" ;;
esac
```

### Multi-Provider Comparison

```bash
#!/bin/bash
# compare-ai.sh - Compare responses from different models

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

### Code Review Assistant

```bash
#!/bin/bash
# review.sh - AI-powered code review

FILE="$1"
aichat --role code "Review this code for bugs, performance issues, and best practices: $(cat $FILE)"
```

## Resources

- **aichat documentation:** https://github.com/sigoden/aichat
- **Anthropic API docs:** https://docs.anthropic.com/
- **OpenAI API docs:** https://platform.openai.com/docs/
- **X.AI documentation:** https://x.ai/api
- **Shell-GPT:** https://github.com/TheR1D/shell_gpt

## Contributing

Found a useful AI tool or configuration? Consider adding it to the module or sharing it with the community!

---

**Last Updated:** 2024  
**Compatible with:** NixOS 24.05+, Unstable channel