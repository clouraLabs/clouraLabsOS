# Example Installer Run

This document shows what you'll see when running the NixOS Interactive Installer.

## Starting the Installer

```bash
$ ./install.sh
```

## Interactive Session Output

```
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

ℹ This script will create a complete NixOS configuration with:
  • Flakes support
  • Home Manager integration
  • Modular structure
  • Custom user settings

❯ Continue with installation? [Y/n]: y

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  User Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❯ Username [clouralabs]: john
❯ Hostname [nixos-pc]: desktop
❯ Timezone [America/New_York]: America/Los_Angeles
❯ Locale [en_US.UTF-8]: 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Git Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❯ Configure Git? [Y/n]: y
❯ Git name [John Doe]: 
❯ Git email [john@example.com]: 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Desktop Environment
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Available desktop environments:
  1) GNOME (Modern, user-friendly)
  2) KDE Plasma (Feature-rich, customizable)
  3) i3 (Tiling window manager)
  4) Hyprland (Wayland tiling compositor)
  5) None (Minimal/Server)

❯ Choose desktop [1-5] [1]: 1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Additional Features
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❯ Install development tools? (git, vim, vscodium, etc) [Y/n]: y
❯ Install Docker? [Y/n]: y
❯ Install virtualization? (QEMU/KVM) [Y/n]: n

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Home Manager
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❯ Install Home Manager for user configuration? [Y/n]: y

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Configuration Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌────────────────────────────────────────┐
│ Username:         john
│ Hostname:         desktop
│ Timezone:         America/Los_Angeles
│ Locale:           en_US.UTF-8
│ Desktop:          gnome
│ Dev Tools:        Yes
│ Docker:           Yes
│ Virtualization:   No
│ Home Manager:     Yes
└────────────────────────────────────────┘

❯ Proceed with this configuration? [Y/n]: y

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Creating Directory Structure
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Created directory structure

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Hardware Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❯ Generate hardware configuration? (requires sudo) [Y/n]: y
[sudo] password for clouralabs: 
✓ Hardware configuration generated

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Generating Configuration Files
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Created flake.nix
✓ Created hosts/desktop/configuration.nix
✓ Created modules/system.nix
✓ Created modules/desktop-gnome.nix
✓ Created modules/development.nix
✓ Created modules/docker.nix
✓ Created users/john/home.nix
✓ Created README.md
✓ Created .gitignore
✓ Created Makefile

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Installation Complete! 🎉
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Configuration files generated in: /home/clouralabs/Documents/nixos
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ 📋 Next Steps:

1. Navigate to configuration directory:
   cd /home/clouralabs/Documents/nixos

2. Review the generated files (especially hardware-configuration.nix)

3. Build and activate your configuration:
   sudo nixos-rebuild switch --flake .#desktop

4. (Optional) Initialize git repository:
   git init
   git add .
   git commit -m "Initial NixOS configuration"

5. After successful build, reboot:
   sudo reboot

ℹ 📚 Quick Commands:

  Update system:        make upgrade
  Clean old versions:   make clean
  Test config:          make test
  Check syntax:         make check
  Show all commands:    make help

ℹ 📖 Resources:
  - Configuration: /home/clouralabs/Documents/nixos/README.md
  - NixOS Manual:  https://nixos.org/manual/nixos/stable/
  - Package Search: https://search.nixos.org/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Happy NixOS-ing! 🚀
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```

## What Was Created

After running the installer, your directory structure looks like this:

```
nixos/
├── flake.nix
├── hosts/
│   └── desktop/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── system.nix
│   ├── desktop-gnome.nix
│   ├── development.nix
│   └── docker.nix
├── users/
│   └── john/
│       └── home.nix
├── Makefile
├── README.md
└── .gitignore
```

## Activating the Configuration

```bash
$ cd nixos
$ sudo nixos-rebuild switch --flake .#desktop
```

Output:
```
building the system configuration...
these 1247 derivations will be built:
  /nix/store/...-nixos-system-desktop-24.05
  ...

copying path '/nix/store/...' from 'https://cache.nixos.org'...
building '/nix/store/...-unit-script-...'
...

activating the configuration...
setting up /etc...
reloading user units for john...
setting up tmpfiles
restarting systemd...

✓ System configuration activated!
```

## Using the Makefile

```bash
$ make help
Available targets:
  switch  - Build and activate configuration
  test    - Test without persisting
  build   - Build without activating
  update  - Update flake inputs
  upgrade - Update and rebuild
  clean   - Garbage collection
  check   - Validate configuration

$ make switch
Building and activating configuration...
sudo nixos-rebuild switch --flake .#desktop
...

$ make upgrade
Updating flake inputs...
nix flake update
...
Building and activating configuration...
...
System upgraded!
```

## Example: Server Installation

For a minimal server setup, the choices would be:

```
❯ Choose desktop [1-5] [1]: 5
❯ Install development tools? (git, vim, vscodium, etc) [Y/n]: n
❯ Install Docker? [Y/n]: y
❯ Install virtualization? (QEMU/KVM) [Y/n]: n
❯ Install Home Manager for user configuration? [Y/n]: n
```

This creates a minimal configuration with only:
- Base system (bootloader, networking, SSH)
- Docker support
- No desktop environment
- No Home Manager

## Example: Developer Workstation

For a full development setup:

```
❯ Choose desktop [1-5] [1]: 2  # KDE Plasma
❯ Install development tools? (git, vim, vscodium, etc) [Y/n]: y
❯ Install Docker? [Y/n]: y
❯ Install virtualization? (QEMU/KVM) [Y/n]: y
❯ Install Home Manager for user configuration? [Y/n]: y
```

This creates a full-featured workstation with:
- KDE Plasma desktop
- Development tools (editors, languages, utilities)
- Docker
- Virtualization (QEMU/KVM, virt-manager)
- Home Manager for user configuration

## Post-Installation

After your first successful `nixos-rebuild switch`, you can:

1. **Add more packages**
   ```nix
   # Edit hosts/desktop/configuration.nix
   environment.systemPackages = with pkgs; [
     vim
     wget
     # Add your packages here
     firefox
     thunderbird
   ];
   ```

2. **Update your system**
   ```bash
   make upgrade
   ```

3. **Clean up old generations**
   ```bash
   make clean
   ```

4. **Save to git**
   ```bash
   git init
   git add .
   git commit -m "Initial NixOS configuration"
   git remote add origin https://github.com/yourusername/nixos-config.git
   git push -u origin main
   ```

---

**That's it!** You now have a fully functional, modular, flake-based NixOS configuration that's ready to use and easy to maintain.