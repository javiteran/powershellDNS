#########################################################
### Crea varias zonas delegadas que están en un array  ##
### también crea registros dentro de la zona           ##
### cada una de las zonas está en un servidor diferente##
###                                                    ##
###  Javier Terán González. 07/10/2021                 ##
#########################################################
# En este ejemplo crea 26 zonas en 26 servidores windows server diferentes (son los servidores que tenemos en clase #
# La prueba final es hacer un ping a :
#  ping www.alu01.alu02.alu03.alu04.alu05.alu06.alu07.alu08.alu09.alu10.alu11.alu12.alu13.
#           alu14.alu15.alu16.alu17.alu18.alu19.alu20.alu21.alu22.alu23.alu24.alu25.alu26.xxx
#  Se pueden ir probando cada uno de los ping intermedios. ej. ping alu25.alu26.xxx

#$myArrayNO = @("javi","guilherme","miguel","francisco","adrian","sergiu","rafael","hugo","galo","valeriano","sergio","carlos","fernando","luis","xxx")
#$myArrayIP = @("115" ,"101"      ,"102"   ,"114"      ,"103"   ,"104"   ,"110"   ,"105" ,"106" ,"107"      ,"108"   ,"109"   ,"111"     ,"112" ,"254")


$myArrayNO = @("alu01","alu02","alu03","alu04","alu05","alu06","alu07","alu08","alu10","alu11","alu13","alu15","alu16","alu17","alu18","alu19","alu20","alu21","alu22","alu23","yyy")
$myArrayIP = @(101    ,102    ,103    ,104    ,105    ,106    ,107    ,108    ,110    ,111     ,113      ,115    ,116    ,117    ,118    ,119    ,120    ,121    ,122    ,123, 254)


$QueZona   =""
$QueServer =""
$Punto     =""

$ServidorPrincipal = "2001::" + $myArrayIP[$myArrayNO.length-1]
$ZonaInicial       = $myArrayNO[$myArrayNO.length-1] 

for ($i = $myArrayNO.length; $i -gt 0; $i--) {
    $Punto     = if ($i -ne $myArrayNO.length) {"."}
    $QueZonaAnterior   = $QueZona
    $QueServerAnterior = $QueServer
    
    $QueZona   = $myArrayNO[$i-1] + $Punto  + $QueZona  
    write-host   $QueZona 
    $QueServer = "2001::" + $myArrayIP[$i-1]
    write-host   $QueServer
    #remove-dnsserverzone -ZoneName $QueZona  -ComputerName $QueServer -Force 

    Add-DnsServerPrimaryZone -Name $QueZona -ZoneFile "$QueZona.dns"                      -ComputerName $QueServer
    Add-DnsServerResourceRecordAAAA -IPv6Address 2001::254 -Name ns1 -ZoneName $QueZona   -ComputerName $QueServer
    Add-DnsServerResourceRecordAAAA -IPv6Address 2001::254 -Name "@" -ZoneName $QueZona   -ComputerName $QueServer
#
    Remove-DnsServerResourceRecord -Name "@" -RRType Ns -ZoneName $QueZona                -ComputerName $QueServer -Force
    Add-DnsServerResourceRecord -Name "@" -NameServer ns1.$QueZona -NS -ZoneName $QueZona -ComputerName $QueServer

    Add-DnsServerZoneDelegation -ChildZoneName $myArrayNO[$i-1] -IPAddress $QueServer -Name $QueZonaAnterior -NameServer ns1.$QueZona -ComputerName $QueServerAnterior   
}


