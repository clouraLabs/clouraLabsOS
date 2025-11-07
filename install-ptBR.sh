#!/usr/bin/env bash

# Script Interativo de Instalação do NixOS
# Cria uma configuração completa baseada em flake do NixOS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

prompt_yes_no() {
    local prompt="$1"
    local default="${2:-y}"
    local response

    if [[ "$default" == "y" ]]; then
        read -p "$(echo -e ${CYAN}❯${NC}) $prompt [S/n]: " response
        response=${response:-y}
    else
        read -p "$(echo -e ${CYAN}❯${NC}) $prompt [s/N]: " response
        response=${response:-n}
    fi

    [[ "$response" =~ ^[SsYy]$ ]]
}

prompt_input() {
    local prompt="$1"
    local default="$2"
    local response

    if [[ -n "$default" ]]; then
        read -p "$(echo -e ${CYAN}❯${NC}) $prompt [$default]: " response
        echo "${response:-$default}"
    else
        read -p "$(echo -e ${CYAN}❯${NC}) $prompt: " response
        while [[ -z "$response" ]]; do
            echo -e "${RED}Response cannot be empty!${NC}"
            read -p "$(echo -e ${CYAN}❯${NC}) $prompt: " response
        done
        echo "$response"
    fi
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "Este script não deve ser executado como root"
    exit 1
fi

# Welcome banner
clear
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗                ║
║   ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝                ║
║   ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗                ║
║   ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║                ║
║   ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║                ║
║   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝                ║
║                                                           ║
║           Configuration Generator v2.0                   ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

print_info "This script will create a complete NixOS configuration with:"
echo "  • Flakes support"
echo "  • Home Manager integration"
echo "  • Modular structure"
echo "  • Custom user settings"
echo ""

if ! prompt_yes_no "Continuar com a instalação?"; then
    print_info "Instalação cancelada"
    exit 0
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR"

# Gather user information
print_header "User Configuration"

USERNAME=$(prompt_input "Nome de usuário" "$USER")
HOSTNAME=$(prompt_input "Nome do host" "$(hostname)")
TIMEZONE=$(prompt_input "Fuso horário" "America/Sao_Paulo")
LOCALE=$(prompt_input "Localização" "pt_BR.UTF-8")

# Git configuration
print_header "Git Configuration"
USE_GIT=false
GIT_NAME=""
GIT_EMAIL=""

if prompt_yes_no "Configure Git?"; then
    USE_GIT=true
    GIT_NAME=$(prompt_input "Git name" "$(git config --get user.name 2>/dev/null || echo '')")
    GIT_EMAIL=$(prompt_input "Git email" "$(git config --get user.email 2>/dev/null || echo '')")
fi

# Desktop environment
print_header "Ambiente de Desktop"
echo "Ambientes de desktop disponíveis:"
echo "  1) GNOME (Moderno, amigável)"
echo "  2) KDE Plasma (Funcionalidades avançadas, personalizável)"
echo "  3) XFCE (Leve, tradicional)"
echo "  4) Cinnamon (Elegante, familiar)"
echo "  5) MATE (Fork clássico do GNOME 2)"
echo "  6) i3 (Gerenciador de janelas tiling)"
echo "  7) Hyprland (Compositor tiling Wayland)"
echo "  8) None (Mínimo/Servidor)"
echo ""

while true; do
    DE_CHOICE=$(prompt_input "Escolha o desktop [1-8]" "1")
    case $DE_CHOICE in
        1) DESKTOP="gnome"; break ;;
        2) DESKTOP="kde"; break ;;
        3) DESKTOP="xfce"; break ;;
        4) DESKTOP="cinnamon"; break ;;
        5) DESKTOP="mate"; break ;;
        6) DESKTOP="i3"; break ;;
        7) DESKTOP="hyprland"; break ;;
        8) DESKTOP="none"; break ;;
        *) print_error "Invalid choice. Please enter 1-8." ;;
    esac
done

# Package selection
print_header "Recursos Adicionais"

INSTALL_DEV_TOOLS=false
INSTALL_DOCKER=false
INSTALL_VIRTUALIZATION=false
INSTALL_AI_TOOLS=false
INSTALL_GAMING=false
INSTALL_MULTIMEDIA=false
INSTALL_CLOUD_TOOLS=false
SECURITY_HARDENING=false
ADDITIONAL_USERS=()

if prompt_yes_no "Instalar ferramentas de desenvolvimento? (git, vim, vscodium, etc)"; then
    INSTALL_DEV_TOOLS=true
fi

if prompt_yes_no "Instalar Docker?"; then
    INSTALL_DOCKER=true
