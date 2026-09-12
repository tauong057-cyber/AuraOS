# ==============================================================================
# Script hỗ trợ tạo file ISO AuraOS trên môi trường Windows
# ==============================================================================

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "           AuraOS - Trình Hỗ Trợ Tạo File ISO Bootable               " -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Do file ISO của một hệ điều hành Linux cần nhân Linux (Kernel, chroot, squashfs)" -ForegroundColor Yellow
Write-Host "để nén và đóng gói, bạn có các cách sau để tạo ra file ISO hoàn chỉnh:" -ForegroundColor Yellow
Write-Host ""

Write-Host "[1] Tự động cài đặt WSL (Ubuntu) để build ISO trực tiếp trên máy này" -ForegroundColor White
Write-Host "[2] Build ISO trực tuyến miễn phí bằng GitHub Actions (Không tốn RAM máy)" -ForegroundColor White
Write-Host "[3] Tải một bản ISO Linux phong cách macOS có sẵn (khởi động được ngay)" -ForegroundColor White
Write-Host "[4] Thoát" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "Vui lòng nhập lựa chọn của bạn (1, 2, hoặc 3)"

switch ($choice) {
    "1" {
        Write-Host "`n[+] Đang chạy lệnh kích hoạt WSL Ubuntu trên Windows..." -ForegroundColor Green
        wsl --install -d Ubuntu
        Write-Host "`n[✓] Sau khi Windows cài đặt xong WSL, bạn chỉ cần mở terminal Ubuntu và chạy:" -ForegroundColor Cyan
        Write-Host "    cd /mnt/c/Users/User/Desktop/VPN" -ForegroundColor Yellow
        Write-Host "    sudo bash build.sh" -ForegroundColor Yellow
    }
    "2" {
        Write-Host "`n[✓] Dự án đã được tạo sẵn file GitHub Actions tại .github/workflows/build-iso.yml" -ForegroundColor Green
        Write-Host "Bạn chỉ cần push thư mục này lên GitHub (Private hoặc Public repo)." -ForegroundColor Cyan
        Write-Host "GitHub sẽ tự động build file ISO và cho bạn tải về ở mục Actions -> Artifacts hoàn toàn miễn phí!" -ForegroundColor Green
    }
    "3" {
        Write-Host "`n[+] Đang mở trang tải bản ISO mẫu phong cách macOS nhẹ mượt..." -ForegroundColor Green
        Start-Process "https://sourceforge.net/projects/twisteros/files/"
    }
    default {
        Write-Host "Đã hủy thao tác."
    }
}
