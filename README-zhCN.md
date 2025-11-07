nixos/README-zhCN.md
</file_path>

<edit_description>
Create Chinese README
</edit_description>

# NixOS 交互式安装程序

[![NixOS](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

一个完整的工具，用于生成基于 flakes 的 NixOS 配置，支持多种桌面环境、开发工具、游戏、多媒体、云服务和安全强化。

## ✨ 特性

### 🎨 桌面环境
- **8 个选项**：GNOME、KDE Plasma、XFCE、Cinnamon、MATE、i3、Hyprland 或无
- 针对每个环境的优化配置

### 🛠️ 开发工具
- 编辑器：vim、neovim、VSCodium、Zed
- 编程语言：Python、Node.js、Rust、Go
- 版本控制：Git、GitHub CLI
- 实用工具：tmux、ripgrep、fzf、direnv

### 🤖 人工智能
- **aichat**：通用 AI CLI，支持 Claude、GPT、Gemini
- 壳快捷方式（`ai`、`claude`、`gpt`）
- 支持多个提供商

### 🎮 游戏
- Steam 与 Proton
- Lutris 和 Heroic Launcher
- 性能优化工具（MangoHud、GameMode）
- Vulkan 和图形驱动

### 🎨 多媒体
- 视频编辑：Kdenlive、OBS Studio
- 图像编辑：GIMP、Krita、Blender
- 音频制作：Audacity、Ardour

### ☁️ 云服务
- AWS CLI、Azure CLI、Google Cloud SDK
- Kubernetes（kubectl、Helm、k9s）
- Terraform 和 Ansible

### 🔒 安全
- 防火墙、AppArmor、fail2ban
- SSH hardening
- 防病毒（ClamAV）

## 🚀 安装

### 先决条件

- NixOS 系统（或 live 环境）
- Bash shell
- sudo 权限
- 互联网连接

### 快速安装

1. **克隆仓库：**
   ```bash
   git clone https://github.com/your-username/nixos.git
   cd nixos
   ```

2. **运行安装程序：**
   ```bash
   ./install.sh
   ```

3. **回答交互式提示：**
   - 选择您的桌面
   - 选择所需功能
   - 配置其他用户

4. **激活配置：**
   ```bash
   sudo nixos-rebuild switch --flake .#您的主机名
   ```

## 📋 文件结构

```
nixos/
├── install.sh                      # 主安装程序（英文）
├── install-ptBR.sh                 # 巴西葡萄牙语版本
├── install-zhCN.sh                 # 中文版本
├── flake.nix                       # Flake 配置（生成）
├── hosts/                          # 主机特定配置
│   └── hostname/
│       ├── configuration.nix       # 主配置
│       └── hardware-configuration.nix
├── modules/                        # 可重用模块
│   ├── system.nix                  # 基础系统
│   ├── desktop-gnome.nix           # GNOME 桌面
│   ├── development.nix             # 开发工具
│   └── ...
├── users/                          # 用户配置
│   └── username/
│       └── home.nix                # Home Manager
├── docs/                           # 文档
├── QUICKSTART.md                   # 快速开始指南
├── FEATURES.md                     # 详细特性
├── AI-TOOLS-SETUP.md              # AI 工具配置
├── CHANGELOG.md                    # 更新日志
└── README.md                       # 本文件
```

## 🎯 使用场景

### 开发工作站
```bash
# 选择：GNOME + 开发工具 + Docker + AI + 云服务
桌面：GNOME
✓ 开发工具
✓ Docker
✓ AI 工具
✓ 云服务 CLI
```

### 游戏电脑
```bash
# 选择：KDE Plasma + 游戏 + 多媒体
桌面：KDE Plasma
✓ 游戏工具
✓ 多媒体制作
✓ 开发工具
```

### 服务器
```bash
# 选择：无 + Docker + 云服务 + 安全
桌面：无
✓ Docker
✓ 云服务 CLI
✓ 安全强化
```

## 🛠️ 有用命令

```bash
# 构建并激活
make switch
# 或
sudo nixos-rebuild switch --flake .#hostname

# 测试而不持久化
make test
# 或
sudo nixos-rebuild test --flake .#hostname

# 更新软件包
make upgrade
# 或
nix flake update && sudo nixos-rebuild switch --flake .#hostname

# 清理旧版本
make clean
# 或
sudo nix-collect-garbage -d

# 验证配置
make check
# 或
nix flake check
```

## 🔧 自定义

### 添加系统软件包

编辑 `hosts/hostname/configuration.nix`：
```nix
environment.systemPackages = with pkgs; [
  vim
  wget
  # 您的软件包在这里
  firefox
  thunderbird
];
```

### 添加用户软件包

编辑 `users/username/home.nix`：
```nix
home.packages = with pkgs; [
  # 您的软件包在这里
  discord
  spotify
];
```

### 创建新模块

创建 `modules/custom.nix`：
```nix
{ config, pkgs, ... }:

{
  # 您的自定义配置在这里
}
```

然后在 `configuration.nix` 中导入。

## 🐛 故障排除

### "flake not found" 错误
```bash
cd /path/to/your/config
sudo nixos-rebuild switch --flake .#hostname
```

### 权限错误
```bash
# 将用户添加到 wheel 组
sudo usermod -aG wheel 您的用户名
```

### 回滚
```bash
# 回退到之前的世代
sudo nixos-rebuild switch --rollback
```

### 详细日志
```bash
sudo nixos-rebuild switch --flake .#hostname --show-trace
```

## 📚 其他文档

- **[QUICKSTART.md](QUICKSTART.md)** - 快速开始指南
- **[FEATURES.md](FEATURES.md)** - 详细特性
- **[AI-TOOLS-SETUP.md](AI-TOOLS-SETUP.md)** - AI 工具配置
- **[NixOS 手册](https://nixos.org/manual/nixos/stable/)** - 官方文档

## 🤝 贡献

欢迎贡献！在发送拉取请求之前，请阅读贡献指南。

### 如何贡献：

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开拉取请求

### 贡献领域：
- 新桌面环境模块
- 更多 AI 工具支持
- 安全改进
- 其他语言翻译
- 自动化测试

## 📄 许可证

本项目采用 MIT 许可证 - 请查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [NixOS Community](https://nixos.org/) - 提供了出色的操作系统
- [Home Manager](https://github.com/nix-community/home-manager) - 用户包管理
- 所有使用的开源工具和项目

## 📞 支持

- **Issues**：[GitHub Issues](https://github.com/your-username/nixos/issues)
- **Discussions**：[GitHub Discussions](https://github.com/your-username/nixos/discussions)
- **Community**：[NixOS Discourse](https://discourse.nixos.org/)

---

**快乐的 NixOS 体验！** 🚀

*由 NixOS 交互式安装程序自动生成*