fi

if prompt_yes_no "Instalar virtualização? (QEMU/KVM)"; then
    INSTALL_VIRTUALIZATION=true
fi

if prompt_yes_no "Instalar ferramentas de IA? (Claude, Codex, Grok CLI)"; then
    INSTALL_AI_TOOLS=true
fi

if prompt_yes_no "Instalar ferramentas de jogos? (Steam, Proton, Lutris)"; then
    INSTALL_GAMING=true
fi

if prompt_yes_no "Instalar produção multimídia? (OBS, Kdenlive, GIMP, Blender)"; then
    INSTALL_MULTIMEDIA=true
fi

if prompt_yes_no "Instalar CLIs de provedores de nuvem? (AWS, Azure, GCP)"; then
    INSTALL_CLOUD_TOOLS=true
fi

# Segurança hardening
print_header "Reforço de Segurança"
if prompt_yes_no "Habilitar reforço de segurança? (Firewall, fail2ban, AppArmor)"; then
    SECURITY_HARDENING=true
fi

# Additional users
print_header "Usuários Adicionais"
if prompt_yes_no "Criar contas de usuário adicionais?"; then
    while true; do
        ADD_USER=$(prompt_input "Digite o nome de usuário (ou pressione Enter para finalizar)" "")
        if [ -z "$ADD_USER" ]; then
            break
        fi
        ADDITIONAL_USERS+=("$ADD_USER")
        print_success "Added user: $ADD_USER"
    done
fi

# Home Manager
print_header "Home Manager"
INSTALL_HOME_MANAGER=false

if prompt_yes_no "Instalar Home Manager for user configuration?"; then
    INSTALL_HOME_MANAGER=true
fi

# Confirm configuration
print_header "Resumo da Configuração"
echo -e "${CYAN}┌────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC} Nome de usuário:         ${GREEN}$USERNAME${NC}"
echo -e "${CYAN}│${NC} Nome do host:         ${GREEN}$HOSTNAME${NC}"
echo -e "${CYAN}│${NC} Fuso horário:         ${GREEN}$TIMEZONE${NC}"
echo -e "${CYAN}│${NC} Localização:           ${GREEN}$LOCALE${NC}"
echo -e "${CYAN}│${NC} Desktop:          ${GREEN}$DESKTOP${NC}"
echo -e "${CYAN}│${NC} Ferramentas dev:        $([ "$INSTALL_DEV_TOOLS" = true ] && echo -e "${GREEN}Yes${NC}" || echo -e "${RED}No${NC}")"
echo -e "${CYAN}│${NC} Docker:           $([ "$INSTALL_DOCKER" = true ] && echo -e "${GREEN}Yes${NC}" || echo -e "${RED}No${NC}")"
echo -e "${CYAN}│${NC} Virtualização:   $([ "$INSTALL_VIRTUALIZATION" = true ] && echo -e "${GREEN}Yes${NC}" || echo -e "${RED}No${NC}")"
echo -e "${CYAN}│${NC} Ferramentas IA:         $([ "$INSTALL_AI_TOOLS" = true ] && echo -e "${GREEN}Yes${NC}" || echo -e "${RED}No${NC}")"
echo -e "${CYAN}│${NC} Jogos:           $([ "$INSTALL_GAMING" = true ] && echo -e "${GREEN}Yes${NC}" || echo -e "${RED}No${NC}")"
echo -e "${CYAN}│${NC} Multimídia:       $([ "$INSTALL_MULTIMEDIA" = true ] && echo -e "${GREEN}Yes${NC}" || echo -e "${RED}No${NC}")"
echo -e "${CYAN}│${NC} Nuvem:      $([ "$INSTALL_CLOUD_TOOLS" = true ] && echo -e "${GREEN}Yes${NC}" || echo -e "${RED}No${NC}")"
echo -e "${CYAN}│${NC} Segurança:         $([ "$SECURITY_HARDENING" = true ] && echo -e "${GREEN}Hardened${NC}" || echo -e "${YELLOW}Standard${NC}")"
echo -e "${CYAN}│${NC} Usuários Adicionais: ${GREEN}${#ADDITIONAL_USERS[@]}${NC}"
echo -e "${CYAN}│${NC} Home Manager:     $([ "$INSTALL_HOME_MANAGER" = true ] && echo -e "${GREEN}Yes${NC}" || echo -e "${RED}No${NC}")"
echo -e "${CYAN}└────────────────────────────────────────┘${NC}"
echo ""

if ! prompt_yes_no "Prosseguir com esta configuração?"; then
    print_info "Instalação cancelada"
    exit 0
