@echo off
setlocal enabledelayedexpansion
REM
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "AccessibilityImageLabelsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "AddressBarMicrosoftSearchInBingProviderEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "AllowGamesMenu" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "AllowSurfGame" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "BackgroundTemplateListUpdatesEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "BrowserGuestModeEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ComponentUpdatesEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ConfigureShare" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "DefaultBrowserSettingEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "DefaultNotificationsSetting" /t REG_DWORD /d "3" /f
REM
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "DefaultSearchProviderEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "DefaultSearchProviderSearchURL" /t REG_SZ /d "{google:baseURL}search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}ie={inputEncoding}" /f
REM
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "DiagnosticData" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "DiskCacheSize" /t REG_DWORD /d "52428800" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "DnsOverHttpsMode" /t REG_SZ /d "off" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "EdgeCollectionsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "EdgeFollowEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "EnableMediaRouter" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ExperimentationAndConfigurationServiceControl" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "FavoritesBarEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ForceBingSafeSearch" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ForceGoogleSafeSearch" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "HideFirstRunExperience" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "HomepageLocation" /t REG_SZ /d "https://www.google.de" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "HubsSidebarEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "InAppSupportEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "MAMEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "MathSolverEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "MicrosoftEdgeInsiderPromotionEnabled" /t REG_DWORD /d "0" /f
REM
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "NewTabPageAllowedBackgroundTypes" /t REG_DWORD /d "3" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "NewTabPageContentEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "NewTabPageHideDefaultTopSites" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "NewTabPageLocation" /t REG_SZ /d "about:blank" /f
REM
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "PasswordManagerEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "PaymentMethodQueryEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "PinningWizardAllowed" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "PrintingEnabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "PromotionalTabsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ProxyMode" /t REG_SZ /d "system" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "RelatedMatchesCloudServiceEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ResolveNavigationErrorsUseWebService" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "SearchSuggestEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ShowCastIconInToolbar" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ShowMicrosoftRewards" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ShowOfficeShortcutInFavoritesBar" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "ShowRecommendationsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "SmartScreenDnsRequestsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "SuppressUnsupportedOSWarning" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "VerticalTabsAllowed" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "VisualSearchEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "WebRtcUdpPortRange" /t REG_SZ /d "19302-19309" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge" /v "WebWidgetIsEnabledOnStartup" /t REG_DWORD /d "0" /f
REM
REG DELETE "HKLM\Software\Policies\Microsoft\Edge\ExtensionInstallForcelist" /f 2>&1 | find /i "erfolg"
REG ADD "HKLM\Software\Policies\Microsoft\Edge\ExtensionInstallForcelist" /v "1" /t REG_SZ /d "odfafepnkmbhccpbejgmiehpchacaeak" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge\ExtensionInstallForcelist" /v "2" /t REG_SZ /d "oholpbloipjbbhlhohaebmieiiieioal" /f
REM
REG DELETE "HKLM\Software\Policies\Microsoft\Edge\NotificationsAllowedForUrls" /f 2>&1 | find /i "erfolg"
REG ADD "HKLM\Software\Policies\Microsoft\Edge\NotificationsAllowedForUrls" /v "1" /t REG_SZ /d "https://teams.microsoft.com" /f
REM
REG DELETE "HKLM\Software\Policies\Microsoft\Edge\NotificationsBlockedForUrls" /f 2>&1 | find /i "erfolg"
REG ADD "HKLM\Software\Policies\Microsoft\Edge\NotificationsBlockedForUrls" /v "1" /t REG_SZ /d "[*.]com" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge\NotificationsBlockedForUrls" /v "2" /t REG_SZ /d "[*.]de" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge\NotificationsBlockedForUrls" /v "3" /t REG_SZ /d "[*.]net" /f
REG ADD "HKLM\Software\Policies\Microsoft\Edge\NotificationsBlockedForUrls" /v "4" /t REG_SZ /d "[*.]org" /f
REM
REG ADD "HKLM\Software\Policies\Microsoft\EdgeUpdate" /v "Update{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\EdgeUpdate" /v "Update{2CD8A007-E189-409D-A2C8-9AF4EF3C72AA}" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\EdgeUpdate" /v "Update{65C35B14-6C1D-4122-AC46-7148CC9D6497}" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\EdgeUpdate" /v "Update{0D50BFEC-CD6A-4F9A-964C-C7416E3ACB10}" /t REG_DWORD /d "0" /f
REM
call :cleanUp
REM
goto :eof


:cleanUp
REM
REG DELETE "HKLM\Software\Policies\Microsoft\Edge" /v "EdgeDiscoverEnabled" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Microsoft\Edge" /v "SendSiteInfoToImproveServices" /f 2>&1 | find /i "erfolg"
REG DELETE "HKLM\Software\Policies\Microsoft\Edge" /v "TravelAssistanceEnabled" /f 2>&1 | find /i "erfolg"
REM
goto :eof
