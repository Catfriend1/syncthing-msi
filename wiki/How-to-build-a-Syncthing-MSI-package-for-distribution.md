Long story short:
- This topic should share my existing work on an MSI package which can be used, for example, to distribute Syncthing easily in Windows Domain Environments or to give friends an "easy to install and connect to your server" setup experience.

- As I guess every Syncthing user has other demands when it comes to Syncthing's configuration. For example, some users may like relaying and global discovery and others like to strictly use static IP connections or local site connections only. For that reason, I've put everything into BATCH files. If you need to "BUILD YOUR OWN", just change the port numbers and/or xml setting lines in the batch to fit your needs :-).

- The build script I'm personally using to bundle Syncthing into a MSI already "lives" for a long time. I've now decided to improve it to reproducibly build with "live-downloaded" packages instead of statically distributing my local set of build (portable EXE) tools. This should also head forward if later someone like to integrate the script into an official Syncthing build server.

I'll now showcase where to find the MSI build script and how to use it.

HOW-TO: Build your OWN Syncthing MSI package

1) Head to my batch repo at https://github.com/Catfriend1/syncthing-msi/releases/latest and download the GIT workspace from https://github.com/Catfriend1/syncthing-msi/archive/master.zip .

2) Extract the downloaded "syncthing-msi-master.zip" to "C:\Temp".

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/syncthing-msi-1.4.0-zip.png)

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/extract-zip-folder.png)

3) The folder "C:\Temp\syncthing-msi-master" will open after extraction.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/folder-after-zip-extraction.png)

4) Double-click to launch "wix_build_msi.cmd".
The script will download portable prerequisites like GNU sed, Non-sucking-service-manager, Microsoft Sigcheck64, Syncthing and WiX Toolset. It will then build the MSI package using the latest Syncthing win-amd64 version - at time of writing v1.4.0.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/build-console-log.png)

5) Close the build output console window and look at your "C:\Temp\syncthing-msi" folder. Notice the file "Syncthing_v1.4.0.msi" was created.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/folder-after-msi-build.png)

Done, your MSI package is ready for interactive installation or domain deployment via group policy.

#

HOW-TO: Install the Syncthing MSI package for ALL users running with "root" permissions. In Windows we call this permission level a "SYSTEM" service.

WARNING: You should FIRST consider how you secure Syncthing’s Web UI interface before deploying the package to corporate clients. With Syncthing’s default setting, the Web UI is reachable from localhost only ([http://127.0.0.1:8384](http://127.0.0.1:8384/)) and has NO password set until YOU set one. So be warned.

TIP: I recommend to install the MSI package on a virtual machine if this is your first try. So you can first see if it fits your needs or if you require editing the default Syncthing settings in the BATCH script.

1. We’ve already built "Syncthing_v1.4.0.msi" during the how-to above. Let’s double click it to install it.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/syncthing-v1.4.0-msi.png)

2. The installer may ask for administrative permission to setup the Windows service called "Syncthing" and an incoming firewall rule to get you starting.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/windows-admin-prompt.png)

3. Continue and wait until the installation completed.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/please-wait-while-windows-configures-syncthing.png)

After setup is complete, the Syncthing service should be running. You could verify that - optionally - by looking in Windows services from the Control Panel.

4. Open Windows start menu and look for "Syncthing Web UI" to setup a password for your locally installed Syncthing instance.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/start-menu-syncthing-web-ui.png)

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/syncthing-web-ui-default.png)

Go to "Actions" > "Settings", flip the tab to "GUI" and fill in the password for the Admin UI. Then, hit "Save".

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/syncthing-web-ui-set-gui-password.png)

You can now start to configure your Syncthing instance to your needs - just as you would do it with every common Syncthing instance.

==============

For reference: The MSI package currently modifies the following parts on your disk and Windows control panel:

1. Installation folder is created

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/c-server-syncthing-folder.png)

This is where your Syncthing binary files and database reside. You could technically upgrade the Syncthing instance, but currently it’s disabled by the MSI package as I personally like to upgrade our corporate environment with a new MSI package instead to equally determine the time when the upgrade arrives.

2. Windows service is created so Syncthing starts delayed ~ 2 minutes after boot

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/windows-services-control-panel.png)

3. Firewall rule is created to allow local discovery and incoming connections for "syncthing.exe"

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/windows-firewall-control-panel.png)

#

HOW-TO: How to easily connect family members or friends to your Syncthing server using a DynDNS address (with port forwarding set up).

1. You already have "Syncthing_v1.4.0.msi" in your hands.

2. Rename the file according to this scheme:

Syncthing_v1.4.0__[SYNCTHING_SERVER_DEVICE_ID]+[SYNCTHING_SERVER_DYNDNS]+[SYNCTHING_SERVER_TCP_PORT].msi

Example:
- My Syncthing server is hosted at "catfriend-home.dyndns.org"
- The tcp port is configured to the default port number 22000.
- The server's Syncthing device ID is "CF6WMOG-F4RHVKW-2FTJONJ-GJ3FZQS-YW5TJVW-VDDT6ZQ-EVJ2WDP-RL4QZQO".

Resulting filename:

    Syncthing_v1.4.0__CF6WMOG-F4RHVKW-2FTJONJ-GJ3FZQS-YW5TJVW-VDDT6ZQ-EVJ2WDP-RL4QZQO+catfriend-home.dyndns.org+22000.msi

3. Run a test MSI installation on a virtual machine or from a PC outside your local network.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/syncthing-msi-renamed.png)

4. Open "Syncthing Web UI" from Windows start menu to see if it worked correctly.

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/start-menu-syncthing-web-ui.png)

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/syncthing-web-ui-after-autoconfigure-server.png)

You now see that the MSI installer automatically added your Syncthing server to the "Remove Devices". This will cause to dial out to your server, so you just need to accept the requests coming from your friends/family computers there. If you share some folder with them, they'll get the common Syncthing popup message on the Web UI which asks them to accept or ignore the folder. If they decide to add the folder, they're automatically suggested to put it in "C:\Server\Sync".

![](https://github.com/Catfriend1/syncthing-msi/blob/master/wiki/images/syncthing-web-ui-add-folder-our-photos.png)
