#
# Consts.
$groupDefaultName = "GroupPolicy"
#
# Disable default rule from MSI package
Disable-NetFirewallRule -DisplayName "Syncthing" -ErrorAction SilentlyContinue
#
# Syncthing-Data
$ruleName = "GPO-Allow-Syncthing-Data"
Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
New-NetFirewallRule `
        -DisplayName $ruleName `
        -Group $groupDefaultName `
        -Enabled True `
        -Direction Inbound `
        -Protocol TCP `
        -RemotePort Any `
        -Program ($ENV:SystemDrive + "\Server\Syncthing\syncthing.exe") `
        -Service Any `
        -Action Allow `
        -Profile Any `
        -RemoteAddress Any `
        -EdgeTraversal Allow `
                | Out-Null
#
# Syncthing-Mgmt
$ruleName = "GPO-Allow-Syncthing-Mgmt"
$trustedIpAddresses = @(
)
Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
New-NetFirewallRule `
        -DisplayName $ruleName `
        -Group $groupDefaultName `
        -Enabled True `
        -Direction Inbound `
        -Protocol TCP `
        -RemotePort Any `
        -Program ($ENV:SystemDrive + "\Server\Syncthing\syncthing.exe") `
        -Service Any `
        -Action Allow `
        -Profile Any `
        -RemoteAddress $trustedIpAddresses `
        -EdgeTraversal Allow `
                | Out-Null
#
Exit 0
