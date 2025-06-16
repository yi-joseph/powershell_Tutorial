# Von Christian.

$services = get-service -name *enaio*,*elastic*

foreach ($item in $services)
{
     Restart-Service –Name $item.Name
}
