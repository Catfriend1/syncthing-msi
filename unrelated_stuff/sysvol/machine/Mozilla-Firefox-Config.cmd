@echo off
setlocal enabledelayedexpansion
REM
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "DisableAppUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "DisableFeedbackCommands" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "DisableFirefoxScreenshots" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "DisableFirefoxStudies" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "DisablePocket" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "DisableSystemAddonUpdate" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "DisableTelemetry" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "DisplayMenuBar" /t REG_SZ /d "default-on" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "DontCheckDefaultBrowser" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "ExtensionUpdate" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox" /v "NetworkPrediction" /t REG_DWORD /d "0" /f
REM
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Certificates" /v "ImportEnterpriseRoots" /t REG_DWORD /d "1" /f
REM
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Cookies" /v "RejectTracker" /t REG_DWORD /d "1" /f
REM
REG DELETE "HKLM\Software\Policies\Mozilla\Firefox\DNSOverHTTPS" /v "ProviderURL" /f 2>&1 | find /i "erfolg"
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\DNSOverHTTPS" /v "Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\DNSOverHTTPS" /v "Locked" /t REG_DWORD /d "0" /f
REM
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\FirefoxHome" /v "Search" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\FirefoxHome" /v "TopSites" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\FirefoxHome" /v "Highlights" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\FirefoxHome" /v "Pocket" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\FirefoxHome" /v "Snippets" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\FirefoxHome" /v "Locked" /t REG_DWORD /d "0" /f
REM
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Homepage" /v "URL" /t REG_SZ /d "https://www.google.de" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Homepage" /v "Locked" /t REG_DWORD /d "0" /f
REM
REM REG DELETE "HKLM\Software\Policies\Mozilla\Firefox\PopupBlocking\Allow" /f 2>&1 | find /i "erfolg"
REM
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Preferences" /v "app.update.auto" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Preferences" /v "browser.cache.disk.enable" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Preferences" /v "browser.search.update" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Preferences" /v "browser.slowStartup.notificationDisabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Preferences" /v "network.dns.disableIPv6" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Preferences" /v "security.ssl.errorReporting.enabled" /t REG_DWORD /d "0" /f
REM
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Proxy" /v "Locked" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Proxy" /v "Mode" /t REG_SZ /d "system" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Proxy" /v "AutoLogin" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\Proxy" /v "UseProxyForDNS" /t REG_DWORD /d "0" /f
REM
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\SearchEngines" /v "PreventInstalls" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\SearchEngines" /v "Default" /t REG_SZ /d "Google" /f
REM
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\UserMessaging" /v "ExtensionRecommendations" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\UserMessaging" /v "FeatureRecommendations" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Mozilla\Firefox\UserMessaging" /v "WhatsNew" /t REG_DWORD /d "0" /f
REM
goto :eof
