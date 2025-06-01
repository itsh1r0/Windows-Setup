@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Restart With Administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

where pwsh >nul 2>&1 || (
    call "%~dp0Script/PWSHInstall.bat"
)

pwsh -ExecutionPolicy Bypass -File "%~dp0Script/WingetUpdate.ps1"