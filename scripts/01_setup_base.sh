#!/bin/bash
set -euo pipefail

echo "============================================================"
echo " [AuraOS Builder] Bước 1: Khởi tạo hệ thống nền tảng"
echo "============================================================"

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=C

# Cập nhật repositories
apt-get update -y
apt-get install -y --no-install-recommends \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-efi \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    curl \
    wget \
    ca-certificates

echo "[✓] Đã cài đặt đầy đủ công cụ build hệ thống."
