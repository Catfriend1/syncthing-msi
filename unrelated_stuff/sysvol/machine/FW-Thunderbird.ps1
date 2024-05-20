$ruleName = "GPO-Block-Thunderbird-Web"
$binPath = "%ProgramFiles%\Mozilla Thunderbird\thunderbird.exe"
$description = "Blockierung von Web-Verbindungen beim Starten des Programms und in E-Mail eingebettete Inhalte aus dem Web."
#
Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
New-NetFirewallRule `
        -DisplayName $ruleName `
        -Direction Outbound `
        -Protocol TCP `
        -RemotePort 80,443 `
        -Program $binPath `
        -Action Block `
                | Out-Null
#
Exit 0
