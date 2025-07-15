# Battery Report per Powershell erstellen und lesen
powercfg /batteryreport
# dann wird eine HTML-Datei erstellt.
# Jetzt kann man gucken, ob die Akku gesund ist. 

# Man kann überprüfen, ob die Akku erst ab 40% aufladen lassen darf: 
Get-WmiObject -Namespace root\wmi -Class Lenovo_BatteryChargeThresholds
# oder 
Get-WmiObject -Namespace root\wmi -Class Lenovo_BatteryChargeThresholds

# sonst muss man bei BIOS einstellen: 
# Config -> Power -> Battery Thresholds oder -> Battery Maintenance: 
# Start 40%, Stop 80%
# oder
# deaktivieren Custom Thresholds. 

# Suche nach "Battery" in Windows
Get-WmiObject -Namespace root\wmi -List | Where-Object { $_.Name -like "*Battery*" }
# Das hilft leider nicht. 
