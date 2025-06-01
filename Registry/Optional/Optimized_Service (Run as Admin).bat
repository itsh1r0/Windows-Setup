net stop InstallService
sc config InstallService start=demand
net stop esifsvc
sc config esifsvc start=disabled
net stop jhi_service
sc config jhi_service start=disabled
net stop lfsvc
sc config lfsvc start=disabled
net stop DPS
sc config DPS start=disabled
net stop DusmSvc
sc config DusmSvc start=disabled
net stop BDESVC
sc config BDESVC start=demand
net stop NahimicService
sc config NahimicService start=disabled
net stop TermService
sc config TermService start=disabled
net stop RmSvc
sc config RmSvc start=disabled
net stop RtkAudioUniversalService
sc config RtkAudioUniversalService start=demand
net stop LicenseManager
sc config LicenseManager start=demand
net stop WSearch
sc config WSearch start=disabled
net stop wuauserv
sc config wuauserv start=demand
net stop SysMain
sc config SysMain start=disabled
net stop Spooler
sc config Spooler start=demand
net stop TrkWks
sc config TrkWks start=demand
net stop PcaSvc
sc config PcaSvc start=disabled
pause