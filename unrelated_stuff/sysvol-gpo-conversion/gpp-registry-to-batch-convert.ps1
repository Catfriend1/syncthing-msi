# L�dt die XML-Datei
$xmlFullFN = "X:\Registry.xml"
[xml]$xml = Get-Content -Path $xmlFullFN
#
# �ffnet eine Datei zum Schreiben der Befehle
$outputFile = 'REG-ADD-converted.cmd'
Set-Content -Path $outputFile -Value "@echo off" -Encoding ASCII
#
# Durchl�uft jedes 'Properties'-Element in der XML-Datei unter allen 'Registry'-Elementen
foreach ($properties in $xml.SelectNodes("//Registry/Properties")) {
    $action = $properties.action
    $hive = $properties.hive
    $key = "$($hive)\$($properties.key)"
    $name = $properties.name
    $value = $properties.value
    $type = $properties.type
    #
    if (($action -eq "U") -or ($action -eq "R")) {
        # Pr�ft den Typ des Wertes und konvertiert ihn entsprechend
        $convertedValue = ""
        switch ($type) {
            'REG_DWORD' {
                # Konvertiert Hexadezimal-String in einen Dezimalwert
                $convertedValue = [convert]::ToInt32($value, 16)
                $type = 'REG_DWORD'
            }
            'REG_SZ' {
                # Stellt sicher, dass der Wert als String behandelt wird und f�gt Anf�hrungszeichen hinzu
                $convertedValue = "`"$value`""
                $type = 'REG_SZ'
            }
            'REG_BINARY' {
                # Bereitet den Hexadezimal-String vor, um ihn direkt als bin�ren Wert einzutragen
                $convertedValue = $value
                $type = 'REG_BINARY'
            }
        }
        #
        # Generiert den REG ADD Befehl und f�gt ihn zur Datei hinzu
        $command = "REG ADD `"$key`" /v `"$name`" /t $type /d $convertedValue /f"
        $command
        Add-Content -Path $outputFile -Value $command -Encoding ASCII
    } elseif ($action -eq "D") {
        if ($name -eq "" -and $value -eq "") {
            # L�scht den ganzen Registryschl�ssel, wenn sowohl name als auch value leer sind
            $command = "REG DELETE `"$key`" /f"
        } else {
            # L�scht den spezifischen Registrywert
            $command = "REG DELETE `"$key`" /v `"$name`" /f"
        }
        $command
        Add-Content -Path $outputFile -Value $command -Encoding ASCII
    }
}
#
# Information �ber den Pfad der generierten Batchdatei
"Batchdatei wurde erstellt: $outputFile"
