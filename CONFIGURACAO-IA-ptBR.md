<file_path>
nixos/CONFIGURACAO-IA-ptBR.md
</file_path>

<edit_description>
Create Brazilian Portuguese version of AI tools setup guide
</edit_description>

# Guia de Configuração - Ferramentas de IA

Este guia explica como configurar e usar ferramentas de IA CLI (Claude, GPT/Codex, Grok) no seu sistema NixOS.

## Visão Geral

O instalador inclui um módulo opcional de Ferramentas de IA que fornece:
- **aichat** - Cliente universal de IA que suporta Claude, GPT, Gemini e muito mais
- Ambientes Python, Node.js e Rust para instalar ferramentas adicionais de IA
- Atalhos de shell pré-configurados para acesso rápido

## Início Rápido

### 1. Instalação

Se você selecionou "Ferramentas de IA" durante a instalação, o módulo já está configurado. Se não, você pode adicioná-lo manualmente:

Edite `hosts/SEU_HOSTNAME/configuration.nix`:
```nix
imports = [
  # ... outras importações
  ../../modules/ai-tools.nix
];
```

Então reconstrua:
```bash
sudo nixos-rebuild switch --flake .#SEU_HOSTNAME
```

### 2. Configure Chaves de API

Crie um arquivo para armazenar suas chaves de API (ex: `~/.config/chaves-ia.sh`):

```bash
# Anthropic (Claude)
export ANTHROPIC_API_KEY="sk-ant-sua-chave-aqui"

# OpenAI (GPT-4, Codex)
export OPENAI_API_KEY="sk-sua-chave-aqui"

# X.AI (Grok)
export XAI_API_KEY="xai-sua-chave-aqui"

# Google (Gemini)
export GEMINI_API_KEY="sua-chave-aqui"
```

Fonte-o em seu shell config (`~/.zshrc` ou `~/.bashrc`):
```bash
source ~/.config/chaves-ia.sh
```

**Nota de Segurança:** Certifique-se de proteger suas chaves:
```bash
chmod 600 ~/.config/chaves-ia.sh
```

### 3. Configure o aichat

Crie `~/.config/aichat/config.yaml`:

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

# Funções personalizadas
roles:
  - name: shell
    prompt: "Você é um especialista em shell scripting. Forneça comandos concisos."
    
  - name: code
    prompt: "Você é um programador especialista. Escreva código limpo e eficiente."
    
  - name: explain
    prompt: "Explique conceitos de forma clara e concisa."
```

## Ferramentas de IA Disponíveis

### 1. aichat (Recomendado)

**O que é:** Cliente universal de IA que suporta múltiplos provedores (Claude, GPT, Gemini, etc.)

**Instalação:** Já incluído no módulo de ferramentas de IA

**Uso:**
```bash
# Uso básico
aichat "O que é NixOS?"

# Usar modelo específico
aichat --model claude:claude-3-5-sonnet-20241022 "Explique flakes"
aichat --model openai:gpt-4 "Escreva código Python"

# Modo interativo
aichat

# Com função
aichat --role shell "Como encontrar arquivos grandes?"

# Streaming de resposta
aichat --stream "Explicação longa necessária"
```

**Configuração:**
- Arquivo de config: `~/.config/aichat/config.yaml`
- Defina modelo padrão, temperatura e funções personalizadas

### 2. Claude CLI (Oficial Anthropic)

**Instalação:**
```bash
# Via Python
pip install anthropic-cli

# Via npm (se disponível)
npm install -g @anthropic-ai/cli
```

**Uso:**
```bash
# Usando módulo Python
python -c "from anthropic import Anthropic; client = Anthropic(); print(client.messages.create(model='claude-3-5-sonnet-20241022', max_tokens=1024, messages=[{'role': 'user', 'content': 'Olá'}]))"

# Ou crie um script wrapper
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

**Uso direto da API:**
```bash
curl https://api.anthropic.com/v1/messages \
  -H "content-type: application/json" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "max_tokens": 1024,
    "messages": [{"role": "user", "content": "Olá, Claude"}]
  }'
```

