#
# Command line.
## . "C:\Server\Sync\Sysvol\groupPolicy.ps1" machine
## . "C:\Server\Sync\Sysvol\groupPolicy.ps1" user
#
param (
    [parameter(Mandatory = $true)]
    [string]
    $contextFolder
)
#
$scriptRoot = $psScriptRoot + "\" + $contextFolder
#
$scripts = @(
        Get-ChildItem -Path $scriptRoot -ErrorAction SilentlyContinue | 
            Where { ! $_.PSIsContainer } | 
            Where { @(".cmd", ".ps1") -contains $_.Extension }
        ) | Sort-Object -Property Name
#
if ($scripts -eq $null) {
    "[ERROR] No scripts found for context [" + $contextFolder + "]."
    Exit 99
}
#
Foreach ($script in $scripts) {
	"=========================== " + $($script.name) + " ==========================="
	. $script.FullName
}
#
Exit 0
