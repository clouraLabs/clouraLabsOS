# Instalador Interativo do NixOS

[![NixOS](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Uma ferramenta completa e interativa para gerar configurações do NixOS baseadas em flakes, com suporte a múltiplos ambientes de desktop, ferramentas de desenvolvimento, jogos, IA, multimídia, nuvem e segurança.

## ✨ Recursos

### 🎨 Ambientes de Desktop
- **8 opções**: GNOME, KDE Plasma, XFCE, Cinnamon, MATE, i3, Hyprland ou Nenhum (servidor)
- Configurações otimizadas para cada ambiente

### 🛠️ Ferramentas de Desenvolvimento
- Editores: vim, neovim, VSCodium, Zed
- Linguagens: Python, Node.js, Rust, Go
- Controle de versão: Git, GitHub CLI
- Ferramentas: tmux, ripgrep, fzf, direnv

### 🤖 Inteligência Artificial
- **aichat**: Cliente universal para Claude, GPT, Gemini
- Atalhos de shell (`ai`, `claude`, `gpt`)
- Suporte a múltiplos provedores

### 🎮 Jogos
- Steam com Proton
- Lutris e Heroic Launcher
- Otimizações de performance (GameMode, MangoHud)
- Suporte Vulkan e controladores

### 🎨 Multimídia
- Edição de vídeo: Kdenlive, OBS Studio
- Edição de imagem: GIMP, Krita, Blender
- Produção de áudio: Audacity, Ardour

### ☁️ Nuvem
- AWS CLI, Azure CLI, Google Cloud SDK
- Kubernetes (kubectl, Helm, k9s)
- Terraform e Ansible

### 🔒 Segurança
- Firewall, AppArmor, fail2ban
- SSH hardening
- Antivírus (ClamAV)

## 🚀 Instalação

### Pré-requisitos

- Sistema NixOS (ou ambiente live)
- Bash shell
- Privilégios sudo
- Conexão com internet

### Instalação Rápida

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/nixos.git
   cd nixos
   ```

2. **Execute o instalador:**
   ```bash
   ./install.sh
   ```

3. **Responda aos prompts interativos:**
   - Escolha seu desktop
   - Selecione recursos desejados
   - Configure usuários adicionais

4. **Ative a configuração:**
   ```bash
   sudo nixos-rebuild switch --flake .#seu-hostname
   ```

## 📋 Estrutura de Arquivos

```
nixos/
├── install.sh                      # Instalador principal
├── install-ptBR.sh                 # Versão em português brasileiro
├── flake.nix                       # Configuração de flakes (gerado)
├── hosts/                          # Configurações específicas do host
│   └── hostname/
│       ├── configuration.nix       # Config principal
│       └── hardware-configuration.nix
├── modules/                        # Módulos reutilizáveis
│   ├── system.nix                  # Sistema base
│   ├── desktop-gnome.nix           # Ambiente GNOME
│   ├── development.nix             # Ferramentas dev
│   └── ...
├── users/                          # Configurações de usuários
│   └── username/
│       └── home.nix                # Home Manager
├── docs/                           # Documentação
├── QUICKSTART.md                   # Início rápido
├── FEATURES.md                     # Recursos detalhados
├── AI-TOOLS-SETUP.md              # Configuração de IA
├── CHANGELOG.md                    # Histórico de mudanças
└── README.md                       # Este arquivo
```

## 🎯 Casos de Uso

### Estação de Desenvolvimento
```bash
# Escolhas: GNOME + Dev tools + Docker + AI + Cloud
Desktop: GNOME
✓ Ferramentas de desenvolvimento
✓ Docker  
✓ Ferramentas de IA
✓ CLIs de nuvem
```

### PC Gamer
```bash
# Escolhas: KDE Plasma + Jogos + Multimídia
Desktop: KDE Plasma
✓ Ferramentas de jogos
✓ Produção multimídia
✓ Ferramentas de desenvolvimento
```

### Servidor
```bash
# Escolhas: Nenhum + Docker + Segurança + Nuvem
Desktop: Nenhum
✓ Docker
✓ CLIs de nuvem
✓ Segurança reforçada
```

## 🛠️ Comandos Úteis

```bash
# Construir e ativar
make switch
# ou
sudo nixos-rebuild switch --flake .#hostname

# Testar sem persistir
make test
# ou  
sudo nixos-rebuild test --flake .#hostname

# Atualizar pacotes
make upgrade
# ou
nix flake update && sudo nixos-rebuild switch --flake .#hostname

# Limpar gerações antigas
make clean
# ou
sudo nix-collect-garbage -d

# Verificar configuração
make check
# ou
nix flake check
```

## 🔧 Personalização

### Adicionar Pacotes do Sistema

Edite `hosts/hostname/configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  vim
  wget
  # seus pacotes aqui
  firefox
  thunderbird
];
```

### Adicionar Pacotes do Usuário

Edite `users/username/home.nix`:
```nix
home.packages = with pkgs; [
  # seus pacotes aqui
  discord
  spotify
];
```

### Criar Novos Módulos

Crie `modules/custom.nix`:
```nix
{ config, pkgs, ... }:

{
  # sua configuração customizada aqui
}
```

Então importe em `configuration.nix`.

## 🐛 Solução de Problemas

### Erro "flake not found"
```bash
cd /caminho/da/sua/config
sudo nixos-rebuild switch --flake .#hostname
```

### Erro de permissões
```bash
# Adicionar usuário ao grupo wheel
sudo usermod -aG wheel seu-usuario
```

### Rollback
```bash
# Voltar para geração anterior
sudo nixos-rebuild switch --rollback
```

### Logs detalhados
```bash
sudo nixos-rebuild switch --flake .#hostname --show-trace
```

## 📚 Documentação Adicional

- **[INICIO-RAPIDO-ptBR.md](INICIO-RAPIDO-ptBR.md)** - Guia de início rápido
- **[FEATURES.md](FEATURES.md)** - Recursos detalhados
- **[AI-TOOLS-SETUP.md](AI-TOOLS-SETUP.md)** - Configuração de ferramentas de IA
- **[Manual do NixOS](https://nixos.org/manual/nixos/stable/)** - Documentação oficial

## 🤝 Contribuição

Contribuições são bem-vindas! Por favor, leia as diretrizes de contribuição antes de enviar pull requests.

### Como contribuir:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Faça commit das mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Áreas para contribuição:
- Novos módulos para ambientes de desktop
- Suporte a mais ferramentas de IA
- Melhorias de segurança
- Traduções para outros idiomas
- Testes automatizados

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- [NixOS Community](https://nixos.org/) - Pelo incrível sistema operacional
- [Home Manager](https://github.com/nix-community/home-manager) - Pelo gerenciamento de usuários
- Todas as ferramentas e projetos de código aberto utilizados

## 📞 Suporte

- **Issues**: [GitHub Issues](https://github.com/seu-usuario/nixos/issues)
- **Discussions**: [GitHub Discussions](https://github.com/seu-usuario/nixos/discussions)
- **Comunidade**: [Discourse NixOS](https://discourse.nixos.org/)

---

**Feliz NixOS-ing!** 🚀

*Gerado automaticamente pelo Instalador Interativo do NixOS*