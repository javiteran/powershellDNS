###################################################
######  Javier Teran                         ######
######  21/10/2021                           ######
######  Creo 30 zonas primariasS localmente  ######
######  Creo 30 zonas secundarias en el 254  ######
###################################################

$Mizona = "teran"
$Sufijo = "systems"
#bORRO 30 ZONAS
for ($i=10 ; $i -le 40 ; $i++) {
    REMOVE-DnsServerZone -Name $Mizona$i.$sufijo -Force
    REMOVE-DnsServerZone -Name $Mizona$i.$sufijo -Force -ComputerName 2001::254
}


for ($i=10 ; $i -le 40 ; $i++) {
#Creo zona primaria
    Add-DnsServerPrimaryZone -Name $Mizona$i.$sufijo -ZoneFile $Mizona$i.$sufijo.dns
#Creo registros NS
    Add-DnsServerResourceRecordAAAA -Name ns1 -IPv6Address 2001::115 -ZoneName $Mizona$i.$sufijo
    Add-DnsServerResourceRecordAAAA -Name ns2 -IPv6Address 2001::254 -ZoneName $Mizona$i.$sufijo
    
    Add-DnsServerResourceRecord -NS -Name "@" -NameServer ns1.$Mizona$i.$sufijo  -ZoneName $Mizona$i.$sufijo
    Add-DnsServerResourceRecord -NS -Name "@" -NameServer ns2.$Mizona$i.$sufijo  -ZoneName $Mizona$i.$sufijo
    
    write-host $Mizona$i.$sufijo
#Creo zona secundaria
    Add-DnsServerSecondaryZone -Name $Mizona$i.$sufijo -ZoneFile $Mizona$i.$sufijo.dns -MasterServers 2001::115 -ComputerName 2001::254

}

