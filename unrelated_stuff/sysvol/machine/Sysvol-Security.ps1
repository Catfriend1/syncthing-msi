# Consts.
$FolderPath = "C:\Sysvol"
#
$acl = Get-Acl $FolderPath
#
# Stop ACL inherit.
$acl.SetAccessRuleProtection($true, $true)
#
# Remove all inherited ACL
foreach ($ace in $acl.Access) {
    $acl.RemoveAccessRuleSpecific($ace)
}
#
# Add ACL: System - F
$acl.AddAccessRule(
        (New-Object System.Security.AccessControl.FileSystemAccessRule(
                (New-Object System.Security.Principal.SecurityIdentifier("S-1-5-18")), 
                [System.Security.AccessControl.FileSystemRights] "FullControl", 
                "ContainerInherit,ObjectInherit", 
                "None", 
                "Allow"
        ))
)
#
# Add ACL: Lokaler Dienst - RW
$acl.AddAccessRule(
        (New-Object System.Security.AccessControl.FileSystemAccessRule(
                (New-Object System.Security.Principal.SecurityIdentifier("S-1-5-19")), 
                [System.Security.AccessControl.FileSystemRights] "Modify", 
                "ContainerInherit,ObjectInherit", 
                "None", 
                "Allow"
        ))
)
#
# Add ACL: Authentifizierte Benutzer - R
$acl.AddAccessRule(
        (New-Object System.Security.AccessControl.FileSystemAccessRule(
                (New-Object System.Security.Principal.SecurityIdentifier("S-1-5-11")), 
                [System.Security.AccessControl.FileSystemRights] "ReadAndExecute", 
                "ContainerInherit,ObjectInherit", 
                "None", 
                "Allow"
        ))
)
#
# Add ACL: User1 - RW
$acl.AddAccessRule(
        (New-Object System.Security.AccessControl.FileSystemAccessRule(
                (New-Object System.Security.Principal.NTAccount("User1")),
                [System.Security.AccessControl.FileSystemRights] "Modify", 
                "ContainerInherit,ObjectInherit", 
                "None", 
                "Allow"
        ))
)
#
# Add ACL: User2 - R
$acl.AddAccessRule(
        (New-Object System.Security.AccessControl.FileSystemAccessRule(
            (New-Object System.Security.Principal.NTAccount("User2")),
            [System.Security.AccessControl.FileSystemRights] "ReadAndExecute", 
            "ContainerInherit,ObjectInherit", 
            "None", 
            "Allow"
        ))
)
#
Set-Acl -Path $FolderPath -AclObject $acl
#
# (Get-Acl $FolderPath).Access
#
Exit 0
