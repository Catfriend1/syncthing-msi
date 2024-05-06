function firewallDisableBuiltInRuleGroups {
    "[INFO] firewallDisableBuiltInRuleGroups"
    #
    $firewallRules = Get-NetFirewallRule
    foreach ($firewallRule in $firewallRules) {
        #
        # Skip already disabled rules.
        if ($firewallRule.Enabled -eq "False") {
            continue
        }
        #
        # Skip manually added rules.
        if (-not $firewallRule.Group) {
            # "[INFO] firewallDisableBuiltInRuleGroups: Skipping [" + $firewallRule.DisplayName + "]"
            continue
        }
        #
        # Skip rules created by GPO scripts.
        if ($firewallRule.Group -eq "GroupPolicy") {
            # "[INFO] firewallDisableBuiltInRuleGroups: Skipping [" + $firewallRule.DisplayName + "]"
            continue
        }

        #
        "[INFO] firewallDisableBuiltInRuleGroups: Disabling rule [" + $firewallRule.DisplayName + "]"
        Disable-NetFirewallRule -DisplayName $firewallRule.DisplayName | Out-Null
    }
    #
    Return
}


function firewallAllowIncoming {
    "[INFO] firewallAllowIncoming"
    #
    # Consts.
    $groupDefaultName = "GroupPolicy"
    $trustedIpAddresses = @(
        "10.10.10.10",
        "10.10.10.11"
    )
    #
    # RDP
    $ruleName = "GPO-Allow-RDP-TCP"
    Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    New-NetFirewallRule `
            -DisplayName $ruleName `
            -Description "Eingehende Regel für den Remotedesktopdienst, die RDP-Datenverkehr zulässt. [TCP 3389]" `
            -Group $groupDefaultName `
            -Enabled True `
            -Direction Inbound `
            -Protocol TCP `
            -LocalPort 3389 `
            -RemotePort Any `
            -Program "%SystemRoot%\system32\svchost.exe" `
            -Service "termservice" `
            -Action Allow `
            -Profile Any `
            -RemoteAddress $trustedIpAddresses `
                    | Out-Null
    #
    # SMB
    $ruleName = "GPO-Allow-SMB"
    Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    New-NetFirewallRule -DisplayName $ruleName `
            -Description "Erlaubt SMB-Verkehr über TCP Port 445 mit Authentifizierung" `
            -Group $groupDefaultName `
            -Enabled True `
            -Direction Inbound `
            -Protocol TCP `
            -LocalPort 445 `
            -RemotePort Any `
            -Program "System" `
            -Service Any `
            -Action Allow `
            -Profile Any `
            -RemoteAddress $trustedIpAddresses `
                    | Out-Null
    #
    Return
}


function firewallBaseConfig {
    "[INFO] firewallBaseConfig"
    #
    # Enable Firewall on all profiles.
    # Allow local policy override.
    # Inbound Traffic: Default Block
    # Enable Notifications.
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall" /v "PolicyVersion" /t REG_DWORD /d "542" /f
    #
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" /v "AllowLocalPolicyMerge" /t REG_DWORD /d "1" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" /v "DefaultInboundAction" /t REG_DWORD /d "1" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" /v "DisableNotifications" /t REG_DWORD /d "0" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f
    #
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" /v "AllowLocalPolicyMerge" /t REG_DWORD /d "1" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" /v "DefaultInboundAction" /t REG_DWORD /d "1" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" /v "DisableNotifications" /t REG_DWORD /d "0" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f
    #
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" /v "AllowLocalPolicyMerge" /t REG_DWORD /d "1" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" /v "DefaultInboundAction" /t REG_DWORD /d "1" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" /v "DisableNotifications" /t REG_DWORD /d "0" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f
    #
    Return
}
#
firewallDisableBuiltInRuleGroups
#
firewallBaseConfig | Out-Null
#
firewallAllowIncoming
#
Exit 0
