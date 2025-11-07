#!/usr/bin/env bash

# NixOS 交互式安装脚本
# 创建基于 flake 的完整 NixOS 配置

set -e

# 输出颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # 无颜色

# 辅助函数
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
        read -p "$(echo -e ${CYAN}❯${NC}) $prompt [Y/n]: " response
        response=${response:-y}
    else
        read -p "$(echo -e ${CYAN}❯${NC}) $prompt [y/N]: " response
        response=${response:-n}
    fi

    [[ "$response" =~ ^[Yy是]$ ]]
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
            echo -e "${RED}响应不能为空！${NC}"
            read -p "$(echo -e ${CYAN}❯${NC}) $prompt: " response
        done
        echo "$response"
    fi
}

# 检查是否以 root 身份运行
if [[ $EUID -eq 0 ]]; then
    print_error "此脚本不应以 root 身份运行"
    exit 1
fi

# 欢迎横幅
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
║           配置生成器 v3.0                               ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

print_info "此脚本将为您创建一个完整的 NixOS 配置，包括："
echo "  • Flakes 支持"
echo "  • Home Manager 集成"
echo "  • 模块化结构"
echo "  • 用户特定设置"
echo ""

if ! prompt_yes_no "继续安装？"; then
    print_info "安装已取消"
    exit 0
fi

# 获取用户信息
print_header "用户配置"

USERNAME=$(prompt_input "用户名" "$USER")
HOSTNAME=$(prompt_input "主机名" "$(hostname)")
TIMEZONE=$(prompt_input "时区" "Asia/Shanghai")
LOCALE=$(prompt_input "区域设置" "zh_CN.UTF-8")

# Git 配置
print_header "Git 配置"
USE_GIT=false
GIT_NAME=""
GIT_EMAIL=""

if prompt_yes_no "配置 Git？"; then
    USE_GIT=true
    GIT_NAME=$(prompt_input "Git 姓名" "$(git config --get user.name 2>/dev/null || echo '')")
    GIT_EMAIL=$(prompt_input "Git 邮箱" "$(git config --get user.email 2>/dev/null || echo '')")
fi

# 桌面环境
print_header "桌面环境"
echo "可用的桌面环境："
echo "  1) GNOME"
echo "  2) KDE Plasma"
echo "  3) XFCE"
echo "  4) Cinnamon"
echo "  5) MATE"
echo "  6) i3（平铺窗口管理器）"
echo "  7) Hyprland（Wayland 平铺合成器）"
echo "  8) 无（最小化/服务器）"

while true; do
    DE_CHOICE=$(prompt_input "选择桌面 [1-8]" "1")
    case $DE_CHOICE in
        1) DESKTOP="gnome"; break ;;
        2) DESKTOP="kde"; break ;;
        3) DESKTOP="xfce"; break ;;
        4) DESKTOP="cinnamon"; break ;;
        5) DESKTOP="mate"; break ;;
        6) DESKTOP="i3"; break ;;
        7) DESKTOP="hyprland"; break ;;
        8) DESKTOP="none"; break ;;
        *) print_error "无效选择。请键入 1-8。" ;;
    esac
done

# 包选择
print_header "附加功能"

INSTALL_DEV_TOOLS=false
INSTALL_DOCKER=false
INSTALL_VIRTUALIZATION=false
INSTALL_AI_TOOLS=false
INSTALL_GAMING=false
INSTALL_MULTIMEDIA=false
INSTALL_CLOUD_TOOLS=false

if prompt_yes_no "安装开发工具（git、vim、vscodium 等）？"; then
    INSTALL_DEV_TOOLS=true
fi

if prompt_yes_no "安装 Docker？"; then
    INSTALL_DOCKER=true
fi

if prompt_yes_no "安装虚拟化（QEMU/KVM）？"; then
    INSTALL_VIRTUALIZATION=true
fi

if prompt_yes_no "安装 AI 工具（Claude、Codex、Grok CLI）？"; then
    INSTALL_AI_TOOLS=true
fi

if prompt_yes_no "安装游戏工具（Steam、Proton、Lutris）？"; then
    INSTALL_GAMING=true
fi

if prompt_yes_no "安装多媒体制作（OBS、Kdenlive、GIMP、Blender）？"; then
    INSTALL_MULTIMEDIA=true
fi

if prompt_yes_no "安装云提供商 CLI（AWS、Azure、GCP）？"; then
    INSTALL_CLOUD_TOOLS=true
fi

# 安全强化
print_header "安全强化"
SECURITY_HARDENING=false

if prompt_yes_no "启用安全强化（防火墙、fail2ban、AppArmor）？"; then
    SECURITY_HARDENING=true
fi

# 其他用户
print_header "其他用户"
ADDITIONAL_USERS=()

if prompt_yes_no "创建其他用户账户？"; then
    while true; do
        ADD_USER=$(prompt_input "输入用户名（或按 Enter 完成）" "")
        if [ -z "$ADD_USER" ]; then
            break
        fi
        ADDITIONAL_USERS+=("$ADD_USER")
        print_success "已添加用户: $ADD_USER"
    done
fi

# Home Manager
print_header "Home Manager"
INSTALL_HOME_MANAGER=false

if prompt_yes_no "安装 Home Manager 进行用户包管理？"; then
    INSTALL_HOME_MANAGER=true
fi