fi

# Create directory structure
print_header "Criando Estrutura de Diretórios"

mkdir -p "$CONFIG_DIR"/{modules,hosts,users,overlays}
mkdir -p "$CONFIG_DIR/hosts/$HOSTNAME"
mkdir -p "$CONFIG_DIR/users/$USERNAME"
print_success "Created directory structure"

# Gerar configuração de hardware
print_header "Configuração de Hardware"

HARDWARE_FILE="$CONFIG_DIR/hosts/$HOSTNAME/hardware-configuration.nix"

if prompt_yes_no "Gerar configuração de hardware? (requer sudo)" "y"; then
    if command -v nixos-generate-config &> /dev/null; then
        sudo nixos-generate-config --show-hardware-config > "$HARDWARE_FILE" 2>/dev/null || {
            print_warning "Could not auto-generate hardware config"
            GENERATE_HARDWARE=false
        }
        if [ -f "$HARDWARE_FILE" ]; then
            print_success "Configuração de hardware gerada"
            GENERATE_HARDWARE=true
        else
            GENERATE_HARDWARE=false
        fi
    else
        print_warning "nixos-generate-config not found"
        GENERATE_HARDWARE=false
    fi
else
    GENERATE_HARDWARE=false
fi

if [ "$GENERATE_HARDWARE" = false ]; then
    print_warning "Criando configuração de hardware de placeholder"
    print_info "You MUST replace this with your actual hardware config!"

    cat > "$HARDWARE_FILE" <<'EOF'
# Hardware configuration
# IMPORTANT: Replace this with your actual hardware configuration!
# Você pode gerá-la com: sudo nixos-generate-config --show-hardware-config

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Boot configuration - MODIFY FOR YOUR SYSTEM
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ]; # Change to "kvm-amd" for AMD CPUs
  boot.extraModulePackages = [ ];

  # Filesystems - MODIFY FOR YOUR SYSTEM
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos"; # CHANGE THIS
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot"; # CHANGE THIS
    fsType = "vfat";
  };

  # Swap - UNCOMMENT AND MODIFY IF YOU HAVE SWAP
  # swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  # CPU
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # For AMD CPUs, use:
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
EOF
    print_success "Criado placeholder hardware-configuration.nix"
    echo ""
    print_error "⚠️  IMPORTANT: Edit $HARDWARE_FILE with your actual hardware config!"
    echo ""
fi

# Create configuration files
print_header "Gerando Arquivos de Configuração"

# Create flake.nix
cat > "$CONFIG_DIR/flake.nix" <<EOF
{
  description = "NixOS configuration for $HOSTNAME";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      $HOSTNAME = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/$HOSTNAME/configuration.nix
          ./hosts/$HOSTNAME/hardware-configuration.nix
$(if [ "$INSTALL_HOME_MANAGER" = true ]; then
cat <<INNER

          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.$USERNAME = import ./users/$USERNAME/home.nix;
          }
INNER
fi)
        ];
      };
    };
  };
}
EOF
print_success "Criado flake.nix"

# Create host configuration.nix
cat > "$CONFIG_DIR/hosts/$HOSTNAME/configuration.nix" <<EOF
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
$([ "$DESKTOP" != "none" ] && echo "    ../../modules/desktop-$DESKTOP.nix")
$([ "$INSTALL_DEV_TOOLS" = true ] && echo "    ../../modules/development.nix")
$([ "$INSTALL_DOCKER" = true ] && echo "    ../../modules/docker.nix")
$([ "$INSTALL_VIRTUALIZATION" = true ] && echo "    ../../modules/virtualization.nix")
$([ "$INSTALL_AI_TOOLS" = true ] && echo "    ../../modules/ai-tools.nix")
$([ "$INSTALL_GAMING" = true ] && echo "    ../../modules/gaming.nix")
$([ "$INSTALL_MULTIMEDIA" = true ] && echo "    ../../modules/multimedia.nix")
$([ "$INSTALL_CLOUD_TOOLS" = true ] && echo "    ../../modules/cloud-tools.nix")
$([ "$SECURITY_HARDENING" = true ] && echo "    ../../modules/security.nix")
  ];

  # Nome do host
  networking.hostName = "$HOSTNAME";
  networking.networkmanager.enable = true;

  # Time and locale
  time.timeZone = "$TIMEZONE";
  i18n.defaultLocalização = "$LOCALE";
  i18n.extraLocalizaçãoSettings = {
    LC_ADDRESS = "$LOCALE";
    LC_IDENTIFICATION = "$LOCALE";
    LC_MEASUREMENT = "$LOCALE";
    LC_MONETARY = "$LOCALE";
    LC_NAME = "$LOCALE";
    LC_NUMERIC = "$LOCALE";
    LC_PAPER = "$LOCALE";
    LC_TELEPHONE = "$LOCALE";
    LC_TIME = "$LOCALE";
  };

  # User accounts
  users.users.$USERNAME = {
    isNormalUser = true;
    description = "$USERNAME";
    extraGroups = [ "wheel" "networkmanager"$([ "$INSTALL_DOCKER" = true ] && echo ' "docker"')$([ "$INSTALL_VIRTUALIZATION" = true ] && echo ' "libvirtd"') ];
    shell = pkgs.zsh;
  };

