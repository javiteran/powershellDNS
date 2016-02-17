#Descarga la ayuda del dnsserver para que funcione el intellisense
update-help dnsserver


#Introducir el nombre de la zona en la siguiente variable
$QueZona ='prueba.es'
#Como es un ejemplo. BORRA la zona si está creada
Remove-DnsServerZone -Name $QueZona -force 
#Crea una zona primaria con un archivo de zona llamadao zona.dns
Add-DnsServerPrimaryZone -Name $QueZona -ZoneFile "$QueZona.dns"
#Elimina TODOS los registros NS de la zona recien creada. El registro inicial suele ser erroneo.
Remove-DnsServerResourceRecord -Name "@" -RRType Ns -ZoneName $QueZona -Force
#Crea registros de tipo AAAA, A, CNAME, MX
Add-DnsServerResourceRecordAAAA -IPv6Address 2001::115 -Name ns1 -ZoneName $QueZona
Add-DnsServerResourceRecordAAAA -IPv6Address 2001::115 -Name www -ZoneName $QueZona
Add-DnsServerResourceRecordA -IPv4Address 172.20.140.254 -Name ns2 -ZoneName $QueZona
Add-DnsServerResourceRecordAAAA -IPv6Address 2001::115 -Name mail -ZoneName $QueZona

Add-DnsServerResourceRecordCName -HostNameAlias "www.$QueZona" -Name ftp -ZoneName $QueZona
Add-DnsServerResourceRecordCName -HostNameAlias "www.google.es" -Name google -ZoneName $QueZona

Add-DnsServerResourceRecordMX -MailExchange "mail.$QueZona" -Name "@" -Preference 10 -ZoneName $QueZona

#Crea dos registros NS
Add-DnsServerResourceRecord -Name "@" -NameServer ns1.$QueZona -NS -ZoneName $QueZona
Add-DnsServerResourceRecord -Name "@" -NameServer ns2.$QueZona -NS -ZoneName $QueZona

#Modifica los parámetros de "Servidor primario" y "Número de serie" del registro SOA de la zona
$OSOA = Get-DnsServerResourceRecord -ZoneName $QueZona -RRType SOA
$NSOA = Get-DnsServerResourceRecord -ZoneName $QueZona -RRType SOA
$NSOA.RecordData.PrimaryServer = "ns1.$QueZona"
$NSOA.RecordData.SerialNumber = "2015101301"
Set-DnsServerResourceRecord -NewInputObject $NSOA -OldInputObject $OSOA -ZoneName $QueZona
