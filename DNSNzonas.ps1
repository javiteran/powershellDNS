# Este script crea 30 zonas DNS llamadas prueba01.xxx   hasta prueba30.xxx
for ($i=01;$i -lt 31;$i++)
{
      if ($i -lt 10) {
            $QueZona="prueba0$i.xxx"}
      else {
            $QueZona="prueba$i.xxx" }


    Remove-DnsServerZone -Name $QueZona -Force
    Add-DnsServerPrimaryZone -Name $QueZona -ZoneFile "$QueZona.dns"
    Remove-DnsServerResourceRecord -Name "@" -RRType Ns -ZoneName $QueZona -Force
    Add-DnsServerResourceRecordAAAA -IPv6Address 2001::108 -Name ns1 -ZoneName $QueZona
    Add-DnsServerResourceRecordAAAA -IPv6Address 2001::108 -Name www -ZoneName $QueZona
    Add-DnsServerResourceRecordA -IPv4Address 172.20.140.254 -Name ns2 -ZoneName $QueZona
    Add-DnsServerResourceRecordAAAA -IPv6Address 2001::108 -Name mail -ZoneName $QueZona
    Add-DnsServerResourceRecordCName -HostNameAlias "www.$QueZona" -Name ftp -ZoneName $QueZona
    Add-DnsServerResourceRecordMX -MailExchange "mail.$QueZona" -Name "@" -Preference 10 -ZoneName $QueZona
    Add-DnsServerResourceRecord -Name "@" -NameServer "ns2.$QueZona" -NS -ZoneName $QueZona
    Add-DnsServerResourceRecord -Name "@" -NameServer "ns1.$QueZona" -NS -ZoneName $QueZona
    $OSOA = Get-DnsServerResourceRecord -ZoneName $QueZona -RRType SOA
    $NSOA = Get-DnsServerResourceRecord -ZoneName $QueZona -RRType SOA
    $NSOA.RecordData.PrimaryServer = "ns1.$QueZona."
    $NSOA.RecordData.SerialNumber = "2015101308"
    Set-DnsServerResourceRecord -NewInputObject $NSOA -OldInputObject $OSOA -ZoneName $QueZona
 }
