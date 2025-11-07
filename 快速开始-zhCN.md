<file_path>
nixos/快速开始-zhCN.md
</file_path>

<edit_description>
Create Chinese quickstart guide
</edit_description>

# NixOS 交互式安装程序 - 快速开始指南

## 🚀 快速安装

运行交互式安装程序，为您创建一个完整的 NixOS 配置：

```bash
./install.sh
```

该安装程序将指导您完成具有交互式提示的配置过程。

## 📋 它能做什么？

该安装程序创建一个完整的基于 flakes 的 NixOS 配置，包括：

- ✅ Flakes 支持
- ✅ Home Manager 集成
- ✅ 模块化结构
- ✅ 用户特定设置
- ✅ 桌面环境（GNOME、KDE Plasma、XFCE、Cinnamon、MATE、i3、Hyprland 或无）
- ✅ 开发工具（git、vim、vscodium、zed-editor 等）
- ✅ Docker 完整支持
- ✅ 虚拟化（QEMU/KVM）
- ✅ AI CLI 工具（Claude、GPT、Grok via aichat）
- ✅ 游戏设置（Steam、Lutris、Proton）
- ✅ 多媒体制作（OBS、Kdenlive、GIMP、Blender）
- ✅ 云提供商 CLI（AWS、Azure、GCP、Kubernetes）
- ✅ 安全强化（防火墙、AppArmor、SSH hardening）
- ✅ 多用户支持

## 🔧 安装步骤

### 1. 运行安装程序

```bash
cd nixos
./install.sh
```

### 2. 回答交互式提示

安装程序将询问：

**用户配置：**
- 用户名（默认：当前用户）
- 主机名（默认：系统主机名）
- 时区（默认：Asia/Shanghai）
- 区域设置（默认：zh_CN.UTF-8）

**Git：**
- 配置 Git（姓名和邮箱）

**桌面环境：**
- 从 8 个选项中选择

**附加功能：**
- 开发工具
- Docker
- 虚拟化
- AI 工具
- 游戏
- 多媒体
- 云工具
- 安全强化
- 其他用户

### 3. 查看生成的配置

安装程序创建：

```
nixos/
├── flake.nix                    # 主配置
├── hosts/
│   └── 您的主机名/
│       ├── configuration.nix    # 系统配置
│       └── hardware-configuration.nix
├── modules/                     # 可重用模块
│   ├── system.nix              # 基础系统
│   ├── desktop-*.nix           # 桌面环境（如果选择）
│   ├── development.nix         # 开发工具（如果选择）
│   ├── docker.nix             # Docker（如果选择）
│   └── ...
└── users/
    └── 您的用户名/
        └── home.nix            # Home Manager 配置
```

### 4. 构建和激活

```bash
cd nixos
sudo nixos-rebuild switch --flake .#您的主机名
```

### 5. 重启（可选）

为确保所有更改完全应用：

```bash
sudo reboot
```

## 包含什么？

### 始终（基础）

- 基本系统实用工具（vim、wget、curl、git、htop）
- NetworkManager
- PipeWire（音频）
- Zsh with Oh-My-Zsh
- SSH 已启用

### 桌面环境（如果选择）

- **GNOME**：现代桌面环境，包含 GNOME Tweaks 和扩展
- **KDE Plasma**：功能丰富的桌面环境
- **XFCE**：轻量级传统桌面
- **Cinnamon**：优雅熟悉的界面
- **MATE**：经典 GNOME 2 体验
- **i3**：平铺窗口管理器
- **Hyprland**：现代 Wayland 合成器
- **无**：最小化/服务器

### 开发工具（如果选择）

- 编辑器：vim、neovim、VSCodium、Zed
- 版本控制：git、gh、lazygit
- 构建工具：gcc、make、cmake
- 编程语言：Python、Node.js、Rust、Go
- 实用工具：tmux、ripgrep、fd、bat、eza、fzf

### Docker（如果选择）

- Docker 守护程序，自启动
- 每周自动清理
- docker-compose
- lazydocker

### 虚拟化（如果选择）

- libvirtd 与 QEMU/KVM
- Virt-manager GUI
- OVMF 用于 UEFI

### AI 工具（如果选择）

- **aichat** - 通用 AI CLI，支持 Claude、GPT、Gemini
- Python 环境用于 Anthropic API
- Node.js 用于各种 AI CLI
- jq 和 curl 用于 API 交互

### 游戏（如果选择）

- Steam 与远程播放
- Lutris 和 Heroic Launcher
- 性能工具（MangoHud、GameMode）
- Vulkan 和图形驱动

### 多媒体（如果选择）

- 视频编辑：Kdenlive、Shotcut、DaVinci Resolve
- 屏幕录制：OBS Studio
- 图像编辑：GIMP、Krita、Inkscape
- 3D：Blender
- 音频：Audacity、Ardour

### 云工具（如果选择）

- AWS：CLI、SAM、SSM
- Azure：完整 CLI
- GCP：完整 SDK
- Kubernetes：kubectl、helm、k9s

### 安全强化（如果选择）

- 防火墙已配置
- AppArmor 已启用
- SSH hardening
- fail2ban 用于防暴力攻击

## 日常使用

### 更新系统软件包

```bash
nix flake update
sudo nixos-rebuild switch --flake .#您的主机名
```

### 添加新软件包

**系统范围**（编辑 `hosts/您的主机名/configuration.nix`）：
```nix
environment.systemPackages = with pkgs; [
  vim
  wget
  # 您的包在这里
  firefox
];
```

**用户级**（编辑 `users/您的用户名/home.nix`）：
```nix
home.packages = with pkgs; [
  # 您的包在这里
  discord
];
```

然后重建：
```bash
sudo nixos-rebuild switch --flake .#您的主机名
```

### 回滚更改

如果出现问题：
```bash
sudo nixos-rebuild switch --rollback
```

### 清理旧版本

```bash
sudo nix-collect-garbage -d
```

## 故障排除

### 检查错误

```bash
nix flake check
```

### 详细日志

```bash
sudo nixos-rebuild switch --flake .#您的主机名 --show-trace
```

### 测试而不提交

```bash
sudo nixos-rebuild test --flake .#您的主机名
```

## 下一步

1. **自定义**：编辑配置文件以添加您喜欢的包
2. **备份**：将您的配置提交到 git
3. **同步**：推送到 GitHub/GitLab 进行备份和分享
4. **学习**：阅读 [NixOS 手册](https://nixos.org/manual/nixos/stable/)

## 帮助

- 配置示例：查看 `*.example` 文件
- 完整文档：查看 `README.md`
- 搜索包：https://search.nixos.org/
- 寻求帮助：https://discourse.nixos.org/

---

**注意**：第一次构建可能需要 10-30 分钟，因为 Nix 会下载和构建包。后续构建会快得多，这要归功于 Nix 的缓存。