### 3. OpenAI CLI (GPT-4, Codex)

**Instalação:**
```bash
npm install -g openai-cli
# ou
pip install openai
```

**Uso com openai-cli:**
```bash
openai "Explique computação quântica"
openai --model gpt-4 "Escreva uma função Python"
```

**Uso com Python:**
```bash
python << EOF
from openai import OpenAI
client = OpenAI()

response = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "Olá!"}]
)
print(response.choices[0].message.content)
EOF
```

### 4. Shell-GPT

**O que é:** Assistente de shell com tecnologia GPT

**Instalação:**
```bash
pip install shell-gpt
```

**Uso:**
```bash
# Fazer perguntas
sgpt "Qual é o significado da vida?"

# Comandos shell
sgpt --shell "Comando para encontrar arquivos"

# Geração de código
sgpt --code "Função Python para ordenar"

# Executar comandos diretamente (use com cuidado!)
sgpt --shell --execute "Mostrar uso de disco"
```

**Configuração:**
```bash
# Configure na primeira execução
sgpt --install

# Configure em ~/.config/shell_gpt/.sgptrc
```

### 5. Grok CLI (X.AI)

**Status:** CLI oficial pode não estar disponível publicamente ainda

**Alternativa - API direta:**
```bash
# Criar script wrapper
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

**Uso:**
```bash
grok "O que é Grok?"
```

### 6. GitHub Copilot CLI

**Instalação:**
```bash
npm install -g @githubnext/github-copilot-cli
```

**Autenticação:**
```bash
github-copilot-cli auth
```

**Uso:**
```bash
# Comandos shell
gh copilot suggest "encontrar arquivos grandes"

# Explicar comandos
gh copilot explain "tar -xzf file.tar.gz"
```

## Como Obter Chaves de API

### Anthropic (Claude)
1. Visite: https://console.anthropic.com/
2. Cadastre-se para uma conta
3. Vá para a seção API Keys
4. Crie uma nova chave API
5. Copie e salve com segurança

### OpenAI (GPT-4, Codex)
1. Visite: https://platform.openai.com/
2. Cadastre-se para uma conta
3. Vá para a seção API Keys
4. Crie uma nova chave API
5. Copie e salve com segurança

### X.AI (Grok)
1. Visite: https://x.ai/
2. Solicite acesso à API
3. Siga o processo de integração
4. Obtenha sua chave API

### Google (Gemini)
1. Visite: https://makersuite.google.com/app/apikey
2. Faça login com conta Google
3. Crie uma chave API
4. Copie e salve com segurança

## Melhores Práticas

### 1. Segurança

**Proteja suas chaves de API:**
```bash
# Armazene chaves em arquivo seguro
chmod 600 ~/.config/chaves-ia.sh

# Nunca commite chaves no git
echo ".config/chaves-ia.sh" >> ~/.gitignore

# Use variáveis de ambiente
export ANTHROPIC_API_KEY="$(pass show anthropic/api-key)"
```

### 2. Gerenciamento de Custos

**Monitore o uso:**
- Defina limites de gastos nos dashboards dos provedores
- Use modelos mais baratos para tarefas simples
- Armazene respostas em cache quando possível

**Seleção de modelo:**
- `claude-3-haiku`: Rápido e barato para tarefas simples
- `claude-3-sonnet`: Equilíbrio de performance
- `claude-3-opus`: Melhor qualidade, mais caro
- `gpt-3.5-turbo`: Rápido e barato
- `gpt-4`: Melhor qualidade, mais custo
- `gpt-4-turbo`: Boa qualidade, custo moderado

### 3. Prompting Eficiente

**Seja específico:**
```bash
# Ruim
aichat "código"

# Bom
aichat "Escreva uma função Python que calcula fatorial recursivamente com anotações de tipo"
```

**Forneça contexto:**
```bash
aichat "No NixOS, como adiciono um novo pacote à minha configuração?"
```

**Use funções:**
```bash
aichat --role code "Refatore esta função: $(cat meu_arquivo.py)"
```

### 4. Integração com Ferramentas

**Pipe comandos:**
```bash
# Explique saída de comandos
journalctl -xe | aichat "Explique estes logs de erro"

