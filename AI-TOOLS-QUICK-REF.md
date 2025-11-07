# AI CLI Tools - Quick Reference

## Installation

```bash
# Enable AI tools module in configuration.nix
imports = [ ../../modules/ai-tools.nix ];

# Rebuild system
sudo nixos-rebuild switch --flake .#HOSTNAME
```

## Setup API Keys

```bash
# Create config file
nano ~/.config/ai-keys.sh

# Add your keys
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export XAI_API_KEY="xai-..."

# Source in ~/.zshrc or ~/.bashrc
source ~/.config/ai-keys.sh

# Protect the file
chmod 600 ~/.config/ai-keys.sh
```

## Quick Commands

### aichat (Multi-Provider)

```bash
# Basic usage
aichat "What is NixOS?"

# Interactive mode
aichat

# Specific model
aichat --model claude:claude-3-5-sonnet-20241022 "Explain flakes"
aichat --model openai:gpt-4 "Write Python code"
aichat --model gemini:gemini-pro "Explain quantum computing"

# With role
aichat --role code "Review this code: $(cat file.py)"
aichat --role shell "Find large files"

# Stream output
aichat --stream "Long explanation needed"
```

### Shell Aliases (if configured)

```bash
ai "Quick question"              # Default model
claude "Use Claude specifically" # Claude 3.5 Sonnet
gpt "Use GPT-4"                  # GPT-4
```

### Claude (Direct API)

```bash
curl https://api.anthropic.com/v1/messages \
  -H "content-type: application/json" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -d '{"model": "claude-3-5-sonnet-20241022", 
       "max_tokens": 1024, 
       "messages": [{"role": "user", "content": "Hello"}]}'
```

### OpenAI (Direct API)

```bash
curl https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{"model": "gpt-4",
       "messages": [{"role": "user", "content": "Hello"}]}'
```

### Shell-GPT

```bash
# Install
pip install shell-gpt

# Usage
sgpt "Explain this concept"
sgpt --shell "Command to find files"
sgpt --code "Python function to sort"
sgpt --shell --execute "Show disk usage"  # Execute directly
```

## Common Use Cases

### Code Review
```bash
aichat --role code "Review: $(cat script.sh)"
```

### Commit Messages
```bash
git diff --cached | aichat "Generate commit message"
```

### Command Explanation
```bash
aichat "Explain: tar -xzf file.tar.gz"
```

### Error Debugging
```bash
journalctl -xe | tail -n 50 | aichat "Explain these errors"
```

### Documentation
```bash
cat README.md | aichat "Improve this documentation"
```

### Code Generation
```bash
aichat "Write a Python script to parse JSON and extract emails"
```

## Configuration

### aichat config (~/.config/aichat/config.yaml)

```yaml
model: claude:claude-3-5-sonnet-20241022
temperature: 1.0

clients:
  - type: claude
    api_key: $ANTHROPIC_API_KEY
  - type: openai
    api_key: $OPENAI_API_KEY
  - type: gemini
    api_key: $GEMINI_API_KEY

roles:
  - name: shell
    prompt: "Shell scripting expert. Provide concise commands."
  - name: code
    prompt: "Expert programmer. Write clean, efficient code."
  - name: review
    prompt: "Code reviewer. Find bugs and suggest improvements."
```

## Model Comparison

| Model | Provider | Speed | Quality | Cost |
|-------|----------|-------|---------|------|
| claude-3-haiku | Anthropic | ⚡⚡⚡ | ⭐⭐ | 💲 |
| claude-3-sonnet | Anthropic | ⚡⚡ | ⭐⭐⭐ | 💲💲 |
| claude-3-opus | Anthropic | ⚡ | ⭐⭐⭐⭐ | 💲💲💲 |
| gpt-3.5-turbo | OpenAI | ⚡⚡⚡ | ⭐⭐ | 💲 |
| gpt-4 | OpenAI | ⚡⚡ | ⭐⭐⭐⭐ | 💲💲💲 |
| gpt-4-turbo | OpenAI | ⚡⚡ | ⭐⭐⭐⭐ | 💲💲 |
| gemini-pro | Google | ⚡⚡⚡ | ⭐⭐⭐ | 💲 |

## Useful Scripts

### AI Commit Helper
```bash
#!/bin/bash
# ~/.local/bin/ai-commit
DIFF=$(git diff --cached)
MSG=$(aichat "Commit message for: $DIFF")
echo "Suggested: $MSG"
read -p "Use? (y/n) " -n 1 -r
[[ $REPLY =~ ^[Yy]$ ]] && git commit -m "$MSG"
```

### Code Explainer
```bash
#!/bin/bash
# ~/.local/bin/explain
aichat "Explain this code: $(cat $1)"
```

### Error Helper
```bash
#!/bin/bash
# ~/.local/bin/fix-error
ERROR="$1"
aichat "How to fix this error: $ERROR"
```

## Troubleshooting

### Check API Key
```bash
echo $ANTHROPIC_API_KEY
source ~/.config/ai-keys.sh
```

### Test Connection
```bash
aichat "test"
curl -I https://api.anthropic.com
```

### Debug Mode
```bash
aichat --debug "test query"
```

### Rate Limiting
- Wait a few minutes
- Check usage dashboard
- Use cheaper models

## Tips

✅ **DO:**
- Use specific prompts
- Provide context
- Use roles for better results
- Monitor API usage
- Protect API keys (chmod 600)
- Use cheaper models for simple tasks

❌ **DON'T:**
- Commit API keys to git
- Share API keys
- Use expensive models for simple queries
- Execute AI-generated commands without review
- Store keys in plain text in public repos

## Getting Help

```bash
# aichat help
aichat --help

# List models
aichat --list-models

# List roles
aichat --list-roles

# Show config
cat ~/.config/aichat/config.yaml
```

## Resources

- **Get API Keys:**
  - Claude: https://console.anthropic.com/
  - OpenAI: https://platform.openai.com/
  - Grok: https://x.ai/

- **Documentation:**
  - aichat: https://github.com/sigoden/aichat
  - Anthropic: https://docs.anthropic.com/
  - OpenAI: https://platform.openai.com/docs/

- **Full Guide:** See AI-TOOLS-SETUP.md

---

**Quick Start:** Install → Set API Keys → `aichat "Hello"` → Done! 🚀