# -*- coding: utf-8 -*-

#Code: JoseInacio -
#Github: https://github.com/InacioTi

#conecat a vpn com routa especifica

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

Install-Module -Name VPNCredentialsHelper

Get-VpnConnection

$ConnectName = read-host 'Digite o nome da VPN'
$Destination =  '10.1.0.0/23'
#$Destination1 = read-host '192.168.0.0/24'
Set-VpnConnection -Name $ConnectName -SplitTunneling $True  -WA SilentlyContinue
Add-Vpnconnectionroute -Connectionname $ConnectName  -DestinationPrefix $Destination
#Add-Vpnconnectionroute -Connectionname $ConnectName  -DestinationPrefix $Destination1
