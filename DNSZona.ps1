#Creacion y eliminacion de una zona
#Este script debe ejecutarse en el servidor DNS donde quieres que se cree la zona.
#Si no es asi deberia usarse el parametro -computername  en TODAS LAS LINEAS

$QueZona ='mizona.local'


#Eliminacion de la zona si existe. CUIDADO!!!!!
Remove-DnsServerZone -Name $QueZona -Force 

#Creacion de una zona
Add-DnsServerPrimaryZone -Name $QueZona -ZoneFile "$QueZona.dns" 
    #Eliminacion del registro NS erroneo al crear la zona
    Remove-DnsServerResourceRecord      -RRType Ns                    -Name "@"  -ZoneName $QueZona -Force

    #Registros AAAA IPv6
    Add-DnsServerResourceRecordAAAA     -IPv6Address 2001::108        -Name ns1  -ZoneName $QueZona
    Add-DnsServerResourceRecordAAAA     -IPv6Address 2001::108        -Name www  -ZoneName $QueZona
    Add-DnsServerResourceRecordAAAA     -IPv6Address 2001::108        -Name mail -ZoneName $QueZona

    #Registros A IPv4
    Add-DnsServerResourceRecordA        -IPv4Address 172.20.140.254   -Name ns2  -ZoneName $QueZona

    #Registros CNAME(Alias) o MX
    Add-DnsServerResourceRecordCName    -Name ftp  -HostNameAlias "www.$QueZona" -ZoneName $QueZona
    Add-DnsServerResourceRecordMX       -Name "@"  -MailExchange "mail.$QueZona" -ZoneName $QueZona -Preference 10 
    
    #Creacion de registros NS
    Add-DnsServerResourceRecord         -Name "@" -NameServer "ns2.$QueZona" -NS -ZoneName $QueZona
    Add-DnsServerResourceRecord         -Name "@" -NameServer "ns1.$QueZona" -NS -ZoneName $QueZona

    #Modificacion del registro SOA
    $OSOA = Get-DnsServerResourceRecord  -RRType SOA                             -ZoneName $QueZona
    $NSOA = Get-DnsServerResourceRecord  -RRType SOA                             -ZoneName $QueZona
    $NSOA.RecordData.PrimaryServer  = "ns1.$QueZona."
    $NSOA.RecordData.SerialNumber   = "2020100308"
    Set-DnsServerResourceRecord     -OldInputObject $OSOA -NewInputObject $NSOA  -ZoneName $QueZona