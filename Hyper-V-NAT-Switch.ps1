<#
By Christopher.Hermance
EMAIL cmhermance@gmail.com

This powershell script must be run as admin.

This script builds a virtual switch and then a asigns all vms to that switch.

/#>


﻿#Vegetables
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

#Connects all VM to NAT Network. Omit or Edit if only wishing to assign a single vm.
Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName $SwitchName