# 🍎 AuraOS - Hệ điều hành phong cách macOS siêu nhẹ cho VirtualBox

**AuraOS** là một bản phân phối hệ điều hành tùy biến tối ưu hóa cao, mang giao diện đồ họa sang trọng chuẩn phong cách **macOS (Tahoe/Ventura/Big Sur)** nhưng có mức tiêu thụ tài nguyên cực kỳ khiêm tốn (**< 500MB RAM khi chạy**), không giật lag và tương thích hoàn hảo với **Oracle VM VirtualBox**.

---

## ✨ Điểm nổi bật của AuraOS

- 🌟 **Giao diện chuẩn macOS**: Top Bar hệ thống thanh lịch, Dock phía dưới có hiệu ứng phóng to (magnification), nút điều khiển cửa sổ Traffic Lights (Đỏ/Vàng/Xanh) bên trái.
- ⚡ **Spotlight Search**: Bấm `Super + Space` (hoặc `Alt + Space`) để tìm kiếm nhanh ứng dụng, tập tin và công cụ.
- 📁 **Finder**: Trình quản lý tệp tin đồ họa Thunar tùy biến giao diện thanh bên Favorites phong cách macOS.
- 💼 **Bộ văn phòng đầy đủ**: Tích hợp LibreOffice (Writer soạn thảo văn bản, Calc bảng tính, Impress trình chiếu) với bộ biểu tượng phong cách hiện đại.
- 🌐 **Kết nối Internet & Trình duyệt**: Hỗ trợ NetworkManager tự động nhận diện mạng LAN/Wi-Fi của VirtualBox, trình duyệt Chromium tối ưu tốc độ cao.
- 🖥 **Tối ưu hóa máy ảo VirtualBox**: Tích hợp sẵn VirtualBox Guest Additions — tự động căn chỉnh độ phân giải màn hình khi phóng to cửa sổ, chia sẻ Clipboard và kéo thả tệp tin.

---

## 🛠 Hướng dẫn Build file ISO Bootable

### Cách 1: Build bằng Docker từ Windows / Linux / macOS (Khuyên dùng)

Bạn không cần cài đặt Linux thật, chỉ cần chạy qua Docker:

```bash
# 1. Build Docker image chứa công cụ build
docker build -t auraos-builder .

# 2. Chạy container để tạo file ISO vào thư mục output/
docker run --privileged -v ${PWD}/output:/auraos/output auraos-builder
```

Sau khi chạy xong, file `output/AuraOS-v1.0-x86_64.iso` sẽ sẵn sàng.

---

### Cách 2: Build trực tiếp trên Ubuntu / Debian / WSL2

```bash
# Cấp quyền thực thi và chạy script build
sudo bash build.sh
```

---

## 💻 Khởi chạy trên VirtualBox

- **Cách tự động**: Mở PowerShell trên Windows và chạy `.\virtualbox\create_vm.ps1`.
- **Cách thủ công**: Xem hướng dẫn tại [virtualbox/README_SETUP.md](file:///c:/Users/User/Desktop/VPN/virtualbox/README_SETUP.md).

---

## 🔑 Thông tin đăng nhập mặc định

- **Người dùng mặc định**: `aura`
- **Mật khẩu**: `aura` (Tự động đăng nhập vào Desktop không cần gõ mật khẩu)
- **Quyền Quản trị (sudo)**: Miễn phí mật khẩu (`sudo su`)
