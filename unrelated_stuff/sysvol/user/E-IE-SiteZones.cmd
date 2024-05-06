@echo off
REM
REM Warnung anzeigen, wenn die Zertifikatadresse nicht übereinstimmt - Aktiviert
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "WarnOnBadCertRecving" /t REG_DWORD /d 1 /f
REM
REM Intranetsites: Alle Sites, die den Proxyserver umgehen, einbeziehen - Aktiviert
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v "ProxyByPass" /t REG_DWORD /d 1 /f
REM
REM Intranetsites: Alle Netzwerkpfade (UNCs) einbeziehen - Deaktiviert
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v "UNCAsIntranet" /t REG_DWORD /d 0 /f
REM
REM Intranetsites: Lokale Sites (Intranet), die nicht in anderen Zonen aufgeführt sind, einbeziehen - Aktiviert
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v "IntranetName" /t REG_DWORD /d 1 /f
REM
REM Automatische Erkennung des Intranets aktivieren - Deaktiviert
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v "AutoDetect" /t REG_DWORD /d 0 /f
REM
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\vboxsvr" /v "file" /t REG_DWORD /d 1 /f
REM
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\Range1" /v ":Range" /t REG_SZ /d "10.10.10.10" /f
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\Range1" /v "file" /t REG_DWORD /d 1 /f
REM
REM Liste der Site zu Zonenzuweisungen - Aktiviert
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "ListBox_Support_ZoneMapKey" /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMapKey" /v "\\vboxsvr" /t REG_SZ /d 1 /f
REM
REM Ziehen und Ablegen oder Kopieren und Einfügen von Dateien zulassen - Aktivieren
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1802" /t REG_DWORD /d 0 /f
REM
goto :eof
