################################
# VARIAVEIS
$Name = read-host "Digite o nome da VPN"
$ServerAddress = read-host "Digite o DDNS" 
$TunnelType = "L2tp" 
$L2tpPsk = read-host "Digites o Pre-Key"
$AuthenticationMethod = "Pap"
$AuthenticationMethod = "MSChapv2" 
$EncryptionLevel = "Optional" # Values: NoEncryption | Optional | Required | Maximum
$RememberCredential = $true
$SplitTunneling = $true
################################

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Install-Module -Name VPNCredentialsHelper

# Se o PowerShell oferece suporte � configura��o de VPN, aplique a configura��o de VPN 
if (Get-Command 'Get-VpnConnection') {
    # Se houver VPN, atualize as configura��es de VPN 
    if (Get-VpnConnection -Name $Name -ErrorAction SilentlyContinue) {
        Set-VpnConnection -Name $Name  -ServerAddress $ServerAddress -TunnelType $TunnelType -EncryptionLevel $EncryptionLevel -AuthenticationMethod $AuthenticationMethod -SplitTunneling $SplitTunneling  -L2tpPsk $L2tpPsk -RememberCredential $RememberCredential -Force
    }
    # Else, criar conex�o VPN 
    else {
        Add-VpnConnection -Name $Name -ServerAddress $ServerAddress -TunnelType $TunnelType -EncryptionLevel $EncryptionLevel -AuthenticationMethod $AuthenticationMethod -L2tpPsk $L2tpPsk -Force
        Set-VpnConnection -Name $Name -SplitTunneling $SplitTunneling 
    }
    return Get-VpnConnection -Name $Name 
    exit
}
# Else, saia com o c�digo de falha 
else {
  	return "Client does not support VpnClient cmdlets"
	exit 1
}