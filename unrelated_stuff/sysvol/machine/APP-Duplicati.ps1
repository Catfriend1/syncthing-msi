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
        $windowsInstaller  = New-Object -ComObject WindowsInstaller.Installer
        $database = $windowsInstaller.OpenDatabase($msiPackage, 0)
        $query = "SELECT `Value` FROM `Property` WHERE `Property`='ProductVersion'"
        $view = $database.OpenView($query)
        $view.Execute() | Out-Null
        $record = $view.Fetch()
        $version = $record.StringData(1)
    } catch {
        Write-Host ("[ERROR] " + $_)
    } finally {
        $record = $null
        $view = $null
        $database = $null
        $windowsInstaller  = $null
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
if ($targetVersion -eq $null) {
    "[ERROR] Could not get targetVersion from binInstaller=[" + $binInstaller + "]"
    Exit 99
}
#
"[INFO] App installedVersion=[" + $installedVersion + "], targetVersion=[" + $targetVersion + "]"
if ($installedVersion -ge $targetVersion) {
    "[INFO] App already installed and up2date."
    Exit 0
}
#
"[INFO] Exec INSTALL/UPDATE: " + $installedVersion + " < " + $targetVersion
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
