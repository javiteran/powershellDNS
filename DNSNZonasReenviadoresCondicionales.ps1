#Crea N zonas reenviadores condicionales y/o borra N zonas
#Saber las zonas que son reenviadores condicionales
(Get-DnsServerZone | Where-Object { $_.zonetype -eq 'Forwarder' }).ZoneName
$QueZona          = 'prueba'
$QueZonaPrincipal = '.local'
$CuantasCrear     = 16
$ServidorDNS      = '172.20.140.254'

for ($i=01;$i -le $CuantasCrear;$i++)
{
    if ($i -lt 10) {
            $QueZonaF=$QueZona + '0' + $i + $QueZonaPrincipal}
    else {
            $QueZonaF=$QueZona +       $i + $QueZonaPrincipal }


    $QueMaster = '172.20.140.' + (100+$i)          
    Write-Host "$($QueZonaF) - $($QueMaster)"
    add-DnsServerConditionalForwarderZone -Name $QueZonaF -MasterServers $QueMaster -ComputerName $ServidorDNS
}

######################################################################################

#Borrar N zonas DNS. Da igual que sea una zona primaria, secundaria o un reenviador condicional.
for ($i=01;$i -le $CuantasCrear;$i++)
{
    if ($i -lt 10) {
            $QueZonaF=$QueZona + '0' + $i + $QueZonaPrincipal}
    else {
            $QueZonaF=$QueZona +       $i + $QueZonaPrincipal } 
    Remove-DnsServerZone -Name $QueZonaF -ComputerName $ServidorDNS  -Force       
}