# Gere código a partir de requisitos
cat requirements.txt | aichat "Crie um script Python que use essas bibliotecas"

# Melhore documentação
cat README.md | aichat "Melhore esta documentação"
```

**Uso em scripts:**
```bash
#!/bin/bash
# commit-helper.sh

DIFF=$(git diff --cached)
MESSAGE=$(aichat "Mensagem de commit para: $DIFF")
echo "Sugestão: $MESSAGE"
read -p "Usar esta mensagem? (s/n) " -n 1 -r
if [[ $REPLY =~ ^[Ss]$ ]]; then
    git commit -m "$MESSAGE"
fi
```

## Solução de Problemas

### Chave de API Não Encontrada

**Problema:** `Erro: ANTHROPIC_API_KEY não definido`

**Solução:**
```bash
# Verifique se a chave está definida
echo $ANTHROPIC_API_KEY

# Fonte seu config
source ~/.config/chaves-ia.sh

# Ou exporte diretamente
export ANTHROPIC_API_KEY="sua-chave"
```

### Erros de Conexão

**Problema:** `Erro: Conexão recusada`

**Solução:**
```bash
# Verifique conexão com internet
ping api.anthropic.com

# Verifique se firewall bloqueia
sudo systemctl status firewall

# Tente com saída verbosa
aichat --debug "teste"
```

### Limitação de Taxa

**Problema:** `Erro: Limite de taxa excedido`

**Solução:**
- Aguarde alguns minutos antes de tentar novamente
- Verifique uso da API no dashboard do provedor
- Faça upgrade para nível superior se necessário
- Use backoff exponencial em scripts

### Chave de API Inválida

**Problema:** `Erro: Chave de API inválida`

**Solução:**
```bash
# Verifique se a chave está correta
echo $ANTHROPIC_API_KEY

# Verifique espaços ou quebras de linha extras
echo -n $ANTHROPIC_API_KEY | wc -c

# Regenere a chave no dashboard do provedor
```

## Uso Avançado

### Scripts Personalizados

Crie `~/.local/bin/ai-commit`:
```bash
#!/bin/bash
# Gerar mensagens de commit usando IA

STAGED_DIFF=$(git diff --cached)
if [ -z "$STAGED_DIFF" ]; then
    echo "Não há mudanças staged"
    exit 1
fi

echo "Gerando mensagem de commit..."
MESSAGE=$(aichat "Mensagem de commit seguindo conventional commits para: $STAGED_DIFF")
echo "Sugestão de commit:"
echo "$MESSAGE"
echo ""
read -p "Usar esta mensagem? (s/n/e) " choice

case "$choice" in
    s|S) git commit -m "$MESSAGE" ;;
    e|E) git commit -e -m "$MESSAGE" ;;
    *) echo "Cancelado" ;;
esac
```

### Comparação Multi-Provedor

```bash
#!/bin/bash
# comparar-ia.sh - Comparar respostas de diferentes modelos

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

### Assistente de Revisão de Código

```bash
#!/bin/bash
# revisar.sh - Revisão de código com IA

FILE="$1"
aichat --role code "Revise este código em busca de bugs, problemas de performance e melhores práticas: $(cat $FILE)"
```

## Recursos

- **Documentação do aichat:** https://github.com/sigoden/aichat
- **Documentação da API Anthropic:** https://docs.anthropic.com/
- **Documentação da API OpenAI:** https://platform.openai.com/docs/
- **Documentação da X.AI:** https://x.ai/api
- **Shell-GPT:** https://github.com/TheR1D/shell_gpt

## Contribuição

Encontrou uma ferramenta de IA útil ou configuração? Considere adicioná-la ao módulo ou compartilhá-la com a comunidade!

---

**Última atualização:** 2024
**Compatibilidade:** NixOS 24.05+, canal unstable