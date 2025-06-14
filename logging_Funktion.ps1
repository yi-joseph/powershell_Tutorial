
# Funktion für Logging
function Log-Message {
    param (
        [string]$message
    )
    $logFilePath = "D:\Enaio\DMS-Betriebslogbuch.txt"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Add-Content -Path $logFilePath -Value $logEntry
}

# Hauptprogramm:
Write-Host "Ordner für enaio-Basisinstallation werden erstellt...`n"
Log-Message "Starte die Erstellung der Ordner."
ordner_Erstellen -ordnerListe $ordnerListe
Log-Message "Ordner wurden erfolgreich erstellt."

Write-Host "Berechtigungen für die Ordner werden eingesetzt ..."
Log-Message "Starte die Einstellung der Berechtigungen."
berechtigung_Einstellen -berechtigung $berechtigungsOrdnerListe
Log-Message "Berechtigungen für die Ordner wurden erfolgreich eingestellt.`n"

# Hier ist der Code für den einzelnen Ordner, der die Berechtigung von "Benutzer" braucht. 
$Berechtigung = get-acl -path "D:\Enaio\Protokolle\clientlogs"
$NEUBerechtigung = New-Object System.Security.AccessControl.FileSystemAccessRule("Benutzer","Modify","ContainerInherit,ObjectInherit","None","Allow")
$Berechtigung.SetAccessRule($NEUBerechtigung)
$Berechtigung | Set-Acl -Path "D:\Enaio\Protokolle\clientlogs"
New-SmbShare "D:\Enaio\Protokolle\clientlogs" -Name clientlogs -FullAccess Administratoren -ChangeAccess Jeder
Log-Message "Berechtigung für den Ordner 'clientlogs' wurde erfolgreich eingestellt."

Write-Host "Berechtigung für die Ordner wurden erfolgreich eingestellt.`n"

# Betriebslogbuch anlegen
write-host "Betriebslogbuch anlegen`n"
new-item -path "D:\Enaio" -name "DMS-Betriebslogbuch.txt" -ItemType File -ErrorAction SilentlyContinue
Log-Message "Betriebslogbuch wurde angelegt."

# Ausgabe: Verabschieden
Write-Host "Das Programm wurde erfolgreich durchgeführt."
Log-Message "Das Programm wurde erfolgreich durchgeführt."

# Erläuterungen:
# Log-Message Funktion: Diese Funktion nimmt eine Nachricht als Parameter, fügt einen Zeitstempel hinzu und schreibt die Nachricht in die Logdatei D:\Enaio\DMS-Betriebslogbuch.txt.
# Aufrufe der Log-Message Funktion: An verschiedenen Stellen im Hauptprogramm wird die Log-Message Funktion aufgerufen, um den Fortschritt und die Ergebnisse der Operationen zu protokollieren.
# Fehlerbehandlung: Bei der Erstellung des Logbuchs wird -ErrorAction SilentlyContinue verwendet, um zu verhindern, dass ein Fehler auftritt, wenn die Datei bereits existiert.
# Mit dieser Funktion kannst du den Verlauf der Skriptausführung einfach nachverfolgen.



