# Hướng dẫn tạo & chạy AuraOS trên VirtualBox

Tài liệu này hướng dẫn bạn cách khởi chạy và trải nghiệm **AuraOS** trên VirtualBox với hiệu năng mượt mà nhất.

---

## 🚀 Cách 1: Tự động tạo máy ảo bằng PowerShell (Khuyên dùng - 5 giây)

1. Mở **PowerShell** trên Windows.
2. Di chuyển đến thư mục `virtualbox`:
   ```powershell
   cd c:\Users\User\Desktop\VPN\virtualbox
   ```
3. Chạy lệnh:
   ```powershell
   .\create_vm.ps1
   ```
   *Script sẽ tự động tạo máy ảo `AuraOS-MacStyle`, kích hoạt 3D Acceleration, cấp 2GB RAM, 2 CPU, bật chia sẻ Clipboard 2 chiều và gắn ổ đĩa.*
4. Mở **Oracle VM VirtualBox** và nhấn nút **Start (Khởi động)**.

---

## 🛠 Cách 2: Tạo máy ảo thủ công trong VirtualBox

Nếu bạn muốn tự tay thiết lập cấu hình:

1. Mở VirtualBox -> Chọn **New**:
   - **Name**: `AuraOS`
   - **Type**: `Linux`
   - **Version**: `Debian (64-bit)`
2. **Hardware (Phần cứng)**:
   - **Base Memory (RAM)**: `2048 MB` (hoặc tối thiểu 1024 MB).
   - **Processors (CPU)**: `2 CPUs`.
3. **Display (Hiển thị)**:
   - **Video Memory**: Kéo lên tối đa `128 MB`.
   - **Graphics Controller**: Chọn `VBoxSVGA`.
   - **Enable 3D Acceleration**: ✅ Tích chọn (để hiệu ứng trong suốt mượt mà).
4. **Storage (Lưu trữ)**:
   - Tại mục **Controller: IDE** -> Nhấp vào biểu tượng đĩa CD -> Chọn **Choose a disk file...** -> Chọn file `AuraOS-v1.0-x86_64.iso`.
5. **General -> Advanced**:
   - **Shared Clipboard**: `Bidirectional` (Hai chiều).
   - **Drag'n'Drop**: `Bidirectional` (Hai chiều).

---

## 🍎 Trải nghiệm người dùng trên AuraOS

| Tính năng | Phím tắt / Vị trí | Mô tả |
| :--- | :--- | :--- |
| **Spotlight Search** | `Super + Space` hoặc `Alt + Space` | Tìm kiếm nhanh ứng dụng, tài liệu, công thức toán |
| **Finder** | Icon đầu tiên trên Dock | Trình quản lý tệp tin đồ họa phong cách macOS |
| **Terminal macOS** | Icon Terminal hoặc `Super + T` | Giao diện dòng lệnh tối trong suốt |
| **Office Suite** | Icon Writer / Calc trên Dock | Soạn thảo văn bản Word, bảng tính Excel |
| **Web Browser** | Icon Trình duyệt trên Dock | Lướt web, xem video tốc độ cao |
| **Tài khoản mặc định** | `aura` / Mật khẩu: `aura` | Tự động đăng nhập vào desktop khi bật máy |
