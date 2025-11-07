# Changelog

All notable changes to this NixOS Interactive Installer will be documented in this file.

## [3.0.0] - 2024-11-07

### Added

#### Expanded Desktop Environment Support
- **XFCE Desktop**: Lightweight, traditional desktop with Whisker menu and extensions
- **Cinnamon Desktop**: Elegant, familiar interface with traditional desktop paradigm
- **MATE Desktop**: Classic GNOME 2 experience with Caja file manager
- **Interactive Selection**: Now choose from 8 desktop options (was 5)
- **Modular Desktop Configuration**: Each desktop environment in separate module file

#### Gaming Setup Module (`modules/gaming.nix`)
- **Steam Integration**: Complete Steam setup with remote play and dedicated server support
- **Game Management**: Lutris, Heroic Launcher (Epic Games), and Bottles for Windows apps
- **Performance Tools**: MangoHud overlay, Goverlay, GameMode, and Gamescope
- **Emulators**: RetroArch for retro gaming
- **Gaming Libraries**: Vulkan tools, Mesa drivers, OpenGL support for modern games
- **Controller Support**: Xbox One and Xbox controller support (xone, xpadneo)

#### Multimedia Production Module (`modules/multimedia.nix`)
- **Video Editing**: Kdenlive, Shotcut, and DaVinci Resolve
- **Screen Recording**: OBS Studio with VKCapture and PipeWire audio capture
- **Image Editing**: GIMP, Krita, Inkscape, Darktable, and RawTherapee
- **3D & Animation**: Blender full 3D suite
- **Audio Production**: Audacity, Ardour, LMMS, and Guitarix guitar effects
- **Media Tools**: VLC, MPV, FFmpeg, HandBrake
- **Real-time Audio**: PipeWire and JACK audio server integration

#### Cloud Provider CLI Tools Module (`modules/cloud-tools.nix`)
- **AWS Tools**: awscli2, AWS SAM CLI, SSM Session Manager
- **Azure CLI**: Complete Azure command-line tools
- **Google Cloud SDK**: Full Google Cloud Platform CLI
- **Kubernetes Tools**: kubectl, Helm, k9s, kubectx, kustomize
- **Infrastructure as Code**: Terraform, Terragrunt, Ansible
- **Container Tools**: dive (Docker image explorer), s3cmd, rclone
- **Cloud Utilities**: GitHub CLI, docker-compose
- **Docker Integration**: Included Docker daemon setup

#### Security Hardening Module (`modules/security.nix`)
- **Firewall Configuration**: Strict rules with ping disabled
- **SSH Hardening**: Root login disabled, password auth disabled, client-alive settings
- **AppArmor Integration**: Security profiles with enforcement
- **Fail2ban Protection**: Brute force prevention
- **Kernel Hardening**: SysRq disabled, core dumps disabled, network security
- **Security Tools**: Lynis auditing, chkrootkit detection, ClamAV antivirus
- **Sudo Configuration**: Wheel-only execution with password requirements

#### Multiple User Support
- **Interactive User Creation**: Add additional user accounts during installation
- **User Configuration**: Automatic group assignments and shell setup
- **Home Directories**: Separate home directories for each user
- **Password Setup**: Post-installation password setup instructions
- **Group Membership**: Optional Docker, libvirtd, and other group assignments

#### Enhanced System Configuration
- **Per-User Module Generation**: Home Manager configs for additional users
- **Configuration Summary**: Enhanced summary showing additional users and security status
- **Post-Install Instructions**: Detailed setup steps for security and users

### Changed
- **Desktop Selection**: Expanded from 5 to 8 options with descriptive names
- **Configuration File Generation**: Added support for multiple user configurations
- **Module Structure**: Organized new modules by functionality
- **Security Defaults**: Optional but recommended security hardening
- **Installation Flow**: Enhanced prompts for advanced options

### Technical Improvements
- **Bash Script Optimization**: Improved variable handling and error checking
- **File Generation**: Streamlined module creation process
- **User Experience**: Clearer prompts and better organization
- **Documentation**: Updated all guides to reflect new features

## [2.1.0] - 2024-11-07

### Added

#### AI CLI Tools Support
- **New AI Tools Module** (`modules/ai-tools.nix`)
  - Multi-provider AI CLI support with aichat
  - Support for Claude (Anthropic), GPT/Codex (OpenAI), Grok (X.AI), and Gemini (Google)
  - Pre-configured environment for installing additional AI tools
  - Python, Node.js, and Rust environments included

- **Interactive Installation Option**
  - New prompt during installation: "Install AI tools? (Claude, Codex, Grok CLI)"
  - Automatically configures AI tools module when selected

- **Home Manager Integration**
  - aichat package included in user packages when AI tools selected
  - Pre-configured shell aliases (`ai`, `claude`, `gpt`)
  - Ready-to-use AI CLI experience

