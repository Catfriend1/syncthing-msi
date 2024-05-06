function psReplaceFile ([string] $fullFN, [string] $findText, [string] $replaceText) {
    Set-Content -Path $fullFN -NoNewLine -Value ((Get-Content -Encoding UTF8 -Path $fullFN | Out-String) -Replace $findText, $replaceText)
}


function iniReplaceSetting([string] $fullFN, [string] $key, [string] $oldValue, [string] $newValue) {
    psReplaceFile `
            -fullFN $fullFN `
            -findText ("(" + [regex]::Escape($key) + ')' + $oldValue) `
            -replaceText ("`${1}" + $newValue)
}


function editLocalSecurityPolicy () {
    $tempSecDB = ${Env:TEMP} + "\localSecurityPolicy.cfg"
    $result = & secedit /export /cfg $tempSecDB
    #
    iniReplaceSetting -fullFN $tempSecDB -key "LanmanWorkstation\Parameters\RequireSecuritySignature=" -oldValue "4,." -newValue "4,1"
    iniReplaceSetting -fullFN $tempSecDB -key "LanmanWorkstation\Parameters\EnableSecuritySignature=" -oldValue "4,." -newValue "4,1"
    #
    iniReplaceSetting -fullFN $tempSecDB -key "LanManServer\Parameters\RequireSecuritySignature=" -oldValue "4,." -newValue "4,1"
    iniReplaceSetting -fullFN $tempSecDB -key "LanmanServer\Parameters\EnableSecuritySignature=" -oldValue "4,." -newValue "4,1"
    #
    iniReplaceSetting -fullFN $tempSecDB -key "Lsa\RestrictAnonymousSAM=" -oldValue "4,." -newValue "4,1"
    #
    iniReplaceSetting -fullFN $tempSecDB -key "Lsa\NoLMHash=" -oldValue "4,." -newValue "4,1"
    #
    # Disable machine account password changes.
    iniReplaceSetting -fullFN $tempSecDB -key "Netlogon\Parameters\DisablePasswordChange=" -oldValue "4,." -newValue "4,1"
    #
    $result = & secedit /configure /db ${Env:SystemRoot}\security\new.sdb /cfg $tempSecDB /areas SECURITYPOLICY
    Remove-Item -Path $tempSecDB -Force
}
#
editLocalSecurityPolicy
#
# Erweiterte Überwachungskonfiguration
## Anmelden/Abmelden
### Andere Anmelde-/Abmeldeereignisse überwachen - Erfolgreich
$guid = "{0CCE921C-69AE-11D9-BED3-505054503030}"
& auditpol /set /subcategory:$guid /success:enable /failure:enable
# & auditpol /get /subcategory:$guid 
#
Exit 0
