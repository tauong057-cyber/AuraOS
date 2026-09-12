#!/bin/bash
set -euo pipefail

CHROOT_DIR="$1"
WORK_DIR="$2"
OUTPUT_DIR="$3"

echo "============================================================"
echo " [AuraOS Builder] Bước 4: Đóng gói Bootable ISO"
echo "============================================================"

ISO_DIR="$WORK_DIR/iso"
mkdir -p "$ISO_DIR/live"
mkdir -p "$ISO_DIR/boot/grub"
mkdir -p "$OUTPUT_DIR"

# 1. Trích xuất Kernel và Initramfs từ chroot sang thư mục boot của ISO
echo "[+] Trích xuất Kernel và Initrd..."
KERNEL=$(ls -1 "$CHROOT_DIR/boot/vmlinuz-"* | head -n 1)
INITRD=$(ls -1 "$CHROOT_DIR/boot/initrd.img-"* | head -n 1)

cp "$KERNEL" "$ISO_DIR/live/vmlinuz"
cp "$INITRD" "$ISO_DIR/live/initrd"

# 2. Nén hệ thống tệp chroot thành filesystem.squashfs
echo "[+] Đang nén hệ thống tệp tối ưu (SquashFS xz siêu nhẹ)..."
mksquashfs "$CHROOT_DIR" "$ISO_DIR/live/filesystem.squashfs" -comp xz -e boot

# 3. Tạo cấu hình menu boot GRUB
echo "[+] Cấu hình GRUB Bootloader..."
cat <<'EOF' > "$ISO_DIR/boot/grub/grub.cfg"
set default="0"
set timeout=5

insmod font
if loadfont /boot/grub/font.pf2 ; then
  insmod gfxterm
  set gfxmode=auto
  terminal_output gfxterm
fi

set menu_color_normal=white/black
set menu_color_highlight=cyan/black

menuentry "AuraOS 1.0 (Live macOS Desktop)" --class gnu-linux --class os {
    linux /live/vmlinuz boot=live quiet splash components
    initrd /live/initrd
}

menuentry "AuraOS 1.0 (Safe Graphics Mode)" --class gnu-linux --class os {
    linux /live/vmlinuz boot=live nomodeset quiet splash components
    initrd /live/initrd
}

menuentry "AuraOS 1.0 (RAM Mode - Copy toàn bộ vào RAM)" --class gnu-linux --class os {
    linux /live/vmlinuz boot=live toram quiet splash components
    initrd /live/initrd
}
EOF

# 4. Đóng gói file ISO Hybrid Bootable
ISO_NAME="AuraOS-v1.0-x86_64.iso"
echo "[+] Đang tạo file ISO: $OUTPUT_DIR/$ISO_NAME..."

grub-mkrescue -o "$OUTPUT_DIR/$ISO_NAME" "$ISO_DIR" -- -volid "AURAOS_1_0"

echo "============================================================"
echo " [✓] THÀNH CÔNG: File ISO đã được tạo tại:"
echo "     $OUTPUT_DIR/$ISO_NAME"
echo "============================================================"
