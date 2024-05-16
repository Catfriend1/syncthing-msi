###################
# FUNCTIONS START #
###################
function GetInstalledVersion {
    param (
        [parameter(Mandatory = $true)]
        [string]
        $binPath
    )
    #
    $productVersion = ""
    $productVersion = (Get-Item -Path $binInstalledExecutable -ErrorAction SilentlyContinue).VersionInfo.ProductVersion
    Return $productVersion
}


function GetVersionFromMSI {
    param (
        [parameter(Mandatory = $true)]
        [string]
        $msiPackage
    )
    #
    try {
        $installer = New-Object -ComObject WindowsInstaller.Installer
        $database = $installer.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $null, $installer, @($msiPath, 0))
        $query = "SELECT `Value` FROM `Property` WHERE `Property`='ProductVersion'"
        $view = $database.GetType().InvokeMember("OpenView", "InvokeMethod", $null, $database, ($query))
        $view.GetType().InvokeMember("Execute", "InvokeMethod", $null, $view, $null) | Out-Null
        $record = $view.GetType().InvokeMember("Fetch", "InvokeMethod", $null, $view, $null)
        $version = $record.GetType().InvokeMember("StringData", "GetProperty", $null, $record, 1)
    } catch {
        Write-Host "[ERROR] " + $_
    } finally {
        $record = $null
        $view = $null
        $database = $null
        $installer = $null
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
    }
    #
    Return $version
}
###################
# FUNCTIONS END   #
###################
#
#
# Consts.
$binInstaller = Resolve-Path -ErrorAction Stop -Path ($PSScriptRoot + "\..\install\Duplicati\duplicati-2.0.8.1_beta_2024-05-07-x64.msi")
$binInstallerArg = "/i `"$binInstaller`" /qn /norestart REBOOT=ReallySuppress REMOVE=DuplicatiDesktopShortCutFeature,DuplicatiStartupShortCutFeature"
$binInstalledExecutable = $ENV:ProgramFiles + "\Duplicati 2\Duplicati.GUI.TrayIcon.exe"
#
# Runtime Variables.
$installedVersion = GetInstalledVersion -binPath $binInstalledExecutable
$targetVersion = GetVersionFromMSI -msiPackage $binInstaller
#
if ($productVersion -ge $targetVersion) {
    "[INFO] App already installed and up2date: " + $installedVersion
    Exit 0
}
#
"[INFO] Exec INSTALL/UPDATE: " + $installedVersion + " > " + $targetVersion
"[INFO] Exec installer: " + $binInstallerArg
$process = Start-Process -Wait -PassThru -FilePath "msiexec.exe" -ArgumentList $binInstallerArg 
if ($process.ExitCode -ne 0) {
    "[INFO] Install FAILED: " + $process.ExitCode
    Exit $process.ExitCode
}
#
"[INFO] Install SUCCESS"
#
Exit 0
