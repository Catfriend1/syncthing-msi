# Funktion zum Überprüfen, ob eine IP-Adresse im angegebenen Bereich liegt
function Is-IPInRange {
    param (
        [string]$IP,
        [string]$StartRange,
        [string]$EndRange
    )

    $IPAddress = [System.Net.IPAddress]::Parse($IP)
    $StartIPAddress = [System.Net.IPAddress]::Parse($StartRange)
    $EndIPAddress = [System.Net.IPAddress]::Parse($EndRange)

    $IPBytes = $IPAddress.GetAddressBytes()
    $StartBytes = $StartIPAddress.GetAddressBytes()
    $EndBytes = $EndIPAddress.GetAddressBytes()

    for ($i = 0; $i -lt $IPBytes.Length; $i++) {
        if ($IPBytes[$i] -lt $StartBytes[$i] -or $IPBytes[$i] -gt $EndBytes[$i]) {
            return $false
        }
    }
    return $true
}
#
# IP-Adressen des PCs abrufen
$ipAddresses = (Get-NetIPAddress -AddressFamily IPv4).IPAddress
#
# Überprüfen, ob eine der Adressen im Bereich liegt
$rangeStart = "10.10.20.30"
$rangeEnd = "10.10.20.39"
#
$ipAddressInRange = $false
foreach ($ip in $ipAddresses) {
    if (Is-IPInRange -IP $ip -StartRange $rangeStart -EndRange $rangeEnd) {
        Write-Host "[INFO] Die IP-Adresse $ip liegt im Bereich von $rangeStart bis $rangeEnd."
        $ipAddressInRange = $true
    } else {
        # Write-Host "Die IP-Adresse $ip liegt nicht im Bereich."
    }
}
if (-not $ipAddressInRange) {
    "[INFO] IP address is not in mapping range."
}
#
$isAssignedUser = @(
    "User1"
) -contains $ENV:USERNAME
#
if (-not $isAssignedUser) {
    "[INFO] User is not assigned to drive."
}
#
$shouldMapDrive = ($isAssignedUser -and $ipAddressInRange)
$driveLetter = "H"
$driveUNC = "\\FS\SHARE"
#
if (-not $shouldMapDrive) {
	"[INFO] Disconnecting drive " + $driveLetter + ":"
	Remove-PSDrive -Name $driveLetter -ErrorAction SilentlyContinue
	Exit 0
}
#
$activeUNC = (Get-PSDrive -Name $driveLetter -ErrorAction SilentlyContinue).DisplayRoot 
if ($activeUNC -eq $driveUNC) {
    "[INFO] Drive " + $driveLetter + ": already mapped to [" + $driveUNC + "]"
    Exit 0
}
#
"[INFO] Mapping drive " + $driveLetter + ": [" + $driveUNC + "]"
Remove-PSDrive -Name $driveLetter -ErrorAction SilentlyContinue
New-PSDrive -Name $driveLetter -PSProvider FileSystem -Persist -Root $driveUNC | Out-Null
#
Exit 0
