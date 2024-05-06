@echo off
setlocal enabledelayedexpansion
REM
REM IntelHD_cpl
REG ADD "HKCU\Software\Intel\Display\igfxcui\igfxtray\TrayIcon" /v "ShowTrayIcon" /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Intel\Display\igfxcui\HotKeys" /v "Enable" /t REG_DWORD /d 0 /f
REM
REM AMD_Graphics_cpl
REG ADD "HKCU\Software\AMD\CN" /v "SystemTray" /t REG_SZ /d "false" /f
REM
REM Realtek_Audio_cpl
REG ADD "HKCU\Software\Realtek\RAVCpl64\General" /v "ShowTrayIcon" /t REG_DWORD /d 0 /f
REM
REM NVidia_Graphics_cpl
REG ADD "HKCU\Software\NVIDIA Corporation\Global\NvCplApi\Policies" /v "ContextUIPolicy" /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\NVIDIA Corporation\NvTray" /v "StartOnLogin" /t REG_DWORD /d 0 /f
REM
goto :eof
