############################################################################################
# Dateiname: zweiter_versuch.ps1
# Herstellt von Yi Miao
# Datum: 2025-06-13
# Ennaio_Version: 11.10
# Aufgabe:
# Hier ist mein zweiter Versuch, das Powershell-Script für Erstellung der Ordner zu schreiben
# Die Ordner für Enaio-Applikationen und -Dienste erstellen;
# 		das Ergebnis von dem Script wird auf Console geschrieben;
# 		Jetzt soll das Ergebnis des Script in eine Log-Datei geschrieben werden. 

# Mit Array werden alle Ordner abgelegt
# Mit einer foreach-Schleife werden die Ordner erstellt und die dazugehörigen Berechtigungen eingestellt. 
# Status: noch nicht getestet;
# Ich probiere ich zuerst das, 
# Das heißt: ich führe mit diesem Befehl das Powershell-Script für Ordner-Erstellen aus: 
# .\erster_versuch.ps1 *>&1 | Out-File -FilePath "C:\Users\adm_enaio\Downloads\ordner_Script_Log.txt" -Encoding utf8
# Aber hier muss man auf die "-FilePath" aufpassen, dass der Pfad keinen Ordner von Enaio benutzt, 
# Am besten steht die Datei mit dem Script zusammen, die Log.txt-Datei muss ich später in unserem Enaio speichern und
# das Powershell-Script muss ich auf dem Kundenserver löschen, weil es intern ist. 


# Vorbereitung: Array und Funktionen deklarieren
# ein Array für alle Ordner auf D:\ und E:\ 
# Man kann nach Bedarf weitere Ordner hinzufügen.
# Daten für die Funktion ordner_Erstellen {}
$ordnerListe = @(
	# Für D:\Enaio
	"D:\Enaio",
    "D:\Enaio\Addons",
    "D:\Enaio\Applikation",
    "D:\Enaio\Applikation\clients\admin",
    "D:\Enaio\Applikation\clients\capture",
    "D:\Enaio\Applikation\services\appconnector",
    "D:\Enaio\Applikation\services\documentviewer",
    "D:\Enaio\Applikation\services\gateway",
    "D:\Enaio\Applikation\services\service-manager",
    "D:\Enaio\Applikation\services\elasticsearch7",
    "D:\Enaio\Applikation\services\FineReader",
    "D:\Enaio\AutomatischeAktionen",
    "D:\Enaio\Importe",
    "D:\Enaio\Installations_CD",
    "D:\Enaio\Lizenzen",
    "D:\Enaio\Lizenzen\Backup",
    "D:\Enaio\Lizenzen\6-Tage",
    "D:\Enaio\Lizenzen\Produktiv",
    "D:\Enaio\Lizenzen\Projekt",
    "D:\Enaio\Protokolle",
    "D:\Enaio\Protokolle\adminlogs",
    "D:\Enaio\Protokolle\capturelogs",
    "D:\Enaio\Protokolle\clientlogs",
    "D:\Enaio\Protokolle\ftplogs",
    "D:\Enaio\Protokolle\serverlogs",
    "D:\Enaio\Sicherungen",
    "D:\Enaio\Skripte",
    "D:\Enaio\Skripte\Export",
    "D:\Enaio\Skripte\Export\Hilfsfunktionen",
    "D:\Enaio\Skripte\Export\Loesungen",
    "D:\Enaio\Skripte\Export\OSSkripte",
    "D:\Enaio\Skripte\Import",
    "D:\Enaio\Tools",
    "D:\Enaio\WVorlagen",
	
	# Für E:\Enaio
	"E:\Enaio",
    "E:\Enaio\ENAIODATEN",
    "E:\Enaio\ENAIOFTS",
    "E:\Enaio\ENAIODOCUMENTVIEWER",
    "E:\Enaio\ENAIODOCUMENTVIEWER\cache",
    "E:\Enaio\ENAIODOCUMENTVIEWER\db",
    "E:\Enaio\ENAIODOCUMENTVIEWER\jobs",
    "E:\Enaio\ENAIODOCUMENTVIEWER\temp",
	
	# Für E:\MSSQL
	"E:\MSSQL",
    "E:\MSSQL\Backup",
    "E:\MSSQL\Data",
    "E:\MSSQL\Log"
)

