# NixOS Interactive Installer - Features Guide

## Overview

This installer provides a comprehensive, modular NixOS configuration system with extensive customization options for different use cases.

## 🚀 Core Features

### Interactive Installation
- **Step-by-step guided setup** with colored prompts
- **User-friendly configuration** with validation
- **Preview before installation** with confirmation dialog
- **Flexible choices** for each component

### Modular Architecture
- **Clean separation** of concerns
- **Easily extensible** with custom modules
- **Reproducible configurations** via flake
- **Git-ready** from day one

## 🖥️ Desktop Environments

Choose from 8 desktop environments:

### 1. GNOME (Modern Desktop)
```bash
❯ Choose desktop [1-8] [1]: 1
```
**Features:**
- GNOME 45 with modern interface
- GNOME Extensions (AppIndicator, Dash to Dock)
- GNOME Tweaks integration
- Optimized for productivity

### 2. KDE Plasma (Feature-Rich)
```bash
❯ Choose desktop [1-8] [1]: 2
```
**Features:**
- Plasma 6 desktop
- Comprehensive customization
- KDE Applications suite
- Spectacle for screenshots

### 3. XFCE (Lightweight)
```bash
❯ Choose desktop [1-8] [1]: 3
```
**Features:**
- Fast, lightweight interface
- Whisker menu
- PulseAudio integration
- Thunar file manager

### 4. Cinnamon (Familiar Desktop)
```bash
❯ Choose desktop [1-8] [1]: 4
```
**Features:**
- Traditional desktop paradigm
- Cinnamon Desktop environment
- Nemo file manager
- Familiar Windows/macOS-like interface

### 5. MATE (Classic Desktop)
```bash
❯ Choose desktop [1-8] [1]: 5
```
**Features:**
- GNOME 2 continuation
- Lightweight and fast
- Classic desktop experience
- Caja file manager

### 6. i3 (Tiling Window Manager)
```bash
❯ Choose desktop [1-8] [1]: 6
```
**Features:**
- Keyboard-driven tiling
- Highly customizable
- LightDM display manager
- dmenu, rofi, and utilities

### 7. Hyprland (Wayland Compositor)
```bash
❯ Choose desktop [1-8] [1]: 7
```
**Features:**
- Modern Wayland compositor
- Efficient performance
- wlroots-based
- Waybar status bar

### 8. None (Minimal/Server)
```bash
❯ Choose desktop [1-8] [1]: 8
```
**Features:**
- No desktop environment
- Minimal system footprint
- Perfect for servers
- Ideal for headless systems

## 🔧 Specialized Modules

### Development Tools
```bash
❯ Install development tools? (git, vim, vscodium, etc) [Y/n]: y
```

**Included:**
- **Editors:** vim, neovim, vscodium, zed-editor
- **Version Control:** git, gh (GitHub CLI), lazygit
- **Build Tools:** gcc, make, cmake, pkg-config
- **Languages:** Python 3, Node.js, Rust, Go
- **Utilities:** tmux, ripgrep, fd, bat, eza, fzf, jq, direnv

### Docker Support
```bash
❯ Install Docker? [Y/n]: y
```

**Features:**
- Docker daemon with auto-start
- docker-compose included
- lazydocker for monitoring
- Automatic pruning

### Virtualization
```bash
❯ Install virtualization? (QEMU/KVM) [Y/n]: y
```

**Features:**
- libvirt with QEMU/KVM
- virt-manager GUI
- OVMF for UEFI
- virt-viewer for connections

### AI CLI Tools
```bash
❯ Install AI tools? (Claude, Codex, Grok CLI) [Y/n]: y
```

**Primary Tool:**
- **aichat** - Universal AI CLI supporting multiple providers

**Supported Providers:**
- Anthropic Claude (3.5 Sonnet, Opus, Haiku)
- OpenAI GPT-4, GPT-3.5
- Google Gemini
- Custom model support

**Additional Tools:**
- Shell-GPT
- Python/Anthropic SDK
- Node.js AI libraries

### Gaming Setup
```bash
❯ Install gaming tools? (Steam, Proton, Lutris) [Y/n]: y
```

**Features:**
- Steam with remote play
- Lutris for game management
- Heroic for Epic Games
- Bottles for Windows apps
- MangoHud performance overlay
- GameMode for performance optimization

### Multimedia Production
```bash
❯ Install multimedia production? (OBS, Kdenlive, GIMP, Blender) [Y/n]: y
```

**Video Production:**
- Kdenlive (video editor)
- Shotcut (free alternative)
- DaVinci Resolve (professional grading)

**Screen Recording/Streaming:**
- OBS Studio
- VKCapture for Wayland
- PipeWire audio capture

**Image Editing:**
- GIMP (raster graphics)
- Krita (digital painting)
- Inkscape (vector graphics)
- Darktable (RAW photo editing)

**3D & Animation:**
- Blender (full 3D suite)

**Audio Production:**
- Audacity (recording/editing)
- Ardour (professional DAW)
- LMMS (music production)
- Guitarix (guitar effects)

### Cloud Provider Tools
```bash
❯ Install cloud provider CLIs? (AWS, Azure, GCP) [Y/n]: y
```

**AWS:**
- awscli2
- aws-sam-cli
- SSM session manager

**Azure:**
- azure-cli

**Google Cloud:**
- google-cloud-sdk

**Kubernetes:**
- kubectl, helm, k9s
- kubectx, kustomize

