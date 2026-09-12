#!/bin/bash
set -euo pipefail

CHROOT_DIR="$1"
PACKAGES_FILE="$2"

echo "============================================================"
echo " [AuraOS Builder] Bước 2: Cài đặt Desktop, Office & Apps"
echo "============================================================"

# Đọc danh sách gói từ packages.list (bỏ qua comment và dòng trống)
PACKAGE_LIST=$(grep -v '^#' "$PACKAGES_FILE" | grep -v '^[[:space:]]*$' | tr '\n' ' ')

echo "[+] Đang cài đặt các ứng dụng và môi trường XFCE siêu nhẹ..."

# Mount ảo vào chroot
mount --bind /dev "$CHROOT_DIR/dev"
mount --bind /dev/pts "$CHROOT_DIR/dev/pts"
mount --bind /proc "$CHROOT_DIR/proc"
mount --bind /sys "$CHROOT_DIR/sys"

# Chạy apt bên trong chroot
chroot "$CHROOT_DIR" /bin/bash -c "
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y --no-install-recommends $PACKAGE_LIST
    apt-get clean
    rm -rf /var/lib/apt/lists/*
"

# Unmount
umount "$CHROOT_DIR/sys" || true
umount "$CHROOT_DIR/proc" || true
umount "$CHROOT_DIR/dev/pts" || true
umount "$CHROOT_DIR/dev" || true

echo "[✓] Đã cài đặt xong toàn bộ gói phần mềm cho AuraOS!"