$(for user in "${ADDITIONAL_USERS[@]}"; do
cat <<ADDUSER
  users.users.$user = {
    isNormalUser = true;
    description = "$user";
    extraGroups = [ "networkmanager"$([ "$INSTALL_DOCKER" = true ] && echo ' "docker"')$([ "$INSTALL_VIRTUALIZATION" = true ] && echo ' "libvirtd"') ];
    shell = pkgs.zsh;
  };

ADDUSER
done)

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
    tree
    unzip
    file
  ];

  # Sound with PipeWire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  system.stateVersion = "24.05";
}
EOF
print_success "Criado hosts/$HOSTNAME/configuration.nix"

# Create system.nix module
cat > "$CONFIG_DIR/modules/system.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable zsh
  programs.zsh.enable = true;

  # Sudo configuration
  security.sudo.wheelNeedsPassword = true;

  # Firewall
  networking.firewall.enable = true;

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Optimize storage
  nix.settings.auto-optimise-store = true;
}
EOF
print_success "Created modules/system.nix"

# Create desktop modules based on selection
if [ "$DESKTOP" = "gnome" ]; then
cat > "$CONFIG_DIR/modules/desktop-gnome.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Enable X11 and GNOME
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # GNOME packages
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
  ];

  # Remove unwanted GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
  ];
}
EOF
print_success "Created modules/desktop-gnome.nix"
fi

if [ "$DESKTOP" = "kde" ]; then
cat > "$CONFIG_DIR/modules/desktop-kde.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Enable KDE Plasma
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # KDE packages
  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.spectacle
  ];
}
EOF
print_success "Created modules/desktop-kde.nix"
fi

if [ "$DESKTOP" = "i3" ]; then
cat > "$CONFIG_DIR/modules/desktop-i3.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Enable X11 and i3
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  # i3 utilities
  environment.systemPackages = with pkgs; [
    feh
    rofi
    picom
    alacritty
    nitrogen
    lxappearance
    xfce.thunar
  ];
}
EOF
print_success "Created modules/desktop-i3.nix"
fi

if [ "$DESKTOP" = "hyprland" ]; then
cat > "$CONFIG_DIR/modules/desktop-hyprland.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Hyprland utilities
  environment.systemPackages = with pkgs; [
    waybar
    rofi-wayland
    kitty
    swww
    dunst
    wlogout
    grim
    slurp
    wl-clipboard
    brightnessctl
  ];

  # XDG portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable Wayland support in applications
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
EOF
print_success "Created modules/desktop-hyprland.nix"
fi

if [ "$DESKTOP" = "xfce" ]; then
cat > "$CONFIG_DIR/modules/desktop-xfce.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Enable X11 and XFCE
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
  };

  # XFCE utilities
  environment.systemPackages = with pkgs; [
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-weather-plugin
    xfce.xfce4-clipman-plugin
    xfce.xfce4-systemload-plugin
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    firefox
    mousepad
    ristretto
  ];
}
EOF
print_success "Created modules/desktop-xfce.nix"
fi

if [ "$DESKTOP" = "cinnamon" ]; then
cat > "$CONFIG_DIR/modules/desktop-cinnamon.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Enable X11 and Cinnamon
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
  };

  # Cinnamon utilities
  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal
    gnome.file-roller
    cinnamon.nemo-fileroller
  ];
}
EOF
print_success "Created modules/desktop-cinnamon.nix"
fi

if [ "$DESKTOP" = "mate" ]; then
cat > "$CONFIG_DIR/modules/desktop-mate.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Enable X11 and MATE
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.mate.enable = true;
  };

  # MATE utilities
  environment.systemPackages = with pkgs; [
    mate.caja-extensions
    mate.mate-utils
    mate.mate-system-monitor
    mate.engrampa
  ];
}
EOF
print_success "Created modules/desktop-mate.nix"
fi

