# Lädt die XML-Datei
$guid = "{7EDE0B29-15E4-48E5-AB48-A407C1C85B23}"
$context = "User"
$xmlFullFN = ("\\" + $ENV:USERDNSDOMAIN + "\sysvol\" + $ENV:USERDNSDOMAIN + "\Policies\$guid\$context\Preferences\Registry\Registry.xml")
# $xmlFullFN = "X:\Registry.xml"
[xml]$xml = Get-Content -Path $xmlFullFN
#
# Öffnet eine Datei zum Schreiben der Befehle
$outputFile = 'REG-ADD-converted.cmd'
Set-Content -Path $outputFile -Value "@echo off" -Encoding ASCII
#
# Durchläuft jedes 'Properties'-Element in der XML-Datei unter allen 'Registry'-Elementen
foreach ($properties in $xml.SelectNodes("//Registry/Properties")) {
    $action = $properties.action
    $hive = $properties.hive
    $key = "$($hive)\$($properties.key)"
    $name = $properties.name
    $value = $properties.value
    $type = $properties.type
    #
    if (($action -eq "U") -or ($action -eq "R")) {
        # Prüft den Typ des Wertes und konvertiert ihn entsprechend
        $convertedValue = ""
        switch ($type) {
            'REG_DWORD' {
                # Konvertiert Hexadezimal-String in einen Dezimalwert
                $convertedValue = [convert]::ToInt32($value, 16)
                $type = 'REG_DWORD'
            }
            'REG_SZ' {
                # Stellt sicher, dass der Wert als String behandelt wird und fügt Anführungszeichen hinzu
                $convertedValue = "`"$value`""
                $type = 'REG_SZ'
            }
            'REG_BINARY' {
                # Bereitet den Hexadezimal-String vor, um ihn direkt als binären Wert einzutragen
                $convertedValue = $value
                $type = 'REG_BINARY'
            }
        }
        #
        # Generiert den REG ADD Befehl und fügt ihn zur Datei hinzu
        $command = "REG ADD `"$key`" /v `"$name`" /t $type /d $convertedValue /f"
        $command
        Add-Content -Path $outputFile -Value $command -Encoding ASCII
    } elseif ($action -eq "D") {
        if ($name -eq "" -and $value -eq "") {
            # Löscht den ganzen Registryschlüssel, wenn sowohl name als auch value leer sind
            $command = "REG DELETE `"$key`" /f"
        } else {
            # Löscht den spezifischen Registrywert
            $command = "REG DELETE `"$key`" /v `"$name`" /f"
        }
        $command
        Add-Content -Path $outputFile -Value $command -Encoding ASCII
    }
}
#
# Information über den Pfad der generierten Batchdatei
"Batchdatei wurde erstellt: $outputFile"
