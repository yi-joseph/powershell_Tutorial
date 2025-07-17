# 1 Powershell Version Table überprüfen
$PSVersionTable
# Man kann auch die Objekte von Version Table weiterhin anzeigen lassen: 
$PSVersionTable.PSVersion

# 2 aktuelles Datum anzeigen
get-date

# Einen String in Konsole anzeigen
Write-Host "Hallo Yi Miao in Powershell-Welt! "

# Eine Variable Name deklarieren und initialisieren 
# Dann in einem String eingeben und ausgeben lassen
# Hier ist ein Programm von Hallo-Welt von Powershell
$Name = "Yi Miao"
Write-Host "Hallo $Name, hier ist die Welt von Powershell! `n" 

# Zeilenumbrech: `n

# Aktuelles Datum anzeigen
$Datum = Get-Date
Write-Host "Heute ist $Datum `n"


