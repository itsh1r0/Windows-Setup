if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Relaunch with Admin"
    $argList = @()

    $PSBoundParameters.GetEnumerator() | ForEach-Object {
        $argList += if ($_.Value -is [switch] -and $_.Value) {
            "-$($_.Key)"
        } elseif ($_.Value -is [array]) {
            "-$($_.Key) $($_.Value -join ',')"
        } elseif ($_.Value) {
            "-$($_.Key) '$($_.Value)'"
        }
    }

    $script = if ($PSCommandPath) {
        "& { & `'$($PSCommandPath)`' $($argList -join ' ') }"
    } else {
        "&([ScriptBlock]::Create((irm https://raw.githubusercontent.com/itsh1r0/Windows-Setup/main/WingetUpdate.ps1))) $($argList -join ' ')"
    }

    $powershellCmd = if (Get-Command pwsh -ErrorAction SilentlyContinue) { "pwsh" } else { "powershell" }
    $processCmd = if (Get-Command wt.exe -ErrorAction SilentlyContinue) { "wt.exe" } else { "$powershellCmd" }

    if ($processCmd -eq "wt.exe") {
        Start-Process $processCmd -ArgumentList "$powershellCmd -ExecutionPolicy Bypass -NoProfile -Command `"$script`"" -Verb RunAs
    } else {
        Start-Process $processCmd -ArgumentList "-ExecutionPolicy Bypass -NoProfile -Command `"$script`"" -Verb RunAs
    }

    break
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