- **Documentation**
  - `AI-TOOLS-SETUP.md` - Comprehensive setup guide with:
    - Installation instructions
    - API key configuration
    - Usage examples for all major AI providers
    - Best practices and security tips
    - Troubleshooting guide
    - Advanced usage examples
  - `AI-TOOLS-QUICK-REF.md` - Quick reference card with:
    - Common commands
    - Configuration snippets
    - Model comparison table
    - Useful scripts

#### Features Included in AI Tools Module

**Primary Tool:**
- **aichat** - Universal AI CLI supporting multiple providers
  - Claude 3.5 Sonnet, Opus, Haiku
  - GPT-4, GPT-4 Turbo, GPT-3.5
  - Google Gemini Pro
  - Custom roles and configurations

**Development Environment:**
- Python 3.11 with pip and anthropic package
- Node.js with npm
- Rust/Cargo for Rust-based AI tools
- Additional utilities (jq, curl)

**Instructions for Additional Tools:**
- Official Anthropic Claude CLI
- OpenAI CLI
- Shell-GPT
- GitHub Copilot CLI
- Grok CLI (when available)

### Changed

- Updated `install.sh` to version 2.1.0
  - Added `INSTALL_AI_TOOLS` flag
  - Added AI tools prompt in interactive flow
  - Added AI tools to configuration summary
  - Integrated ai-tools.nix module import

- Updated `configuration.nix` generation
  - Conditionally imports `../../modules/ai-tools.nix`
  - Added to module list when AI tools selected

- Updated `home.nix` generation
  - Conditionally includes aichat package
  - Added shell aliases for AI tools (ai, claude, gpt)

- Updated `README.md` in generated configurations
  - Added AI tools to structure documentation
  - Updated features list

### Configuration Summary Display

Added AI Tools status to the configuration summary:
```
┌────────────────────────────────────────┐
│ Username:         user
│ Hostname:         nixos
│ ...
│ AI Tools:         Yes
│ ...
└────────────────────────────────────────┘
```

### Shell Aliases

When AI Tools and Home Manager are both enabled:
```bash
ai "query"          # Use default AI model
claude "query"      # Use Claude specifically
gpt "query"         # Use GPT-4 specifically
```

## [2.0.0] - 2024-11-07

### Changed

- **Complete Rewrite** - Converted from non-interactive to fully interactive installer
- Removed command-line arguments in favor of interactive prompts
- Added beautiful ASCII banner and colored output
- Improved user experience with step-by-step guided setup

### Added

- Interactive prompts for all configuration options
- User-friendly configuration summary with confirmation
- Automatic hardware configuration generation with fallback
- Comprehensive documentation (QUICKSTART.md, INSTALLER-SUMMARY.md, EXAMPLE-RUN.md)
- Makefile with convenient commands
- Complete .gitignore for NixOS configurations

### Fixed

- VSCode replaced with VSCodium (open-source version)
- Added Zed editor to development tools
- Improved module structure and organization
- Better error handling and user feedback

## [1.0.0] - Initial Release

### Added

- Basic NixOS configuration generator
- Flake-based configuration structure
- Desktop environment support (GNOME, KDE, i3, Hyprland)
- Development tools module
- Docker support
- Virtualization support (QEMU/KVM)
- Home Manager integration
- Modular architecture

---

## Migration Guide

### From 2.0 to 2.1

If you already have a NixOS configuration from v2.0, you can add AI tools support:

1. **Copy the AI tools module:**
   ```bash
   # The module will be in modules/ai-tools.nix after running installer v2.1
   # Or create it manually following AI-TOOLS-SETUP.md
   ```

2. **Add to your configuration.nix:**
   ```nix
   imports = [
     # ... existing imports
     ../../modules/ai-tools.nix
   ];
   ```

3. **Add to home.nix (if using Home Manager):**
   ```nix
   home.packages = with pkgs; [
     # ... existing packages
     aichat
   ];

   programs.zsh.shellAliases = {
     # ... existing aliases
     ai = "aichat";
     claude = "aichat --model claude";
     gpt = "aichat --model gpt-4";
   };
   ```

4. **Rebuild:**
   ```bash
   sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME
   ```

5. **Set up API keys:**
   ```bash
   # See AI-TOOLS-SETUP.md for detailed instructions
   nano ~/.config/ai-keys.sh
   ```

## Future Plans

### Upcoming Features
- [ ] Server management tools (nginx, postgresql, monitoring)
- [ ] Laptop-specific optimizations (power management, touchpad)
- [ ] Printing and scanner support
- [ ] Network configuration tools (VPN, firewall management)
- [ ] Backup and recovery solutions
- [ ] Custom kernel configurations
- [ ] Remote desktop and VNC setup

## Links

- **Installation Guide:** QUICKSTART.md
- **Features Guide:** FEATURES.md
- **AI Tools Setup:** AI-TOOLS-SETUP.md
- **AI Tools Quick Reference:** AI-TOOLS-QUICK-REF.md
- **Example Run:** EXAMPLE-RUN.md
- **Installer Summary:** INSTALLER-SUMMARY.md
- **Full Documentation:** README.md

---

**Note:** This project follows [Semantic Versioning](https://semver.org/).