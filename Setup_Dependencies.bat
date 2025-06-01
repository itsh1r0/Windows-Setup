@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Restarting with Administrator Permission...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

clear
winget settings --enable InstallerHashOverride
winget install --id=Microsoft.VCRedist.2005.x86 -s winget -e
winget install --id=Microsoft.VCRedist.2005.x64 -s winget -e
winget install --id=Microsoft.VCRedist.2008.x86 -s winget -e
winget install --id=Microsoft.VCRedist.2008.x64 -s winget -e
winget install --id=Microsoft.VCRedist.2010.x86 -s winget -e
winget install --id=Microsoft.VCRedist.2010.x64 -s winget -e
winget install --id=Microsoft.VCRedist.2012.x86 -s winget -e
winget install --id=Microsoft.VCRedist.2012.x64 -s winget -e
winget install --id=Microsoft.VCRedist.2013.x86 -s winget -e
winget install --id=Microsoft.VCRedist.2013.x64 -s winget -e
winget install --id=Microsoft.VCRedist.2015+.x86 -s winget -e
winget install --id=Microsoft.VCRedist.2015+.x64 -s winget -e
winget install --id=Microsoft.DotNet.DesktopRuntime.6 -s winget -a x86 -e
winget install --id=Microsoft.DotNet.DesktopRuntime.6 -s winget -a x64 -e
winget install --id=Microsoft.DotNet.DesktopRuntime.7 -s winget -a x86 -e
winget install --id=Microsoft.DotNet.DesktopRuntime.7 -s winget -a x64 -e
winget install --id=Microsoft.DotNet.DesktopRuntime.8 -s winget -a x86 -e
winget install --id=Microsoft.DotNet.DesktopRuntime.8 -s winget -a x64 -e
winget install --id=Microsoft.DotNet.DesktopRuntime.9 -s winget -a x86 -e
winget install --id=Microsoft.DotNet.DesktopRuntime.9 -s winget -a x64 -e
winget install --id=Microsoft.EdgeWebView2Runtime -s winget -e
winget install --id=Microsoft.DirectX -s winget -e