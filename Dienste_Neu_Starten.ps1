# Von Christian.

$services = get-service -name *NamenderDienste*,*NamenderDienste*

foreach ($item in $services)
{
     Restart-Service –Name $item.Name
}
