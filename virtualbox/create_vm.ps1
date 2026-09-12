# ==============================================================================
# Script tự động tạo và cấu hình Máy ảo VirtualBox tối ưu cho AuraOS (macOS Style)
# ==============================================================================

param (
    [string]$VmName = "AuraOS-MacStyle",
    [string]$IsoPath = "..\output\AuraOS-v1.0-x86_64.iso",
    [int]$RamMB = 2048,
    [int]$CpuCores = 2,
    [int]$DiskSizeMB = 25000
)

# 1. Tìm đường dẫn VBoxManage.exe
$vboxPaths = @(
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe",
    "C:\Program Files (x86)\Oracle\VirtualBox\VBoxManage.exe",
    "$env:VBOX_MSI_INSTALL_PATH\VBoxManage.exe",
    "$env:VBOX_INSTALL_PATH\VBoxManage.exe"
)

$vbox = $null
foreach ($path in $vboxPaths) {
    if (Test-Path $path) {
        $vbox = $path
        break
    }
}

if (-not $vbox) {
    Write-Error "[!] Không tìm thấy VirtualBox trên máy tính của bạn. Vui lòng cài đặt Oracle VM VirtualBox trước!"
    exit 1
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " [AuraOS] Khởi tạo Máy ảo VirtualBox tối ưu cho AuraOS" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan

# 2. Tạo máy ảo
Write-Host "[+] Tạo máy ảo '$VmName'..." -ForegroundColor Yellow
& $vbox createvm --name $VmName --ostype "Debian_64" --register

# 3. Cấu hình phần cứng tối ưu cho giao diện mượt mà (3D, 128MB VRAM, 2 CPU, 2GB RAM)
Write-Host "[+] Thiết lập CPU, RAM, Card đồ họa VBoxSVGA và Chia sẻ Clipboard..." -ForegroundColor Yellow
& $vbox modifyvm $VmName `
    --cpus $CpuCores `
    --memory $RamMB `
    --vram 128 `
    --graphicscontroller vboxsvga `
    --accelerate3d on `
    --clipboard-mode bidirectional `
    --draganddrop bidirectional `
    --audio-controller hda `
    --nic1 nat `
    --nictype1 82540EM `
    --boot1 dvd --boot2 disk --boot3 none --boot4 none

# 4. Tạo bộ điều khiển ổ cứng và DVD
Write-Host "[+] Tạo ổ đĩa ảo và gắn kết nối..." -ForegroundColor Yellow
& $vbox storagectl $VmName --name "SATA Controller" --add sata --controller IntelAhci --bootable on
& $vbox storagectl $VmName --name "IDE Controller" --add ide

# Tạo ổ đĩa cứng ảo VDI
$vmInfo = & $vbox showvminfo $VmName --machinereadable | Select-String "CfgFile="
$vmDir = Split-Path ($vmInfo -replace 'CfgFile="','' -replace '"','')
$diskPath = Join-Path $vmDir "$VmName.vdi"

Write-Host "[+] Tạo ổ cứng ảo dung lượng 25GB tại: $diskPath..." -ForegroundColor Yellow
& $vbox createmedium disk --filename $diskPath --size $DiskSizeMB --format VDI
& $vbox storageattach $VmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $diskPath

# 5. Gắn file ISO nếu tồn tại
if (Test-Path $IsoPath) {
    $fullIsoPath = (Resolve-Path $IsoPath).Path
    Write-Host "[+] Gắn file ISO AuraOS: $fullIsoPath" -ForegroundColor Green
    & $vbox storageattach $VmName --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $fullIsoPath
} else {
    Write-Host "[i] Chưa tìm thấy file ISO tại '$IsoPath'. Bạn có thể tự gắn ISO vào ổ đĩa sau khi build xong." -ForegroundColor Magenta
    & $vbox storageattach $VmName --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium emptydrive
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " [✓] HOÀN TẤT! Máy ảo '$VmName' đã sẵn sàng trong VirtualBox!" -ForegroundColor Green
Write-Host " Bạn chỉ cần mở VirtualBox và nhấn Start để trải nghiệm AuraOS." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
