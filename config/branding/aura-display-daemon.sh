#!/bin/bash
# ==============================================================================
# AuraOS Display & VirtualBox Auto-Resize Daemon
# Tự động phóng to toàn màn hình, nhận diện độ phân giải máy ảo và kích hoạt clipboard
# ==============================================================================

# Khởi động dịch vụ VirtualBox Client
if command -v VBoxClient-all >/dev/null 2>&1; then
    VBoxClient-all &
else
    VBoxClient --clipboard &
    VBoxClient --draganddrop &
    VBoxClient --seamless &
    VBoxClient --vmsvga &
    VBoxClient --display &
fi

# SPICE agent (nếu chạy trên QEMU/KVM)
if command -v spice-vdagent >/dev/null 2>&1; then
    spice-vdagent &
fi

# Tự động dò và đặt độ phân giải tối ưu nhất
xrandr --auto

# Khởi động Network Manager Applet nếu chưa chạy
if ! pgrep -x "nm-applet" > /dev/null; then
    nm-applet --indicator &
fi

# Thiết lập hình nền 4K AuraOS
if [ -f /usr/share/backgrounds/auraos/wallpaper.svg ]; then
    feh --bg-fill /usr/share/backgrounds/auraos/wallpaper.svg 2>/dev/null || xfdesktop --reload &
fi
