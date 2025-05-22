# Powershell-Script
# Lokales Benutzerkonto anlegen
# Yi Miao

# Eingabe: 
$name = "Yi Miao"
$accountname = "YiMiao"
$description = "Powershell üben"
$password = "Pa$$w0rd!1992"
$computer = "localhost"

"Das Benutzerkonto $name legt auf $computer an."

#Zugriff auf Container mit der COM-Bibliothek "Active Directory Service Interface"
$container = [ADSI] "WinNT://$computer"

#Benuter anlegen
$objUser = $container.Create("user", $accountname)
$objUser.Put("Fullname", $name)
$objUser.Put("Description", $description)

#password einsetzen:
$objUser.SetPassword($password)

#Änderungen speichern:
$objUser.SetInfo()

"Benutzerkonto wurde angelegt: $name auf $computer"