# 确认配置
print_header "配置摘要"
echo -e "${CYAN}┌────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC} 用户名:         ${GREEN}$USERNAME${NC}"
echo -e "${CYAN}│${NC} 主机名:         ${GREEN}$HOSTNAME${NC}"
echo -e "${CYAN}│${NC} 时区:           ${GREEN}$TIMEZONE${NC}"
echo -e "${CYAN}│${NC} 区域设置:       ${GREEN}$LOCALE${NC}"
echo -e "${CYAN}│${NC} 桌面:           ${GREEN}$DESKTOP${NC}"
echo -e "${CYAN}│${NC} 开发工具:       $([ "$INSTALL_DEV_TOOLS" = true ] && echo -e "${GREEN}是${NC}" || echo -e "${RED}否${NC}")"
echo -e "${CYAN}│${NC} Docker:         $([ "$INSTALL_DOCKER" = true ] && echo -e "${GREEN}是${NC}" || echo -e "${RED}否${NC}")"
echo -e "${CYAN}│${NC} 虚拟化:         $([ "$INSTALL_VIRTUALIZATION" = true ] && echo -e "${GREEN}是${NC}" || echo -e "${RED}否${NC}")"
echo -e "${CYAN}│${NC} AI 工具:        $([ "$INSTALL_AI_TOOLS" = true ] && echo -e "${GREEN}是${NC}" || echo -e "${RED}否${NC}")"
echo -e "${CYAN}│${NC} 游戏:           $([ "$INSTALL_GAMING" = true ] && echo -e "${GREEN}是${NC}" || echo -e "${RED}否${NC}")"
echo -e "${CYAN}│${NC} 多媒体:         $([ "$INSTALL_MULTIMEDIA" = true ] && echo -e "${GREEN}是${NC}" || echo -e "${RED}否${NC}")"
echo -e "${CYAN}│${NC} 云工具:         $([ "$INSTALL_CLOUD_TOOLS" = true ] && echo -e "${GREEN}是${NC}" || echo -e "${RED}否${NC}")"
echo -e "${CYAN}│${NC} 安全:           $([ "$SECURITY_HARDENING" = true ] && echo -e "${GREEN}强化${NC}" || echo -e "${YELLOW}标准${NC}")"
echo -e "${CYAN}│${NC} 其他用户:       ${GREEN}${#ADDITIONAL_USERS[@]}${NC}"
echo -e "${CYAN}│${NC} Home Manager:    $([ "$INSTALL_HOME_MANAGER" = true ] && echo -e "${GREEN}是${NC}" || echo -e "${RED}否${NC}")"
echo -e "${CYAN}└────────────────────────────────────────┘${NC}"
echo ""

if ! prompt_yes_no "使用此配置？"; then
    print_info "安装已取消"
    exit 0
fi

print_info "开始生成配置..."
sleep 1

# 创建目录结构
print_header "创建目录结构"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR"

mkdir -p "$CONFIG_DIR"/{modules,hosts,users,overlays}
mkdir -p "$CONFIG_DIR/hosts/$HOSTNAME"
mkdir -p "$CONFIG_DIR/users/$USERNAME"
for user in "${ADDITIONAL_USERS[@]}"; do
    mkdir -p "$CONFIG_DIR/users/$user"
done
print_success "目录结构已创建"

# 生成硬件配置
print_header "硬件配置"

HARDWARE_FILE="$CONFIG_DIR/hosts/$HOSTNAME/hardware-configuration.nix"

if prompt_yes_no "生成硬件配置？（需要 sudo）" "y"; then
    if command -v nixos-generate-config &> /dev/null; then
        sudo nixos-generate-config --show-hardware-config > "$HARDWARE_FILE" 2>/dev/null || {
            print_warning "无法自动生成硬件配置"
            GENERATE_HARDWARE=false
        }
        if [ -f "$HARDWARE_FILE" ]; then
            print_success "硬件配置已生成"
            GENERATE_HARDWARE=true
        else
            GENERATE_HARDWARE=false
        fi
    else
        print_warning "未找到 nixos-generate-config"
        GENERATE_HARDWARE=false
    fi
else
    GENERATE_HARDWARE=false
fi

if [ "$GENERATE_HARDWARE" = false ]; then
    print_warning "创建硬件配置占位符"
    print_info "您必须用实际硬件配置替换此配置！"

    cat > "$HARDWARE_FILE" <<'EOF'
# 硬件配置
# 重要提示：用您的实际硬件配置替换此内容！
# 您可以使用：sudo nixos-generate-config --show-hardware-config

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # 引导配置 - 根据您的系统修改
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ]; # 更改为 "kvm-amd" 用于 AMD CPU
  boot.extraModulePackages = [ ];

  # 文件系统 - 根据您的系统修改
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos"; # 更改此处
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot"; # 更改此处
    fsType = "vfat";
  };

  # 交换 - 如果您有交换则取消注释并修改
  # swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  # CPU
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # 对于 AMD CPU，请使用：
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
EOF
    print_success "已创建 hardware-configuration.nix 占位符"
    echo ""
    print_error "⚠️  重要提示：请用您的实际硬件配置编辑 $HARDWARE_FILE！"
    echo ""
fi

# 生成配置文件...
print_info "基本配置创建成功！"
print_info "运行：sudo nixos-rebuild switch --flake .#$HOSTNAME"
```
