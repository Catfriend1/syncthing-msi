function setGroupRdpUsers {
    #
    # Clear group
    $GroupSidRemotedesktopUsers = "S-1-5-32-555"
    $Group = Get-LocalGroup -SID $GroupSidRemotedesktopUsers
    $Members = net localgroup $Group.Name
    foreach ($Member in $Members) {
        if ($Member.Trim() -ne "" -and $Member -notmatch "-----" -and $Member -notmatch "Aliasname" -and $Member -notmatch "Beschreibung" -and $Member -notmatch "Mitglieder" -and $Member -notmatch "Der Befehl wurde") {
            $MemberName = $Member.Trim()
            "[INFO] Removing user from group: [" + $MemberName + "]"
            Remove-LocalGroupMember -Group $Group -Member $MemberName
        }
    }
    #
    # Add users to group
    $computerArray = @(
        "COMPUTER1",
        "COMPUTER2"
    )
    if ($computerArray -contains $ENV:COMPUTERNAME) {
        $userAccount = ($ENV:COMPUTERNAME + "\User1")
        "[INFO] Adding user to group: " + $userAccount
        Add-LocalGroupMember -Group $Group -Member $userAccount
    }
    #
    Return
}


# Windows-Komponenten/Remotedesktopdienste/Remotedesktopsitzungs-Host/Verbindungen
## Remoteverbindungen für Benutzer mithilfe der Remotedesktopdienste zulassen - Aktiviert 
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fDenyTSConnections" /t REG_DWORD /d "0" /f
#
Set-Service -Name TermService -StartupType Automatic
#
setGroupRdpUsers
#
Exit 0
