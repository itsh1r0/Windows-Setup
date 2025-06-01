sc config UCPD start=disabled
schtasks /change /Disable /TN "\Microsoft\Windows\AppxDeploymentClient\UCPD velocity"
pause