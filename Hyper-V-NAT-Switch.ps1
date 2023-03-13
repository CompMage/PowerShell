#Vegetables
$SwitchName = "CMLab_Switch"
$NetworName = "CMLab_External"

#Builds and Internal Switch
New-VMSwitch -SwitchName $SwitchName -SwitchType Internal

#Get the Network adaptrer information for the next step based on the last.
$IndesID = Get-NetAdapter -Name "vEthernet ($SwitchName)" 

#Assigns an IP address and subnetmask to thr Virtual Switch Network Adapter
New-NetIPAddress -IPAddress 192.168.10.1 -PrefixLength 24 -InterfaceIndex $IndesID.ifIndex

#Builds the Actual Nat 
New-NetNat -Name $NetworName -InternalIPInterfaceAddressPrefix 192.168.10.0/24

#Connects all VM to NAT Network
Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName $SwitchName