# Create development module
if [ "$INSTALL_DEV_TOOLS" = true ]; then
cat > "$CONFIG_DIR/modules/development.nix" <<EOF
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editors
    vim
    neovim
    vscodium
    zed-editor

    # Version control
    git
    gh
    lazygit

    # Build tools
    gcc
    gnumake
    cmake
    pkg-config

    # Languages
    python3
    python3Packages.pip
    python3Packages.virtualenv
    nodejs
    nodePackages.npm
    rustc
    cargo
    go

    # Utilities
    tmux
    tree
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    direnv
  ];

$(if [ "$USE_GIT" = true ] && [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
cat <<INNER
  # Git configuration
  programs.git = {
    enable = true;
    config = {
      user.name = "$GIT_NAME";
      user.email = "$GIT_EMAIL";
      init.defaultBranch = "main";
    };
  };
INNER
fi)

  # Enable direnv
  programs.direnv.enable = true;
}
EOF
print_success "Created modules/development.nix"
fi

# Create docker module
if [ "$INSTALL_DOCKER" = true ]; then
cat > "$CONFIG_DIR/modules/docker.nix" <<'EOF'
{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker
  ];
}
EOF
print_success "Created modules/docker.nix"
fi

# Create virtualization module
if [ "$INSTALL_VIRTUALIZATION" = true ]; then
cat > "$CONFIG_DIR/modules/virtualization.nix" <<'EOF'
{ config, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      ovmf.enable = true;
      ovmf.packages = [ pkgs.OVMFFull.fd ];
    };
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    OVMF
    virt-viewer
  ];
}
EOF
print_success "Created modules/virtualization.nix"
fi

# Create AI tools module
if [ "$INSTALL_AI_TOOLS" = true ]; then
cat > "$CONFIG_DIR/modules/ai-tools.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # AI CLI Tools Installation
  environment.systemPackages = with pkgs; [
    # AI Chat clients
    aichat  # Multi-provider AI CLI (supports Claude, GPT, Gemini, etc.)

    # Python (for claude-cli and other Python-based AI tools)
    python311
    python311Packages.pip
    python311Packages.anthropic

    # Node.js (for various AI CLI tools)
    nodejs
    nodePackages.npm

    # Rust/Cargo (for Rust-based AI tools)
    rustc
    cargo

    # Additional AI utilities
    jq  # JSON processing for API responses
    curl  # For direct API calls
  ];

  # System-wide environment variables for AI tools
  environment.variables = {
    # Add API key paths (users should set actual keys)
    # ANTHROPIC_API_KEY can be set in user's shell config
    # OPENAI_API_KEY can be set in user's shell config
    # XAI_API_KEY for Grok can be set in user's shell config
  };

  # Note: AI CLI tools installation and configuration
  #
  # AICHAT (Recommended - Multi-provider support):
  #   Already installed via Nix
  #   Configure: ~/.config/aichat/config.yaml
  #   Set API keys: export ANTHROPIC_API_KEY="your-key"
  #
  # Additional tools (install as needed):
  #
  # Claude CLI (official Anthropic):
  #   pip install anthropic
  #   Usage: python -m anthropic
  #
  # Shell-GPT (GPT focused):
  #   pip install shell-gpt
  #   Usage: sgpt "your prompt"
  #
  # OpenAI CLI:
  #   npm install -g openai-cli
  #   Usage: openai "your prompt"
  #
  # Grok CLI (X.AI):
  #   Check: https://x.ai for official CLI
  #   npm install -g @x.ai/grok-cli (if available)
  #
  # GitHub Copilot CLI:
  #   npm install -g @githubnext/github-copilot-cli
  #   Usage: github-copilot-cli
}
EOF
print_success "Created modules/ai-tools.nix"
fi

# Create gaming module
if [ "$INSTALL_GAMING" = true ]; then
cat > "$CONFIG_DIR/modules/gaming.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Jogos configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable GameMode for performance
  programs.gamemode.enable = true;

  # Jogos packages
  environment.systemPackages = with pkgs; [
    # Game launchers
    lutris
    heroic
    bottles

    # Jogos utilities
    mangohud
    goverlay
    gamemode
    gamescope

    # Emulators
    retroarch

    # Wine/Proton tools
    winetricks
    protontricks

    # Performance monitoring
    vulkan-tools
    mesa-demos
  ];

  # Enable 32-bit libraries for gaming
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable Xbox controller support
  hardware.xone.enable = true;
  hardware.xpadneo.enable = true;
}
EOF
print_success "Created modules/gaming.nix"
fi

