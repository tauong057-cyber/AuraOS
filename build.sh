#!/bin/bash
# ==============================================================================
# AuraOS - Master Build Script
# Hệ điều hành tùy biến phong cách macOS siêu mượt cho VirtualBox
# ==============================================================================
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$BASE_DIR/build_tmp"
CHROOT_DIR="$WORK_DIR/chroot"
OUTPUT_DIR="$BASE_DIR/output"
CONFIG_DIR="$BASE_DIR/config"
SCRIPTS_DIR="$BASE_DIR/scripts"

echo "======================================================================"
echo "    _                         ___  ____  "
echo "   / \  _   _ _ __ __ _      / _ \/ ___| "
echo "  / _ \| | | | '__/ _\` |    | | | \___ \ "
echo " / ___ \ |_| | | | (_| |    | |_| |___) |"
echo "/_/   \_\__,_|_|  \__,_|_____\___/|____/ "
echo "                      |_____|            "
echo "  Hệ điều hành phong cách macOS siêu nhẹ cho VirtualBox (Debian 12 Base)"
echo "======================================================================"

# Kiểm tra quyền root
if [ "$(id -u)" -ne 0 ]; then
    echo "[!] Lỗi: Bạn cần chạy kịch bản này với quyền root (sudo ./build.sh)"
    exit 1
fi

# Dọn dẹp thư mục tạm trước đó
echo "[+] Khởi tạo môi trường làm việc..."
rm -rf "$WORK_DIR"
mkdir -p "$CHROOT_DIR" "$OUTPUT_DIR"

# Bước 1: Chuẩn bị công cụ
bash "$SCRIPTS_DIR/01_setup_base.sh"

# Tạo chroot cơ bản với Debian Bookworm (64-bit)
echo "[+] Đang tải và cài đặt hệ điều hành nền tảng (Debian Bookworm)..."
debootstrap --arch=amd64 bookworm "$CHROOT_DIR" http://deb.debian.org/debian/

# Bước 2: Cài đặt ứng dụng, Desktop XFCE, Office, Browser
bash "$SCRIPTS_DIR/02_install_apps.sh" "$CHROOT_DIR" "$CONFIG_DIR/packages.list"

# Bước 3: Áp dụng Theme macOS, Dock, Top Bar, Tối ưu VirtualBox
bash "$SCRIPTS_DIR/03_apply_theme.sh" "$CHROOT_DIR" "$CONFIG_DIR"

# Bước 4: Đóng gói thành file ISO bootable
bash "$SCRIPTS_DIR/04_pack_iso.sh" "$CHROOT_DIR" "$WORK_DIR" "$OUTPUT_DIR"

echo ""
echo "[✓] Quá trình đóng gói hoàn tất 100%!"
echo "[✓] File ISO sẵn sàng để nạp vào VirtualBox: $OUTPUT_DIR/AuraOS-v1.0-x86_64.iso"
