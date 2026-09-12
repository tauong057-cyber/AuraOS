#!/bin/bash
set -euo pipefail

CHROOT_DIR="$1"
PACKAGES_FILE="$2"

echo "============================================================"
echo " [AuraOS Builder] Bước 2: Cài đặt Desktop, Office & Apps"
echo "============================================================"

# Cấu hình đầy đủ repositories cho Debian Bookworm (main, contrib, non-free, non-free-firmware)
cat <<EOF > "$CHROOT_DIR/etc/apt/sources.list"
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF

# Sao chép danh sách gói vào chroot
cp "$PACKAGES_FILE" "$CHROOT_DIR/tmp/packages.list"

# Tạo script cài đặt an toàn bên trong chroot
cat <<'EOF' > "$CHROOT_DIR/tmp/install_inside.sh"
#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

apt-get update -y

# Lọc bỏ comment và dòng trống
PKGS=$(grep -v '^#' /tmp/packages.list | grep -v '^[[:space:]]*$' | tr '\n' ' ')

echo "[+] Cài đặt các gói phần mềm..."
apt-get install -y --no-install-recommends $PKGS || {
    echo "[!] Một số gói gặp lỗi, đang cài đặt từng gói..."
    for p in $PKGS; do
        apt-get install -y --no-install-recommends "$p" || echo "[!] Bỏ qua gói: $p"
    done
}

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/packages.list
EOF

chmod +x "$CHROOT_DIR/tmp/install_inside.sh"

# Mount ảo vào chroot
mount --bind /dev "$CHROOT_DIR/dev"
mount --bind /dev/pts "$CHROOT_DIR/dev/pts"
mount --bind /proc "$CHROOT_DIR/proc"
mount --bind /sys "$CHROOT_DIR/sys"

# Chạy cài đặt
chroot "$CHROOT_DIR" /tmp/install_inside.sh
rm -f "$CHROOT_DIR/tmp/install_inside.sh"

# Unmount
umount "$CHROOT_DIR/sys" || true
umount "$CHROOT_DIR/proc" || true
umount "$CHROOT_DIR/dev/pts" || true
umount "$CHROOT_DIR/dev" || true

echo "[✓] Đã cài đặt xong toàn bộ gói phần mềm cho AuraOS!"
