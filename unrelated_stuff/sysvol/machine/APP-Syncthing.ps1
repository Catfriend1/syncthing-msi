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


function Reg-Add {
    param (
        [parameter(Mandatory = $true)] [string] $Path,
        [parameter(Mandatory = $true)] [string] $Name,
        [parameter(Mandatory = $true)] [string] $Value,
        [parameter(Mandatory = $true)] [Microsoft.Win32.RegistryValueKind] $Type
    )
    #
    $regAddPath = $Path -Replace ":", ""
    if (-not (Test-Path -Path $Path)) {
        Invoke-Expression "REG ADD `"$regAddPath`" /f" | Out-Null
    }
    Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
}


function setSyncthingPolicy {
    "[INFO] setSyncthingPolicy"
    #
    Invoke-Expression "REG ADD `"HKLM\Software\Policies\Syncthing`" /f" | Out-Null
    #
    $values = @{
        # "addDeviceHost"                = "localhost.localdomain"
        # "addDeviceID"                  = "CF6WMOG-F4RHVKW-2FTJONJ-GJ3FZQS-YW5TJVW-VDDT6ZQ-EVJ2WDP-RL4QZQO"
        # "addDevicePort"                = "22000"
        "defaultVersioningMode"        = "trashcan"
        "enableAutoUpgrade"            = "0"
        "enableGlobalDiscovery"        = "0"
        "enableLocalDiscovery"         = "0"
        "enableNAT"                    = "0"
        "enableRelays"                 = "0"
        "hashers"                      = "1"
        "setDevicenameToComputername"  = "1"
    }
    #
    foreach ($name in $values.Keys) {
        Reg-Add -Path "HKLM:\Software\Policies\Syncthing" -Name $name -Value $values[$name] -Type String
    }
    #
    Return
}
###################
# FUNCTIONS END   #
###################
#
#
# Consts.
$binInstaller = Resolve-Path -ErrorAction Stop -Path ($PSScriptRoot + "\..\install\Syncthing\Syncthing_v1.27.7.msi")
$binInstallerArg = "/i `"$binInstaller`" /qb /norestart"
$binInstalledExecutable = $ENV:SystemDrive + "\Server\Syncthing\syncthing.exe"
#
# Runtime Variables.
$installedVersion = GetInstalledVersion -binPath $binInstalledExecutable
$targetVersion = GetVersionFromMSI -msiPackage $binInstaller
if ($targetVersion -eq $null) {
    "[ERROR] Could not get targetVersion from binInstaller=[" + $binInstaller + "]"
    Exit 99
}
#
setSyncthingPolicy
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