**Infrastructure as Code:**
- Terraform
- Terragrunt
- Ansible

## 🔒 Security Hardening
```bash
❯ Enable security hardening? (Firewall, fail2ban, AppArmor) [Y/n]: y
```

### Firewall Configuration
- strict incoming rules
- no ping responses
- connection logging disabled by default

### SSH Hardening
- Root login disabled
- Password authentication disabled
- X11 forwarding disabled
- Max auth tries: 3

### System Hardening
- AppArmor enabled
- SysRq key disabled
- Core dumps disabled
- Network security settings

### Additional Security
- fail2ban for brute force protection
- ClamAV antivirus
- lynis security auditing
- chkrootkit detection

## 👥 Multiple User Support
```bash
❯ Create additional user accounts? [Y/n]: y
❯ Enter username (or press Enter to finish): user2
❯ Enter username (or press Enter to finish): developer
❯ Enter username (or press Enter to finish):
```

**Features:**
- Interactive user creation
- Automatic group assignments
- Zsh shell by default
- NetworkManager and optional groups
- Separate home directories

## 🏠 Home Manager Integration
```bash
❯ Install Home Manager for user configuration? [Y/n]: y
```

### User-Level Packages
- Firefox browser
- VLC media player
- LibreOffice suite
- btop system monitor
- neofetch system info

### Development Tools (Home Manager)
- aichat (with aliases)
- Kitty terminal (Tokyo Night theme)
- direnv integration
- bat (better cat)
- fzf (fuzzy finder)

### Shell Configuration
- Zsh with Oh-My-Zsh
- Git shortcuts
- AI tool shortcuts (`ai`, `claude`, `gpt`)

## 📁 Generated File Structure

```
.
├── flake.nix                      # Main flake configuration
├── hosts/
│   └── YOUR_HOSTNAME/
│       ├── configuration.nix      # Host-specific config
│       └── hardware-configuration.nix
├── modules/
│   ├── system.nix                 # Base system settings
│   ├── desktop-*.nix              # Desktop environment
│   ├── development.nix            # Dev tools
│   ├── docker.nix                 # Docker
│   ├── virtualization.nix         # QEMU/KVM
│   ├── ai-tools.nix               # AI CLI tools
│   ├── gaming.nix                 # Gaming setup
│   ├── multimedia.nix             # Media production
│   ├── cloud-tools.nix            # Cloud CLIs
│   └── security.nix               # Security hardening
├── users/
│   └── YOUR_USERNAME/
│       └── home.nix               # Home Manager config
├── Makefile                       # Convenient commands
├── README.md                      # Documentation
├── QUICKSTART.md                  # Quick installation guide
├── EXAMPLE-RUN.md                 # Sample installation output
├── FEATURES.md                    # This file
├── AI-TOOLS-SETUP.md             # AI tools guide
├── AI-TOOLS-QUICK-REF.md         # AI tools quick reference
└── .gitignore                     # Git ignore rules
```

## 🎯 Usage Examples

### Developer Workstation
```bash
# Choices for a full developer setup
Desktop: GNOME
✓ Development tools
✓ Docker
✓ Virtualization
✓ AI Tools
✗ Gaming
✓ Multimedia
✓ Cloud Tools
✓ Security hardening
✗ Additional users
✓ Home Manager
```

### Gaming PC
```bash
# Choices for gaming-focused system
Desktop: KDE Plasma
✓ Development tools
✓ Docker
✓ Gaming (Steam, Lutris)
✓ Multimedia
✓ Cloud Tools
✗ Virtualization
✗ AI Tools
✓ Security hardening
✗ Additional users
✓ Home Manager
```

### Media Production Workstation
```bash
# Choices for content creation
Desktop: GNOME
✓ Development tools
✓ Multimedia (OBS, Kdenlive, GIMP, Blender)
✓ Cloud Tools
✗ Docker
✗ Virtualization
✗ Gaming
✓ AI Tools
✓ Security hardening
✗ Additional users
✓ Home Manager
```

### Server/Minimal Setup
```bash
# Choices for headless server
Desktop: None
✓ Development tools
✓ Docker
✓ Virtualization
✓ Cloud Tools
✓ Security hardening
✗ Multimedia
✗ Gaming
✗ AI Tools
✗ Additional users
✗ Home Manager
```

## 🚀 Advanced Configuration

### Custom Modules
Add your own modules by creating `modules/custom.nix` and importing in `configuration.nix`.

### Environment Variables
Configure API keys and other secrets securely.

### Role-Based Configurations
Use Home Manager roles for different user profiles.

## 📊 Resource Usage

### Minimal Server (None desktop)
- ~500MB RAM baseline
- ~10GB disk for base system
- Very low CPU usage

### Developer Workstation (GNOME + all dev tools)
- ~2GB RAM baseline
- ~30GB disk for base system + packages
- Moderate CPU usage

### Gaming + Media Production
- ~4GB RAM baseline
- ~50GB+ disk for games and media tools
- Variable CPU/GPU usage

## 🔄 Version History

- **v1.0**: Basic NixOS installer
- **v2.0**: Interactive installer with modular design
- **v2.1**: AI tools support
- **v3.0**: Expanded desktop environments, gaming, multimedia, cloud tools, security hardening, multi-user support

---

**For detailed setup instructions, see QUICKSTART.md**
**For AI tools configuration, see AI-TOOLS-SETUP.md**
```
