$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $IsAdmin) {
    Write-Host "Restart Wit" -ForegroundColor Red
    Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

New-Item -ItemType Directory -Path "$env:USERPROFILE\Downloads\Winget" -Force

$wingetBaseUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/"
$wingetFile = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$wingetdepend = "DesktopAppInstaller_Dependencies.zip"
Invoke-WebRequest -Uri ($wingetBaseUrl + $wingetFile) -OutFile "$env:USERPROFILE\Downloads\Winget\Winget.msixbundle"
Invoke-WebRequest -Uri ($wingetBaseUrl + $wingetdepend) -OutFile "$env:USERPROFILE\Downloads\Winget\dependencies.zip"

Expand-Archive -Path "$env:USERPROFILE\Downloads\Winget\dependencies.zip" -DestinationPath "$env:USERPROFILE\Downloads\Winget\Dependencies" -Force

$arch = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
Write-Host "Detected architecture: $arch" -ForegroundColor Cyan

$basePath = "$env:USERPROFILE\Downloads\Winget\Dependencies"

if ($arch -match "64-bit") {
    Write-Host "Installing x86 .appx packages..." -ForegroundColor Yellow
    Get-ChildItem "$basePath\x86\*.appx" | ForEach-Object {
        Add-AppxPackage -Path $_.FullName
    }
    Write-Host "Installing x64 .appx packages..." -ForegroundColor Yellow
    Get-ChildItem "$basePath\x64\*.appx" | ForEach-Object {
        Add-AppxPackage -Path $_.FullName
    }
} elseif ($arch -match "32-bit") {
    Write-Host "Installing x86 .appx packages..." -ForegroundColor Yellow
    Get-ChildItem "$basePath\x86\*.appx" | ForEach-Object {
        Add-AppxPackage -Path $_.FullName
    }
} else {
    Write-Host "Installing arm64 .appx packages..." -ForegroundColor Yellow
    Get-ChildItem "$basePath\arm64\*.appx" | ForEach-Object {
        Add-AppxPackage -Path $_.FullName
    }
}

Add-AppxPackage -Path "$env:USERPROFILE\Downloads\Winget\Winget.msixbundle" -ForceUpdateFromAnyVersion
Remove-Item -Path "$env:USERPROFILE\Downloads\Winget" -Recurse -Force
