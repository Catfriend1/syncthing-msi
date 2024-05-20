@echo off
setlocal enabledelayedexpansion
REM
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "AllowDinosaurEasterEgg" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "ApplicationLocaleValue" /t REG_SZ /d "de-DE" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "AutoFillEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "BackgroundModeEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "BookmarkBarEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "BrowserAddPersonEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "BrowserGuestModeEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "BuiltInDnsClientEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "ChromeVariations" /t REG_DWORD /d "2" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "CloudPrintProxyEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "ComponentUpdatesEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "DefaultBrowserSettingEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "DefaultNotificationsSetting" /t REG_DWORD /d "3" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "DisableSafeBrowsingProceedAnyway" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "DiskCacheSize" /t REG_DWORD /d "52428800" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "EditBookmarksEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "EnableMediaRouter" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "ExternalProtocolDialogShowAlwaysOpenCheckbox" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "ForceGoogleSafeSearch" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "HideWebStoreIcon" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "NetworkPredictionOptions" /t REG_DWORD /d "2" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "PasswordLeakDetectionEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "PasswordManagerEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "PasswordProtectionWarningTrigger" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "PrintingEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "PrintRasterizationMode" /t REG_DWORD /d "1" /f
REM
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "PrivacySandboxAdMeasurementEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "PrivacySandboxAdTopicsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "PrivacySandboxPromptEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "PrivacySandboxSiteEnabledAdsEnabled" /t REG_DWORD /d "0" /f
REM
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "PromotionalTabsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "ProxyMode" /t REG_SZ /d "system" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "RemoteAccessHostAllowFileTransfer" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "RemoteAccessHostAllowGnubbyAuth" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "RemoteAccessHostAllowRelayedConnection" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "RemoteAccessHostAllowUiAccessForRemoteAssistance" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "RemoteAccessHostFirewallTraversal" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "SafeBrowsingExtendedReportingEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "SafeBrowsingProtectionLevel" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "SearchSuggestEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "ShowAppsShortcutInBookmarkBar" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "ShowCastIconInToolbar" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "ShowFullUrlsInAddressBar" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "SpellCheckServiceEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "SSLErrorOverrideAllowed" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "SuppressUnsupportedOSWarning" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "TranslateEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "UrlKeyedAnonymizedDataCollectionEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "WebRtcUdpPortRange" /t REG_SZ /d "19302-19309" /f
REM
REG DELETE "HKLM\Software\Policies\Google\Chrome\ExtensionInstallForcelist" /f 2>&1 | find /i "erfolg"
REG ADD "HKLM\Software\Policies\Google\Chrome\ExtensionInstallForcelist" /v "1" /t REG_SZ /d "cjpalhdlnbpafiamejdnhcphjbkeiagm" /f
REG ADD "HKLM\Software\Policies\Google\Chrome\ExtensionInstallForcelist" /v "2" /t REG_SZ /d "fihnjjcciajhdojfnbdddfaoknhalnja" /f
REM
REG DELETE "HKLM\Software\Policies\Google\Chrome\NotificationsAllowedForUrls" /f 2>&1 | find /i "erfolg"
REG ADD "HKLM\Software\Policies\Google\Chrome\NotificationsAllowedForUrls" /v "1" /t REG_SZ /d "https://teams.microsoft.com" /f
REM
REG DELETE "HKLM\Software\Policies\Google\Chrome\NotificationsBlockedForUrls" /f 2>&1 | find /i "erfolg"
REG ADD "HKLM\Software\Policies\Google\Chrome\NotificationsBlockedForUrls" /v "1" /t REG_SZ /d "[*.]com" /f
REG ADD "HKLM\Software\Policies\Google\Chrome\NotificationsBlockedForUrls" /v "2" /t REG_SZ /d "[*.]de" /f
REG ADD "HKLM\Software\Policies\Google\Chrome\NotificationsBlockedForUrls" /v "3" /t REG_SZ /d "[*.]net" /f
REG ADD "HKLM\Software\Policies\Google\Chrome\NotificationsBlockedForUrls" /v "4" /t REG_SZ /d "[*.]org" /f
REM
REG ADD "HKLM\Software\Policies\Google\Update" /v "Update{8A69D345-D564-463C-AFF1-A69D9E530F96}" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Update" /v "Update{8237E44A-0054-442C-B6B6-EA0509993955}" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Update" /v "Update{4DC8B4CA-1BDA-483E-B5FA-D3C12E15B62D}" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Update" /v "Update{4EA16AC7-FD5A-47C3-875B-DBF4A2008C20}" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Update" /v "Update{401C381F-E0DE-4B85-8BD8-3F3F14FBDA57}" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Google\Update" /v "Update{8BA986DA-5100-405E-AA35-86F34A02ACBF}" /t REG_DWORD /d "0" /f
REM
IF EXIST "%SystemDrive%\Users\User1" call :configChromeUser1
REM
call :cleanUp
REM
goto :eof


:cleanUp
REM
REG DELETE "HKLM\Software\Policies\Google\Chrome" /v "AuthNegotiateDelegateWhitelist" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Google\Chrome" /v "AuthServerWhitelist" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Google\Chrome" /v "ChromeCleanupEnabled" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Google\Chrome" /v "ChromeCleanupReportingEnabled" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Google\Chrome" /v "CloudPrintSubmitEnabled" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Google\Chrome" /v "DefaultPluginsSetting" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Google\Chrome" /v "SafeBrowsingExtendedReportingOptInAllowed" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Google\Chrome" /v "SafeBrowsingEnabled" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Google\Chrome" /v "SupervisedUserCreationEnabled" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Google\Chrome" /v "WelcomePageOnOSUpgradeEnabled" /f 2>&1 | find /i "erfolg"
REM
goto :eof


:configChromeUser1
REM
echo [INFO] configChromeUser1
REM
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "DiskCacheDir" /t REG_SZ /d "X:\Temp\ChromeCache" /f
REG ADD "HKLM\Software\Policies\Google\Chrome" /v "DownloadDirectory" /t REG_SZ /d "X:\\" /f
REM
goto :eof
