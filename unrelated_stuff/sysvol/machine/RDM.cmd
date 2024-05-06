@echo off
setlocal enabledelayedexpansion
REM
REM Devolutions/Remote Desktop Manager/General
REM 	Disable certain features requiring an internet connection, such as telemetry, automatic favicon fetching and checking for add-on updates. - Aktiviert
REG ADD "HKLM\SOFTWARE\Policies\Devolutions\RemoteDesktopManager" /v "NoInternetConnection" /t REG_DWORD /d 1 /f
REM
REM 	Disable telemetry data collection - Aktiviert
REG ADD "HKLM\SOFTWARE\Policies\Devolutions\RemoteDesktopManager" /v "DisableAnalytics" /t REG_DWORD /d 1 /f
REM
REM 	Disable the application automatic update check - Aktiviert
REG ADD "HKLM\SOFTWARE\Policies\Devolutions\RemoteDesktopManager" /v "DisableAutoUpdate" /t REG_DWORD /d 1 /f
REM
REM 	Disable the application's update menus - Aktiviert
REG ADD "HKLM\SOFTWARE\Policies\Devolutions\RemoteDesktopManager" /v "DisableUpdate" /t REG_DWORD /d 1 /f
REM
REM Devolutions/Remote Desktop Manager/User Interface
REM  	Disable the Devolutions Cloud usage - Aktiviert
REG ADD "HKLM\SOFTWARE\Policies\Devolutions\RemoteDesktopManager" /v "DisableOnlineAccount" /t REG_DWORD /d 1 /f
REM
goto :eof
