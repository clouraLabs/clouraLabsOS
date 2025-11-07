# NixOS Interactive Installation - Quick Start Guide

## 🚀 Quick Installation

Run the interactive installer to set up a complete NixOS configuration:

```bash
./install.sh
```

The installer will guide you through the setup process with interactive prompts.

## 📋 What It Does

The installer creates a complete, flake-based NixOS configuration with:

- ✅ Modular configuration structure
- ✅ Hardware configuration (auto-generated or placeholder)
- ✅ Desktop environment (GNOME, KDE, i3, Hyprland, or none)
- ✅ Home Manager integration (optional)
- ✅ Development tools (git, vim, vscodium, zed-editor, etc.)
- ✅ Docker support (optional)
- ✅ Virtualization (QEMU/KVM, optional)
- ✅ Git configuration
- ✅ User-specific settings

## 🔧 Installation Steps

### 1. Run the Installer

```bash
cd /path/to/nixos
./install.sh
```

### 2. Answer the Interactive Prompts

The installer will ask you about:

**User Configuration:**
- Username (default: current user)
- Hostname (default: current hostname)
- Timezone (default: America/New_York)
- Locale (default: en_US.UTF-8)

**Git Configuration:**
- Whether to configure Git
- Your Git name and email

**Desktop Environment:**
1. GNOME (Modern, user-friendly)
2. KDE Plasma (Feature-rich, customizable)
3. i3 (Tiling window manager)
4. Hyprland (Wayland tiling compositor)
5. None (Minimal/Server)

**Additional Features:**
- Development tools (git, vim, vscodium, zed-editor, etc.)
- Docker
- Virtualization (QEMU/KVM)
- Home Manager

### 3. Review Generated Configuration

After the installer completes, review the generated files:

```bash
cd /path/to/nixos
tree -L 2
```

**IMPORTANT:** If hardware configuration wasn't auto-generated, you MUST create it:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/YOUR_HOSTNAME/hardware-configuration.nix
```

Or copy from existing installation:

```bash
sudo cp /etc/nixos/hardware-configuration.nix hosts/YOUR_HOSTNAME/
```

### 4. Build and Activate

```bash
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME
```

### 5. Reboot

```bash
sudo reboot
```

## 📁 Generated Structure

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
│   ├── development.nix            # Dev tools (if selected)
│   ├── docker.nix                 # Docker (if selected)
│   └── virtualization.nix         # QEMU/KVM (if selected)
├── users/
│   └── YOUR_USERNAME/
│       └── home.nix               # Home Manager config
├── Makefile                       # Convenience commands
├── README.md                      # Detailed documentation
└── .gitignore                     # Git ignore rules
```

## 🎯 Quick Commands

After installation, use these convenient commands:

```bash
# Build and activate configuration
make switch

# Test configuration without persisting
make test

# Update flake inputs
make update

# Update and rebuild
make upgrade

# Clean old generations
make clean

# Validate configuration
make check

# Show all available commands
make help
```

Or use nixos-rebuild directly:

```bash
# Apply configuration changes
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME

# Test without persisting
sudo nixos-rebuild test --flake .#YOUR_HOSTNAME

# Show detailed errors
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME --show-trace

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

## 📦 Adding Packages

### System-wide Packages

Edit `hosts/YOUR_HOSTNAME/configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  vim
  wget
  # Add your packages here
  firefox
  thunderbird
];
```

### User Packages (Home Manager)

Edit `users/YOUR_USERNAME/home.nix`:

```nix
home.packages = with pkgs; [
  # Add your packages here
  discord
  spotify
  obsidian
];
```

### Search for Packages

```bash
nix search nixpkgs <package-name>
```

Or visit: https://search.nixos.org/packages

## 🔄 Managing Your Configuration

### Make Changes

1. Edit configuration files
2. Test changes: `make test`
3. Apply changes: `make switch`

### Update System

```bash
# Update flake inputs
nix flake update

# Rebuild with updates
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME
```

Or use the shortcut:

```bash
make upgrade
```

### Version Control

Initialize a git repository to track your configuration:

```bash
git init
git add .
git commit -m "Initial NixOS configuration"

# Optional: push to remote
git remote add origin https://github.com/yourusername/nixos-config.git
git push -u origin main
```

## 🐛 Troubleshooting

### Hardware Configuration Issues

If the system doesn't boot or has hardware issues:

```bash
sudo nixos-generate-config --show-hardware-config
```

Compare with your `hardware-configuration.nix` and update as needed.

### Build Errors

Check configuration syntax:

```bash
nix flake check
```

Show detailed error traces:

```bash
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME --show-trace
```

### Rollback

If something breaks:

```bash
sudo nixos-rebuild switch --rollback
```

Or select a previous generation from the boot menu.

### Common Issues

**"flake not found" error:**
```bash
cd /path/to/your/config
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME
```

**Permission denied:**
```bash
# Make sure you have sudo privileges
sudo usermod -aG wheel YOUR_USERNAME
```

**Missing hardware configuration:**
```bash
sudo cp /etc/nixos/hardware-configuration.nix hosts/YOUR_HOSTNAME/
```

## 📚 Next Steps

1. **Customize your configuration** - Edit files in `hosts/`, `modules/`, and `users/`
2. **Install additional packages** - Add to configuration.nix or home.nix
3. **Set up applications** - Configure programs in home.nix
4. **Enable services** - Add systemd services in configuration.nix
5. **Backup your config** - Push to git repository

## 📖 Resources

- **NixOS Manual:** https://nixos.org/manual/nixos/stable/
- **Package Search:** https://search.nixos.org/packages
- **Options Search:** https://search.nixos.org/options
- **Home Manager Manual:** https://nix-community.github.io/home-manager/
- **NixOS Wiki:** https://nixos.wiki/
- **Nix Pills:** https://nixos.org/guides/nix-pills/

## 💡 Tips

- Always test configuration before rebooting: `make test`
- Keep your flake.lock in version control
- Document your custom changes in comments
- Use `nix-shell` for temporary development environments
- Join the NixOS community on Discord/Matrix for help

## 🎓 Learning More

### Essential Nix Commands

```bash
# Search packages
nix search nixpkgs firefox

# Run package without installing
nix run nixpkgs#cowsay -- "Hello NixOS"

# Start temporary shell with packages
nix-shell -p python3 nodejs

# Show package info
nix-env -qa --description firefox

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Garbage collection
sudo nix-collect-garbage -d

# Optimize store (saves disk space)
nix-store --optimise
```

---

**Generated by NixOS Interactive Installer v2.0**

Happy NixOS-ing! 🚀