# Create multimedia module
if [ "$INSTALL_MULTIMEDIA" = true ]; then
cat > "$CONFIG_DIR/modules/multimedia.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Multimídia production packages
  environment.systemPackages = with pkgs; [
    # Video editing
    kdenlive
    shotcut
    davinci-resolve

    # Screen recording/streaming
    obs-studio
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-pipewire-audio-capture

    # Image editing
    gimp
    krita
    inkscape
    darktable
    rawtherapee

    # 3D modeling and animation
    blender

    # Audio production
    audacity
    ardour
    lmms
    guitarix

    # Video players/tools
    vlc
    mpv
    ffmpeg-full
    handbrake

    # Graphics utilities
    imagemagick
    graphicsmagick
  ];

  # Enable PipeWire for better audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Real-time audio group
  security.rtkit.enable = true;

  # JACK audio
  services.jack = {
    jackd.enable = false;
    alsa.enable = false;
    loopback = {
      enable = false;
    };
  };
}
EOF
print_success "Created modules/multimedia.nix"
fi

# Create cloud tools module
if [ "$INSTALL_CLOUD_TOOLS" = true ]; then
cat > "$CONFIG_DIR/modules/cloud-tools.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Cloud provider CLI tools
  environment.systemPackages = with pkgs; [
    # AWS
    awscli2
    aws-sam-cli
    ssm-session-manager-plugin

    # Azure
    azure-cli

    # Google Cloud
    google-cloud-sdk

    # Kubernetes
    kubectl
    kubernetes-helm
    k9s
    kubectx
    kustomize

    # Terraform/IaC
    terraform
    terragrunt
    ansible

    # Container tools
    docker-compose
    dive  # Docker image explorer

    # Cloud utilities
    s3cmd
    rclone
    gh  # GitHub CLI
  ];

  # Enable Docker for cloud development
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
}
EOF
print_success "Created modules/cloud-tools.nix"
fi

# Create security hardening module
if [ "$SECURITY_HARDENING" = true ]; then
cat > "$CONFIG_DIR/modules/security.nix" <<'EOF'
{ config, pkgs, ... }:

{
  # Segurança hardening configuration

  # Firewall
  networking.firewall = {
    enable = true;
    allowPing = false;
    logRefusedConnections = false;
    # Add custom rules as needed
  };

  # Fail2ban
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0.0/8"
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
    ];
  };

  # AppArmor
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };

  # Kernel hardening
  boot.kernel.sysctl = {
    # Disable SysRq key
    "kernel.sysrq" = 0;

    # Disable core dumps
    "kernel.core_uses_pid" = 1;
    "fs.suid_dumpable" = 0;

    # Network security
    "net.ipv4.conf.all.send_redirects" = false;
    "net.ipv4.conf.default.send_redirects" = false;
    "net.ipv4.conf.all.accept_redirects" = false;
    "net.ipv4.conf.default.accept_redirects" = false;
    "net.ipv4.conf.all.secure_redirects" = false;
    "net.ipv4.conf.default.secure_redirects" = false;
    "net.ipv6.conf.all.accept_redirects" = false;
    "net.ipv6.conf.default.accept_redirects" = false;
    "net.ipv4.conf.all.accept_source_route" = false;
    "net.ipv6.conf.all.accept_source_route" = false;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.log_martians" = true;
  };

  # SSH hardening
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = false;
      X11Forwarding = false;
      MaxAuthTries = 3;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };

  # Sudo configuration
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = true;
  };

  # Automatic updates (optional, disabled by default)
  system.autoUpgrade = {
    enable = false;
    allowReboot = false;
  };

  # Additional security packages
  environment.systemPackages = with pkgs; [
    lynis        # Segurança auditing
    chkrootkit   # Rootkit detection
    clamav       # Antivirus
    rkhunter     # Rootkit hunter
  ];

  # ClamAV antivirus
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  # USB Guard (optional - can be intrusive)
  # services.usbguard.enable = true;
}
EOF
print_success "Created modules/security.nix"
fi

# Create Home Manager configuration
if [ "$INSTALL_HOME_MANAGER" = true ]; then
cat > "$CONFIG_DIR/users/$USERNAME/home.nix" <<EOF
{ config, pkgs, ... }:

