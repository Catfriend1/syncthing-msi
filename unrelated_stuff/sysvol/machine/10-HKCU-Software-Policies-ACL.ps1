###################
# FUNCTIONS START #
###################
function applyAclToLoggedOnUsers {
    param (
        [parameter(Mandatory = $true)]
        [System.Security.AccessControl.RegistryAccessRule]
        $rule
    )
    #
    # Versuchen, das HKU-Laufwerk hinzuzufügen, falls es nicht existiert
    if (-not (Get-PSDrive -Name HKU -ErrorAction SilentlyContinue)) {
        New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
    }
    #
    # Anwenden von ACLs auf die Registrierungsbäume der angemeldeten Benutzer
    Get-ChildItem "HKU:\" -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -notmatch "S-1-5-18$" -and $_.Name -notmatch "S-1-5-19$" -and $_.Name -notmatch "S-1-5-20$" -and $_.Name -notmatch "_Classes$"
    } | ForEach-Object {
        $userHivePath = $_.Name
        $policyPath = "$userHivePath\Software\Policies"
        #
        # Umwandeln des Registry-Pfads in ein HKU-Präfix
        $policyPath = $policyPath -replace 'HKEY_USERS', 'HKU:'
        #
        if (Test-Path $policyPath) {
            try {
                $currentAcl = Get-Acl $policyPath
                $currentAcl.SetAccessRule($rule)
                Set-Acl -Path $policyPath -AclObject $currentAcl
                "[INFO] ACL angepasst: " + $policyPath
            } catch {
                Write-Error "Fehler beim Setzen der ACL für ${policyPath}: $_"
            }
        }
    }
    #
    Return
}
#################
# FUNCTIONS END #
#################
#
#
# Consts.
$usersPath = "C:\Users"
$registryKeyName = "TempHive"
#
# Runtime Variables.
## Erzeugen eines SecurityIdentifier-Objekts für "Authentifizierte Benutzer".
$sid = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-11")
$acl = New-Object System.Security.AccessControl.RegistrySecurity
$rule = New-Object System.Security.AccessControl.RegistryAccessRule(
    $sid,
    "FullControl",
    [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit", # Vererbung auf Unterschlüssel und Werte
    [System.Security.AccessControl.PropagationFlags]"None", # Keine besondere Fortpflanzung
    [System.Security.AccessControl.AccessControlType]::Allow # Zugriff erlauben
)
$acl.SetAccessRule($rule)
#
applyAclToLoggedOnUsers -rule $rule
#
# Prüfen, ob das Skript im Systemkontext ausgeführt wird
$systemSid = New-Object System.Security.Principal.SecurityIdentifier "S-1-5-18"
$currentSid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User
#
if ($currentSid -ne $systemSid) {
    "[ERROR] Script must be run in SYSTEM context. SID = " + $currentSid.Value
    Exit 99
}
#
# Durchlaufen aller Benutzerverzeichnisse, ausgenommen "PUBLIC" und "Default"
Get-ChildItem $usersPath -Directory | Where-Object { $_.Name -notmatch "^(Public|Default)$" } | ForEach-Object {
    $userDir = $_.FullName
    $ntuserDatPath = Join-Path -Path $userDir -ChildPath "NTUSER.DAT"

    if (Test-Path $ntuserDatPath) {
        try {
            $file = [System.IO.File]::Open($ntuserDatPath, 'Open', 'Read', 'None')
            $file.Close()
        } catch {
            "[WARN] File already open, skipping: "+  $ntuserDatPath
            return
        }

        try {
            # Versuchen, den Hive zu laden
            $loadedHive = $false
            $regLoadOutput = & reg load "HKLM\$registryKeyName" "$ntuserDatPath" 2>&1
            if ($regLoadOutput -notmatch 'FEHLER') {
                $loadedHive = $true

                # Ändern der Berechtigungen im geladenen Hive
                $loadedHivePath = "HKLM:\$registryKeyName\Software\Policies"
                if (Test-Path $loadedHivePath) {
                    $currentAcl = Get-Acl $loadedHivePath
                    # Write-Output "Aktuelle ACL vor der Änderung: $currentAcl"
                    $currentAcl.SetAccessRule($rule) # Zugriffsregel setzen
                    Set-Acl -Path $loadedHivePath -AclObject $currentAcl
                    # Write-Output "ACL nach der Änderung: $(Get-Acl $loadedHivePath)"
                    "[INFO] ACL angepasst: " + $ntuserDatPath
                }
                
                # Garbage Collection durchführen, um alle offenen Handles zu schließen
                [gc]::collect()
                Start-Sleep -Seconds 2

                # Hive entladen
                $regUnloadOutput = & reg unload "HKLM\$registryKeyName" 2>&1
                $loadedHive = $false
            } else {
                Write-Error "Fehler beim Laden des Hives: $regLoadOutput"
            }
        } catch {
            if ($loadedHive) {
                $regUnloadOutput = & reg unload "HKLM\$registryKeyName" 2>&1
            }
            Write-Error "Fehler beim Bearbeiten von ${ntuserDatPath}: $_"
        }
    }
}
#
Exit 0
