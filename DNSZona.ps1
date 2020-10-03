#Creaci�n y eliminaci�n de una zona
#Este script debe ejecutarse en el servidor DNS donde quieres que se cree la zona.
#Si no es as� deber�a usarse el par�metro -computername

$QueZona ='mizona.local'


#Eliminaci�n de la zona si existe. CUIDADO!!!!!
Remove-DnsServerZone -Name $QueZona -Force 

#Creaci�n de una zona
Add-DnsServerPrimaryZone -Name $QueZona -ZoneFile "$QueZona.dns" 
    #Eliminaci�n del registro NS erroneo al crear la zona
    Remove-DnsServerResourceRecord      -Name "@" -RRType Ns -ZoneName $QueZona -Force

    #Registros AAAA IPv6
    Add-DnsServerResourceRecordAAAA     -IPv6Address 2001::108 -Name ns1 -ZoneName $QueZona
    Add-DnsServerResourceRecordAAAA     -IPv6Address 2001::108 -Name www -ZoneName $QueZona
    Add-DnsServerResourceRecordAAAA     -IPv6Address 2001::108 -Name mail -ZoneName $QueZona

    #Registros A IPv4
    Add-DnsServerResourceRecordA        -IPv4Address 172.20.140.254 -Name ns2 -ZoneName $QueZona

    #Registros CNAME(Alias) o MX
    Add-DnsServerResourceRecordCName    -HostNameAlias "www.$QueZona" -Name ftp -ZoneName $QueZona
    Add-DnsServerResourceRecordMX       -MailExchange "mail.$QueZona" -Name "@" -Preference 10 -ZoneName $QueZona
    
    #Creaci�n de registros NS
    Add-DnsServerResourceRecord         -Name "@" -NameServer "ns2.$QueZona" -NS -ZoneName $QueZona
    Add-DnsServerResourceRecord         -Name "@" -NameServer "ns1.$QueZona" -NS -ZoneName $QueZona

    #Modificaci�n del registro SOA
    $OSOA = Get-DnsServerResourceRecord -ZoneName $QueZona -RRType SOA
    $NSOA = Get-DnsServerResourceRecord -ZoneName $QueZona -RRType SOA
    $NSOA.RecordData.PrimaryServer = "ns1.$QueZona."
    $NSOA.RecordData.SerialNumber = "2020100308"
    Set-DnsServerResourceRecord -NewInputObject $NSOA -OldInputObject $OSOA -ZoneName $QueZona