{
  home.username = "$USERNAME";
  home.homeDirectory = "/home/$USERNAME";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # User packages
  home.packages = with pkgs; [
    firefox
    vlc
    libreoffice
    btop
    neofetch
$(if [ "$INSTALL_AI_TOOLS" = true ]; then
cat <<INNER
    # AI and automation tools
    aichat
INNER
fi)
  ];

$(if [ "$USE_GIT" = true ] && [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
cat <<INNER
  # Git configuration
  programs.git = {
    enable = true;
    userName = "$GIT_NAME";
    userEmail = "$GIT_EMAIL";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "vim";
    };
  };
INNER
fi)

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -alh";
      update = "sudo nixos-rebuild switch --flake /home/$USERNAME/.config/nixos#$HOSTNAME";
      clean = "sudo nix-collect-garbage -d";
$(if [ "$INSTALL_AI_TOOLS" = true ]; then
cat <<INNER
      # AI tool shortcuts
      ai = "aichat";
      claude = "aichat --model claude";
      gpt = "aichat --model gpt-4";
INNER
fi)
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo"$([ "$INSTALL_DOCKER" = true ] && echo ' "docker"') ];
    };
  };

  # Terminal emulator
  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    settings = {
      font_size = 11;
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
  };

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Bat (better cat)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  # Fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
EOF
print_success "Created users/$USERNAME/home.nix"
fi

# Create README
cat > "$CONFIG_DIR/README.md" <<EOF
# NixOS Configuration for $HOSTNAME

Generated by NixOS Interactive Installer

## 📁 Structure

