@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Restart With Administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

set "ARCH=x64"
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" (
    if not defined PROCESSOR_ARCHITEW6432 (
        set "ARCH=x86"
    )
)
echo Arch: %ARCH%

echo Downloading PowerShell...
powershell -Command ^
    "$arch = '%ARCH%';" ^
    "$pattern = if ($arch -eq 'x64') {'PowerShell-*win-x64.msi'} else {'PowerShell-*win-x86.msi'};" ^
    "$url = Invoke-RestMethod 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest' | Select-Object -ExpandProperty assets | Where-Object { $_.name -like $pattern } | Select-Object -ExpandProperty browser_download_url;" ^
    "Invoke-WebRequest -Uri $url -OutFile '%TEMP%\PowerShell-latest.msi'"

msiexec /i "%TEMP%\PowerShell-latest.msi" /qn
del "%TEMP%\PowerShell-latest.msi"