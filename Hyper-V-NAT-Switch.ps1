<#
By Christopher.Hermance
EMAIL cmhermance@gmail.com

This powershell script must be run as admin.

This script builds a virtual switch and then a asigns all vms to that switch.

Make sure 3rd Party firewalls such as McAfee, Avast or simular are set to trus the network or NAT may not wortk as expected.
Example.

DNS will travers but actual web traffic may not. 

/#>


#Variables
$SwitchName = "CMLab_Switch"
$NetworName = "CMLab_External"
$IPSpace = "192.168.10."
$Netmaskshort = "24"
$VLANID = "1234"

#Builds and Internal Switch
New-VMSwitch -SwitchName $SwitchName -SwitchType Internal

#Get the Network adaptrer information for the next step based on the last.
$IndesID = Get-NetAdapter -Name "vEthernet ($SwitchName)" 

#Assigns an IP address and subnetmask to thr Virtual Switch Network Adapter
New-NetIPAddress -IPAddress "$IPSpace.1" -PrefixLength $Netmaskshort -InterfaceIndex $IndesID.ifIndex

#Builds the Actual Nat 
New-NetNat -Name $NetworName -InternalIPInterfaceAddressPrefix "$IPSpace.0/$Netmaskshort"

#Connects all VM to NAT Network. Omit or Edit if only wishing to assign a single vm.
Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName $SwitchName

#For VLAN Access
#Get-VMNetworkAdapter -SwitchName $SwitchName -ManagementOS | Set-VMNetworkAdapterVlan -Access -VlanId $VLANID
#Get-VM| Get-VMNetworkAdapter | Set-VMNetworkAdapterVlan -Access -VlanId $VLANID 