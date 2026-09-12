# ==============================================================================
# Script tu dong tao va cau hinh May ao VirtualBox cho AuraOS (macOS Style)
# ==============================================================================

param (
    [string]$VmName = "AuraOS-MacStyle",
    [string]$IsoPath = "",
    [int]$RamMB = 2048,
    [int]$CpuCores = 2,
    [int]$DiskSizeMB = 25000
)

# 1. Tim duong dan VBoxManage.exe
$vboxPaths = @(
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe",
    "C:\Program Files (x86)\Oracle\VirtualBox\VBoxManage.exe",
    "$env:VBOX_MSI_INSTALL_PATH\VBoxManage.exe",
    "$env:VBOX_INSTALL_PATH\VBoxManage.exe"
)

$vbox = $null
foreach ($p in $vboxPaths) {
    if (Test-Path $p) {
        $vbox = $p
        break
    }
}

if (-not $vbox) {
    Write-Host "[!] Khong tim thay VirtualBox tren may tinh." -ForegroundColor Red
    Write-Host "    Vui long cai dat Oracle VM VirtualBox tai: https://www.virtualbox.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " [AuraOS] Khoi tao May ao VirtualBox toi uu cho AuraOS" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan

# Kiem tra neu VM da ton tai
$existingVMs = & $vbox list vms
if ($existingVMs -match """$VmName""") {
    Write-Host "[i] May ao '$VmName' da ton tai trong VirtualBox." -ForegroundColor Yellow
} else {
    Write-Host "[+] Tao may ao '$VmName'..." -ForegroundColor Yellow
    & $vbox createvm --name $VmName --ostype "Debian_64" --register

    Write-Host "[+] Thiet lap CPU, RAM, Card do hoa VBoxSVGA..." -ForegroundColor Yellow
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

    Write-Host "[+] Tao bo dieu khien o dia..." -ForegroundColor Yellow
    & $vbox storagectl $VmName --name "SATA Controller" --add sata --controller IntelAhci --bootable on
    & $vbox storagectl $VmName --name "IDE Controller" --add ide

    $vmInfo = & $vbox showvminfo $VmName --machinereadable | Select-String "CfgFile="
    $vmDir = Split-Path ($vmInfo -replace 'CfgFile="','' -replace '"','')
    $diskPath = Join-Path $vmDir "$VmName.vdi"

    Write-Host "[+] Tao o cung ao dung luong 25GB..." -ForegroundColor Yellow
    & $vbox createmedium disk --filename $diskPath --size $DiskSizeMB --format VDI
    & $vbox storageattach $VmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $diskPath
}

# Gan file ISO neu co
if ($IsoPath -and (Test-Path $IsoPath)) {
    $fullIsoPath = (Resolve-Path $IsoPath).Path
    Write-Host "[+] Gan file ISO: $fullIsoPath" -ForegroundColor Green
    & $vbox storageattach $VmName --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $fullIsoPath
} else {
    Write-Host "[i] Ban co the gan file ISO vao o dia trong VirtualBox sau." -ForegroundColor Magenta
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " [OK] Hoan tat! Mo VirtualBox va nhan Start de chay AuraOS." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
