# Guia de Início Rápido - Instalador Interativo do NixOS

## 🚀 Instalação Rápida

Execute o instalador interativo para configurar um sistema NixOS completo:

```bash
./install.sh
```

O instalador irá guiá-lo através do processo de configuração com prompts interativos.

## 📋 O Que Ele Faz

O instalador cria uma configuração completa do NixOS baseada em flakes com:

- ✅ Suporte a flakes
- ✅ Integração com Home Manager
- ✅ Estrutura modular
- ✅ Configurações específicas do usuário
- ✅ Ambiente de desktop (GNOME, KDE, XFCE, Cinnamon, MATE, i3, Hyprland ou nenhum)
- ✅ Ferramentas de desenvolvimento (git, vim, vscodium, zed-editor, etc.)
- ✅ Docker com suporte completo
- ✅ Virtualização (QEMU/KVM)
- ✅ Ferramentas de IA (Claude, GPT, Grok via aichat)
- ✅ Configuração de jogos (Steam, Lutris, Proton)
- ✅ Produção multimídia (OBS, Kdenlive, GIMP, Blender)
- ✅ CLIs de provedores de nuvem (AWS, Azure, GCP, Kubernetes)
- ✅ Reforço de segurança (firewall, AppArmor, SSH hardening)
- ✅ Suporte a múltiplos usuários

## 🔧 Passos de Instalação

### 1. Execute o Instalador

```bash
cd nixos
./install.sh
```

### 2. Responda aos Prompts Interativos

O instalador irá perguntar sobre:

**Configuração do Usuário:**
- Nome de usuário (padrão: usuário atual)
- Nome do host (padrão: hostname do sistema)
- Fuso horário (padrão: America/Sao_Paulo)
- Localização (padrão: pt_BR.UTF-8)

**Git:**
- Configurar Git (nome e email)

**Ambiente de Desktop:**
- Escolher entre 8 opções de desktop

**Recursos Adicionais:**
- Ferramentas de desenvolvimento
- Docker
- Virtualização
- Ferramentas de IA
- Jogos
- Multimídia
- Nuvem
- Segurança reforçada
- Usuários adicionais

### 3. Revise a Configuração Gerada

O instalador cria:

```
nixos/
├── flake.nix                    # Configuração principal
├── hosts/
│   └── seu-hostname/
│       ├── configuration.nix    # Config do sistema
│       └── hardware-configuration.nix
├── modules/                     # Módulos reutilizáveis
│   ├── system.nix              # Sistema base
│   ├── desktop-*.nix           # Ambiente de desktop
│   ├── development.nix         # Ferramentas dev (se selecionado)
│   ├── docker.nix             # Docker (se selecionado)
│   ├── ai-tools.nix           # IA (se selecionado)
│   └── ...
└── users/
    └── seu-usuario/
        └── home.nix            # Config do Home Manager
```

### 4. Construa e Ative

```bash
cd nixos
sudo nixos-rebuild switch --flake .#seu-hostname
```

### 5. Reinicie (Opcional)

Para uma limpeza completa com todas as mudanças aplicadas:

```bash
sudo reboot
```

## O Que É Instalado?

### Sempre (Base)

- Utilitários essenciais (vim, wget, curl, git, htop)
- NetworkManager
- PipeWire (áudio)
- Zsh com Oh-My-Zsh
- SSH habilitado

### Ambientes de Desktop (Se Selecionado)

- **GNOME**: Desktop moderno com GNOME Tweaks e extensões
- **KDE Plasma**: Desktop rico em funcionalidades
- **XFCE**: Desktop leve e tradicional
- **Cinnamon**: Interface elegante e familiar
- **MATE**: Experiência clássica do GNOME 2
- **i3**: Gerenciador de janelas tiling
- **Hyprland**: Compositor Wayland moderno
- **Nenhum**: Sistema mínimo/servidor

### Ferramentas de Desenvolvimento (Se Selecionado)

- Editores: vim, neovim, vscodium, zed-editor
- Controle de versão: git, gh, lazygit
- Ferramentas de build: gcc, make, cmake
- Linguagens: Python, Node.js, Rust, Go
- Utilitários: tmux, ripgrep, fd, bat, eza, fzf

### Docker (Se Selecionado)

- Daemon Docker
- Limpeza automática semanal
- docker-compose
- lazydocker

### Virtualização (Se Selecionado)

- libvirtd com QEMU/KVM
- Virt-manager
- OVMF para UEFI

### Ferramentas de IA (Se Selecionado)

- aichat (universal, suporta Claude, GPT, Gemini)
- Python e Node.js para ferramentas adicionais
- Atalhos de shell (`ai`, `claude`, `gpt`)

### Jogos (Se Selecionado)

- Steam com suporte remoto
- Lutris e Heroic Launcher
- Ferramentas de performance (MangoHud, GameMode)
- Vulkan e drivers gráficos

### Multimídia (Se Selecionado)

- Edição de vídeo: Kdenlive, Shotcut, DaVinci Resolve
- Gravação: OBS Studio
- Imagens: GIMP, Krita, Inkscape
- 3D: Blender

### Nuvem (Se Selecionado)

- AWS: CLI, SAM, SSM
- Azure: CLI completo
- GCP: SDK completo
- Kubernetes: kubectl, helm, k9s

### Segurança Reforçada (Se Selecionado)

- Firewall configurado
- AppArmor habilitado
- SSH hardening
- fail2ban para proteção brute-force
- Limpeza automática de logs

## Uso Diário

### Atualizar Pacotes do Sistema

```bash
nix flake update
sudo nixos-rebuild switch --flake .#seu-hostname
```

### Adicionar Novos Pacotes

**Sistema-wide** (edite `hosts/seu-hostname/configuration.nix`):
```nix
environment.systemPackages = with pkgs; [
  vim
  wget
  # seu novo pacote
  firefox
];
```

**User-level** (edite `users/seu-usuario/home.nix`):
```nix
home.packages = with pkgs; [
  # seu novo pacote
  discord
];
```

Então reconstrua:
```bash
sudo nixos-rebuild switch --flake .#seu-hostname
```

### Rollback de Mudanças

Se algo quebrar:
```bash
sudo nixos-rebuild switch --rollback
```

### Limpar Gerações Antigas

```bash
sudo nix-collect-garbage -d
```

## Solução de Problemas

### Verificar Erros

```bash
nix flake check
```

### Logs Detalhados

```bash
sudo nixos-rebuild switch --flake .#seu-hostname --show-trace
```

### Testar Sem Confirmar

```bash
sudo nixos-rebuild test --flake .#seu-hostname
```

## Próximos Passos

1. **Personalize**: Edite os arquivos de configuração para adicionar seus pacotes preferidos
2. **Faça Backup**: Confirme sua configuração no git
3. **Sincronize**: Faça push para GitHub/GitLab para backup e compartilhamento
4. **Aprenda**: Leia o [manual do NixOS](https://nixos.org/manual/nixos/stable/)

## Ajuda

- Exemplos de configuração: Veja os arquivos `*.example`
- Documentação completa: Veja `README.md`
- Pacotes de pesquisa: https://search.nixos.org/
- Faça perguntas: https://discourse.nixos.org/

---

**Nota**: A primeira build pode levar 10-30 minutos pois o Nix baixa e compila pacotes. Builds subsequentes serão muito mais rápidas graças ao cache do Nix.