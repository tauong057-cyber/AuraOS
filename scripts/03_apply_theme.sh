#!/bin/bash
set -euo pipefail

CHROOT_DIR="$1"
CONFIG_DIR="$2"

echo "============================================================"
echo " [AuraOS Builder] Bước 3: Áp dụng giao diện macOS WhiteSur"
echo "============================================================"

# Mount các thư mục cần thiết
mount --bind /dev "$CHROOT_DIR/dev"
mount --bind /proc "$CHROOT_DIR/proc"
mount --bind /sys "$CHROOT_DIR/sys"

# Sao chép các tệp cấu hình vào hệ thống chroot
mkdir -p "$CHROOT_DIR/etc/auraos"
cp -r "$CONFIG_DIR/branding/"* "$CHROOT_DIR/etc/auraos/" 2>/dev/null || true
cp "$CONFIG_DIR/picom-glass.conf" "$CHROOT_DIR/etc/auraos/picom.conf"
cp "$CONFIG_DIR/rofi-spotlight/spotlight.rasi" "$CHROOT_DIR/etc/auraos/spotlight.rasi"
cp "$CONFIG_DIR/plank-macos/dock.theme" "$CHROOT_DIR/etc/auraos/dock.theme"

# Cài đặt daemon tự động full màn hình và mạng
mkdir -p "$CHROOT_DIR/usr/local/bin"
cp "$CONFIG_DIR/branding/aura-display-daemon.sh" "$CHROOT_DIR/usr/local/bin/aura-display-daemon.sh"
chmod +x "$CHROOT_DIR/usr/local/bin/aura-display-daemon.sh"

# Sao chép /etc/skel để mọi user mới tạo đều có trọn bộ giao diện macOS
mkdir -p "$CHROOT_DIR/etc/skel"
cp -r "$CONFIG_DIR/skel/." "$CHROOT_DIR/etc/skel/"

# Tạo thư mục theme và cài đặt hình nền 4K
mkdir -p "$CHROOT_DIR/usr/share/themes"
mkdir -p "$CHROOT_DIR/usr/share/backgrounds/auraos"
cp "$CONFIG_DIR/branding/aura-wallpaper.svg" "$CHROOT_DIR/usr/share/backgrounds/auraos/wallpaper.svg"

# Tinh chỉnh bên trong chroot
chroot "$CHROOT_DIR" /bin/bash -c '
    # Đặt hostname
    echo "auraos" > /etc/hostname
    cat <<EOF > /etc/hosts
127.0.0.1   localhost
127.0.1.1   auraos
EOF

    # Cấu hình DNS mặc định (Google & Cloudflare)
    cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

    # Tạo user mặc định: aura / mật khẩu: aura
    if ! id -u aura >/dev/null 2>&1; then
        useradd -m -s /bin/bash -G sudo,audio,video,plugdev,netdev aura
        echo "aura:aura" | chpasswd
        echo "root:root" | chpasswd
        echo "aura ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    fi

    # Sao chép skel sang thư mục người dùng aura
    cp -r /etc/skel/. /home/aura/
    chown -R aura:aura /home/aura/

    # Cấu hình LightDM tự động đăng nhập vào desktop
    mkdir -p /etc/lightdm/lightdm.conf.d
    cat <<EOF > /etc/lightdm/lightdm.conf.d/autologin.conf
[Seat:*]
autologin-user=aura
autologin-user-timeout=0
user-session=xfce
EOF

    # Bật dịch vụ NetworkManager, VirtualBox Guest và LightDM
    systemctl enable NetworkManager || true
    systemctl enable lightdm || true
    systemctl enable virtualbox-guest-utils || true
'

# Unmount
umount "$CHROOT_DIR/sys" || true
umount "$CHROOT_DIR/proc" || true
umount "$CHROOT_DIR/dev" || true

echo "[✓] Đã cấu hình hoàn tất giao diện macOS, full màn hình và mạng wifi!"
