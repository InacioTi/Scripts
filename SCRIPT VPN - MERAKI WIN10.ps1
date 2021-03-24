#CriarVPNFuncional

Remove-VpnConnection -Name "Teste1" -Force


Add-VpnConnection -Name Teste1 -ServerAddress  quantanocoffice-kgpktznthj.dynamic-m.com -TunnelType L2tp -L2tpPsk "!m3R4k14upP04t$" -AuthenticationMethod pap,MSChapv2 -RememberCredential -Force -PassThru 

#você deve permitir a execução de scripts remotos primeiro.

#Abra o Powershell com privilégios de administração.

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

Install-Module -Name VPNCredentialsHelper

Set-VpnConnectionUsernamePassword -connectionname Teste1 -username jose.inacio@quantadgt.com -password 123