# Funktion für Ordnererstellen
function ordner_Erstellen {
	param (
		[Array]$ordnerListe
	)
	foreach ($ordner in $ordnerListe) {
		if (!(Test-Path $ordner)) {
			New-Item -Path $ordner -ItemType Directory
			Write-Host "Ordner wurde erstellt: $ordner"
		} else {
			Write-Host "Ordner existiert bereits: $ordner"
		}
	}
}

# Daten für die Funktion berechtigung_Einstellen {} 
# Hier sind die Ordner, die Berechtigungen von "Jeder", "ReadandExecute" bekommen können. 
$berechtigungsOrdnerListe = @(
	# Für D:\Enaio
	"D:\Enaio\Addons", 
	"D:\Enaio\Installations_CD", 
	"D:\Enaio\Protokolle"
)

# Funktion für Einstellung der Berechtigung
function berechtigung_Einstellen {
	param(
		[Array]$berechtigung
	)
	foreach ($berechtigungsOrdner in $berechtigung) {
		$Berechtigung = Get-Acl -Path $berechtigungsOrdner
		$NEUBerechtigung = New-Object System.Security.AccessControl.FileSystemAccessRule("Jeder","ReadandExecute","ContainerInherit,ObjectInherit","None","Allow")
		$Berechtigung.SetAccessRule($NEUBerechtigung)
		$Berechtigung | Set-Acl -Path $berechtigungsOrdner
		$ordnerName = Split-Path $berechtigungsOrdner -Leaf
		New-SmbShare $berechtigungsOrdner -Name $ordnerName -FullAccess Administratoren -ReadAccess Jeder
	}
}

# Dieser Odner "D:\Enaio\Protokolle\clientlogs" läßt sich jetzt einfach mit folgendem Code erstellen
# Wenn es mehrere Ornder mit der gleichen Berechtigung gäbe, dann kann man eine Funktion dafür schreiben. 
# Hier kommentiere ich den Code aus und rufe den in Hauptprogramm
# $Berechtigung = get-acl -path "D:\Enaio\Protokolle\clientlogs"
# $NEUBerechtigung = New-Object System.Security.AccessControl.FileSystemAccessRule("Benutzer","Modify","ContainerInherit,ObjectInherit","None","Allow")
# $Berechtigung.SetAccessRule($NEUBerechtigung)
# $Berechtigung | Set-Acl -Path "D:\Enaio\Protokolle\clientlogs"
# New-SmbShare "D:\Enaio\Protokolle\clientlogs" -Name clientlogs -FullAccess Administratoren -ChangeAccess Jeder


# Hauptprogramm:
Write-Host "Ordner fuer enaio-Basisinstallation werden erstellt...`n"
ordner_Erstellen -ordnerListe $ordnerListe
Write-Host "Ordner wurden erfolgreich erstellt."

Write-Host "Berechtigungen fuer die Ordner werden eingesetzt ..."
berechtigung_Einstellen -berechtigung $berechtigungsOrdnerListe

# Hier ist der Code für den einzelnen Ordner, der die Berechtigung von "Benutzer" braucht. 
$Berechtigung = get-acl -path "D:\Enaio\Protokolle\clientlogs"
$NEUBerechtigung = New-Object System.Security.AccessControl.FileSystemAccessRule("Benutzer","Modify","ContainerInherit,ObjectInherit","None","Allow")
$Berechtigung.SetAccessRule($NEUBerechtigung)
$Berechtigung | Set-Acl -Path "D:\Enaio\Protokolle\clientlogs"
New-SmbShare "D:\Enaio\Protokolle\clientlogs" -Name clientlogs -FullAccess Administratoren -ChangeAccess Jeder

Write-Host "Berechtigung fuer die Ordner wurden erfolgreich eingestellt.`n"

# Betriebslogbuch anlegen
write-host "Betriebslogbuch anlegen`n"
new-item -path "D:\Enaio" -name "DMS-Betriebslogbuch.txt" -ItemType File

# Ausgabe: Verabschieden
Write-Host "Das Programm wurde erfolgreich durchgefuehrt."

