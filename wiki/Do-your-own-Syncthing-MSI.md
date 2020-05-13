This article is based on:
- https://github.com/Catfriend1/syncthing-msi/releases/tag/v1.5.0
- https://github.com/Catfriend1/syncthing-msi/archive/v1.5.0.zip

Build your own MSI - instructions can be found here:
- https://github.com/Catfriend1/syncthing-msi/wiki/How-to-build-a-Syncthing-MSI-package-for-distribution

Microsoft Orca can be obtained here:
- https://www.einfaches-netzwerk.at/orca-msi-editor-herunterladen-und-installieren/
- Download hosted by third-party: https://www.technipages.com/download-orca-msi-editor (DISCLAIMER: I cannot guarantee that this download is safe, so please obtain it directly from microsoft.com if in doubt. - HowTo: https://www.einfaches-netzwerk.at/orca-msi-editor-herunterladen-und-installieren/ )

Two highlights of the v1.5.0 MSI in summary:
1) The package got a new strategy of "Do your own Syncthing". It bundles the official "Syncthing.exe" keeping as much of the "config.xml" maintain-able from an admin perspective. You can one-shot-apply your preferred "config.xml" settings or force certain settings on every upgrade that is enrolled using the MSI package (override mode). Double-clicking or GPO-deploying the MSI uses default settings (see below). You can customize by using MSI command-line switches or using the free tool "Microsoft Orca" to edit the MSI properties so you have your "own package" in the end.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/msi-edit-with-orca.png)

In Orca, go to "Property" on the left side of the window and then edit the properties according to your preference.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/default-msi-properties.png)

Example:

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/dyo-msi-properties.png)

*** SECURITY NOTICE ***

Do [b]NOT[/b] set REMOTE_WEB_UI without ensuring you'll also set up a Web UI password [b]immediately[/b] after deployment, e.g. through your own batch script. With Syncthing's default, it would leave the web UI open with [b]no[/b] password to every machine on your network and/or internet.

2) The Syncthing service is now pre-configured to run under the "LocalService" account which improves security by avoiding to give it the "full" SYSTEM account access. It can access the default path "C:\Server\Sync" without any need to manually adjust ACL on folders with Windows Explorer. The C: drive also works in regard to add a new folder "C:\my-synced-docs" if your system is a common Windows installation. For sensitive paths like C:\Windows\[subfolder], C:\Users\[subfolder] the admin/user has to explicitly add "LocalService" to the folder's permission set to allow access.

Changelog:
- Replaced third-party tool "sed.exe" by "psreplace.cmd" using PowerShell
- Removed build dependency "sigcheck.exe", it was replaced by PowerShell
- Added helper script "syncthing_grant_folder_access.cmd"
- Added helper scripts to force a database recheck on next service startup "Create syncthing_strecheckdbevery_{off|on}.cmd"
- Added auto-detection of Syncthing's web UI port to open the correct URL in the browser in case the user changed the port after the initial installation.
- Hardening and security have been improved. The "Syncthing" service is now configured to run under the "LocalService" account (instead of "NT AUTHORITY\SYSTEM"). Additionally, Syncthing's home directory (C:\Server\Syncthing\appdata) can only be accessed by the following built-in security principals: "NT AUTHORITY\NETWORK SERVICE", "NT AUTHORITY\LOCAL SERVICE", "Built-In\Administrators". This helps to prevent non-admin users on the same machine "leaking" Syncthing's secure device keys and API key from the config.
- Added MSI properties to "do your own Syncthing", offering ability to use MSI command line switches for personalization and being to able to create MSI Transforms (.MST) with MS Orca.

Valid switches for the MSI / Transform are:
```
		<!-- App specific properties -->
		<!-- Leave ADD_DEVICE_HOST at the pre-defined value if you do not need to enroll a new device -->
		<Property Id='ADD_DEVICE_HOST' Value='localhost.localdomain' />
		<Property Id='ADD_DEVICE_ID' Value='CF6WMOG-F4RHVKW-2FTJONJ-GJ3FZQS-YW5TJVW-VDDT6ZQ-EVJ2WDP-RL4QZQO' />
		<Property Id='ADD_DEVICE_PORT' Value='22000' />
		<Property Id='crashReportingEnabled' Value='false' />
		<Property Id='DATA_PORT' Value='22000' />
		<Property Id='globalAnnounceEnabled' Value='true' />
		<Property Id='hashers' Value='0' />
		<Property Id='localAnnounceEnabled' Value='true' />
		<Property Id='natEnabled' Value='true' />
		<Property Id='OVERRIDE_DEVICE_NAME_WITH_COMPUTERNAME' Value='1' />
		<Property Id='OVERRIDE_EXISTING_CONFIG' Value='0' />
		<Property Id='relaysEnabled' Value='true' />
		<Property Id='REMOTE_WEB_UI' Value='0' />
		<!-- SERVICE_ACCOUNT options: LOCALSERVICE, NETWORKSERVICE, SYSTEM -->
		<Property Id='SERVICE_ACCOUNT' Value='LOCALSERVICE' />
		<Property Id='STNOUPGRADE' Value='1' />
		<Property Id='urAccepted' Value='-1' />
		<Property Id='WEB_UI_PORT' Value='8384' />
```
