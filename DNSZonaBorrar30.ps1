#Borrar 30 zonas DNS
       $val = 0
        while($val -lt 9)
        {
            write 0$val
            $val++
            Remove-DnsServerZone -Name zona0$val.es -ComputerName 2001::254 -Force
        }
        while($val -le 30)
        {
            write $val
            $val++
            Remove-DnsServerZone -Name zona$val.es -ComputerName 2001::254 -Force
        }


#Borrar 30 zonas DNS
$QueZona          = 'SRI'
$QueZonaPrincipal = '.com'
$CuantasBorrar    = 30
for ($i=01;$i -le $CuantasBorrar;$i++)
{
    if ($i -lt 10) {
            $QueZonaF=$QueZona + '0' + $i + $QueZonaPrincipal}
    else {
            $QueZonaF=$QueZona +       $i + $QueZonaPrincipal } 
    Remove-DnsServerZone -Name $QueZonaF   -ComputerName 172.20.140.254 -Force       
}