\`\`\`
.
├── flake.nix                      # Flake configuration
├── hosts/
│   └── $HOSTNAME/
│       ├── configuration.nix      # Host configuration
│       └── hardware-configuration.nix
├── modules/
│   ├── system.nix                 # Base system
$([ "$DESKTOP" != "none" ] && echo "│   ├── desktop-$DESKTOP.nix          # Desktop environment")
$([ "$INSTALL_DEV_TOOLS" = true ] && echo "│   ├── development.nix            # Dev tools")
$([ "$INSTALL_DOCKER" = true ] && echo "│   ├── docker.nix                 # Docker")
$([ "$INSTALL_VIRTUALIZATION" = true ] && echo "│   ├── virtualization.nix         # QEMU/KVM")
$([ "$INSTALL_AI_TOOLS" = true ] && echo "│   ├── ai-tools.nix               # AI CLI tools")
$([ "$INSTALL_GAMING" = true ] && echo "│   ├── gaming.nix                 # Jogos (Steam, Lutris)")
$([ "$INSTALL_MULTIMEDIA" = true ] && echo "│   ├── multimedia.nix             # Multimídia production")
$([ "$INSTALL_CLOUD_TOOLS" = true ] && echo "│   ├── cloud-tools.nix            # Cloud provider CLIs")
$([ "$SECURITY_HARDENING" = true ] && echo "│   └── security.nix                # Segurança hardening")
└── users/
    └── $USERNAME/
        └── home.nix               # Home Manager config
\`\`\`

## 🚀 Quick Start

### First Build

1. Navigate to configuration directory:
   \`\`\`bash
   cd $CONFIG_DIR
   \`\`\`

$(if [ "$GENERATE_HARDWARE" = false ]; then
cat <<INNER
2. **IMPORTANT**: Copy your hardware configuration:
   \`\`\`bash
   sudo nixos-generate-config --show-hardware-config > hosts/$HOSTNAME/hardware-configuration.nix
   \`\`\`
   OR edit the placeholder at \`hosts/$HOSTNAME/hardware-configuration.nix\`

3. Build and activate:
INNER
else
cat <<INNER
2. Build and activate:
INNER
fi)
   \`\`\`bash
   sudo nixos-rebuild switch --flake .#$HOSTNAME
   \`\`\`

### Updating

\`\`\`bash
# Update flake inputs
nix flake update

# Rebuild with updates
sudo nixos-rebuild switch --flake .#$HOSTNAME
\`\`\`

### Maintenance

\`\`\`bash
# Clean old generations
sudo nix-collect-garbage -d

# Check configuration
nix flake check
\`\`\`

## 📦 Adding Packages

### System Packages
Edit \`hosts/$HOSTNAME/configuration.nix\`:
\`\`\`nix
environment.systemPackages = with pkgs; [
  # your packages here
];
\`\`\`

### User Packages (Home Manager)
Edit \`users/$USERNAME/home.nix\`:
\`\`\`nix
home.packages = with pkgs; [
  # your packages here
];
\`\`\`

## 🔍 Useful Commands

\`\`\`bash
# Search packages
nix search nixpkgs <package-name>

# Test configuration (doesn't persist)
sudo nixos-rebuild test --flake .#$HOSTNAME

# Show detailed errors
sudo nixos-rebuild switch --flake .#$HOSTNAME --show-trace

# Rollback
sudo nixos-rebuild switch --rollback
\`\`\`

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Package Search](https://search.nixos.org/)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [NixOS Wiki](https://nixos.wiki/)

---
Generated on $(date)
EOF
print_success "Created README.md"

# Create .gitignore
cat > "$CONFIG_DIR/.gitignore" <<'EOF'
# Build results
result
result-*

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Temporary
*.tmp
*.bak

# Optional: uncomment to ignore hardware config
# hardware-configuration.nix
EOF
print_success "Created .gitignore"

# Create Makefile for convenience
cat > "$CONFIG_DIR/Makefile" <<EOF
.PHONY: switch test build update upgrade clean check help

FLAKE := .#$HOSTNAME

switch:
	@echo "Building and activating configuration..."
	sudo nixos-rebuild switch --flake \$(FLAKE)

test:
	@echo "Testing configuration..."
	sudo nixos-rebuild test --flake \$(FLAKE)

build:
	@echo "Building configuration..."
	sudo nixos-rebuild build --flake \$(FLAKE)

update:
	@echo "Updating flake inputs..."
	nix flake update

upgrade: update switch
	@echo "System upgraded!"

clean:
	@echo "Running garbage collection..."
	sudo nix-collect-garbage -d

check:
	@echo "Checking configuration..."
	nix flake check
	@echo "✓ Configuration is valid!"

help:
	@echo "Available targets:"
	@echo "  switch  - Build and activate configuration"
	@echo "  test    - Test without persisting"
	@echo "  build   - Build without activating"
	@echo "  update  - Update flake inputs"
	@echo "  upgrade - Update and rebuild"
	@echo "  clean   - Garbage collection"
	@echo "  check   - Validate configuration"
EOF
print_success "Created Makefile"

# Final completion
print_header "Instalação Concluída! 🎉"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
print_success "Configuration files generated in: $CONFIG_DIR"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ ${#ADDITIONAL_USERS[@]} -gt 0 ]; then
    print_info "📝 Usuários Adicionais Created:"
    for user in "${ADDITIONAL_USERS[@]}"; do
        echo "   - $user"
    done
    echo ""
    print_warning "Set passwords for new users:"
    for user in "${ADDITIONAL_USERS[@]}"; do
        echo "   sudo passwd $user"
    done
    echo ""
fi

if [ "$SECURITY_HARDENING" = true ]; then
    print_warning "🔒 Reforço de Segurança Enabled"
    echo "   - SSH key authentication required (disable password auth)"
    echo "   - Generate SSH key: ssh-keygen -t ed25519"
    echo "   - Add to authorized_keys before disabling password auth"
    echo ""
fi

print_info "📋 Próximos Passos:"
echo ""

if [ "$GENERATE_HARDWARE" = false ]; then
    echo -e "${YELLOW}⚠  IMPORTANT:${NC} Hardware configuration needs to be set up!"
    echo ""
    echo "   Option 1 - Auto-generate:"
    echo -e "   ${CYAN}cd $CONFIG_DIR${NC}"
    echo -e "   ${CYAN}sudo nixos-generate-config --show-hardware-config > hosts/$HOSTNAME/hardware-configuration.nix${NC}"
    echo ""
    echo "   Option 2 - Copy existing:"
    echo -e "   ${CYAN}sudo cp /etc/nixos/hardware-configuration.nix $CONFIG_DIR/hosts/$HOSTNAME/${NC}"
    echo ""
fi

echo "1. Navigate to configuration directory:"
echo -e "   ${CYAN}cd $CONFIG_DIR${NC}"
echo ""

echo "2. Revise os arquivos gerados (especially hardware-configuration.nix)"
echo ""

echo "3. Construa e ative sua configuração:"
echo -e "   ${CYAN}sudo nixos-rebuild switch --flake .#$HOSTNAME${NC}"
echo ""

echo "4. (Optional) Initialize git repository:"
echo -e "   ${CYAN}git init${NC}"
echo -e "   ${CYAN}git add .${NC}"
echo -e "   ${CYAN}git commit -m \"Initial NixOS configuration\"${NC}"
echo ""

echo "5. After successful build, reboot:"
echo -e "   ${CYAN}sudo reboot${NC}"
echo ""

print_info "📚 Quick Commands:"
echo ""
echo "  Update system:        make upgrade"
echo "  Clean old versions:   make clean"
echo "  Test config:          make test"
echo "  Check syntax:         make check"
echo "  Show all commands:    make help"
echo ""

print_info "📖 Resources:"
echo "  - Configuration: $CONFIG_DIR/README.md"
echo "  - NixOS Manual:  https://nixos.org/manual/nixos/stable/"
echo "  - Package Search: https://search.nixos.org/"
echo ""

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Happy NixOS-ing! 🚀${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
