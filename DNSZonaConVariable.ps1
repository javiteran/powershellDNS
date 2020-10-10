#Descarga la ayuda del dnsserver para que funcione el intellisense
update-help dnsserver


#Introducir el nombre de la zona en la siguiente variable
$QueZona ='prueba.es'
#Como es un ejemplo. BORRA la zona si está creada
Remove-DnsServerZone             -Name $QueZona -force 
#Crea una zona primaria con un archivo de zona llamadao zona.dns
Add-DnsServerPrimaryZone         -Name $QueZona -ZoneFile "$QueZona.dns"
#Elimina TODOS los registros NS de la zona recien creada. El registro inicial suele ser erroneo.
Remove-DnsServerResourceRecord   -Name "@"           -RRType Ns              -ZoneName $QueZona -Force
#Crea registros de tipo AAAA, A, CNAME, MX
Add-DnsServerResourceRecordAAAA  -Name "@"  -IPv6Address 2001::115           -ZoneName $QueZona
Add-DnsServerResourceRecordA     -Name "@"  -IPv4Address 172.20.140.115      -ZoneName $QueZona
Add-DnsServerResourceRecordAAAA  -Name ns1  -IPv6Address 2001::115           -ZoneName $QueZona
Add-DnsServerResourceRecordAAAA  -Name www  -IPv6Address 2001::115           -ZoneName $QueZona
Add-DnsServerResourceRecordA     -Name ns2  -IPv4Address 172.20.140.254      -ZoneName $QueZona
Add-DnsServerResourceRecordAAAA  -Name mail -IPv6Address 2001::115           -ZoneName $QueZona

Add-DnsServerResourceRecordCName -Name ftp    -HostNameAlias "www.$QueZona"  -ZoneName $QueZona
Add-DnsServerResourceRecordCName -Name google -HostNameAlias "www.google.es" -ZoneName $QueZona

Add-DnsServerResourceRecordMX    -Name "@" -MailExchange "mail.$QueZona"     -ZoneName $QueZona -Preference 10

#Crea dos registros NS
Add-DnsServerResourceRecord      -Name "@" -NameServer ns1.$QueZona -NS      -ZoneName $QueZona
Add-DnsServerResourceRecord      -Name "@" -NameServer ns2.$QueZona -NS      -ZoneName $QueZona

#Modifica los parámetros de "Servidor primario" y "Número de serie" del registro SOA de la zona
$OSOA = Get-DnsServerResourceRecord -RRType SOA                              -ZoneName $QueZona 
$NSOA = Get-DnsServerResourceRecord -RRType SOA                              -ZoneName $QueZona 
$NSOA.RecordData.PrimaryServer  = "ns1.$QueZona"
$NSOA.RecordData.SerialNumber   = "2015101301"
Set-DnsServerResourceRecord  -OldInputObject $OSOA -NewInputObject $NSOA     -ZoneName $QueZona