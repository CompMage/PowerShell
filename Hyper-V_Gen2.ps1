# Variables
$CLI1 = "2016_Test"		           # Name of VM running Client Operating System
$VMProc = 2
$CRAM = 8GB				                       # RAM assigned to Client Operating System
$MRAM = 4GB                                    # Min Memory Size
$CLI1VHD = 60GB				                   # Size of Hard-Drive for Client Operating System
$VMLOC = "D:\Working\VM"			           # Location of the VM and VHDX files
$NetworkSwitch1 = "HQ - Virtual Switch"	       # Name of the Network Switch
$CMBOOT = "D:\Working\ISO\14393.0.161119-1705.RS1_REFRESH_SERVERHYPERCORE_OEM_X64FRE_EN-US.ISO"	# Installer / Booter


# Create VM Folder and Network Switch
MD $VMLOC -ErrorAction SilentlyContinue
$TestSwitch = Get-VMSwitch -Name $NetworkSwitch1 -ErrorAction SilentlyContinue; if ($TestSwitch.Count -EQ 0){New-VMSwitch -Name $NetworkSwitch1 -SwitchType Private}

# Create Virtual Machines
New-VM -Name $CLI1 -Path $VMLOC -MemoryStartupBytes $CRAM -SwitchName $NetworkSwitch1 -NewVHDPath $VMLOC\$CLI1\Drives\$CLI1.vhdx -NewVHDSizeBytes $CLI1VHD -Generation 2

Set-VMProcessor -VMName $CLI1 -Count 2

Set-VM -VMName $CLI1 -MemoryStartupBytes $CRAM -DynamicMemory -MemoryMinimumBytes $MRAM -MemoryMaximumBytes $CRAM

Set-VMMemory -VMName $CLI1 -Buffer 10 -Priority 50

# DVD Drive Settings
Add-VMDvdDrive -VMName $CLI1 -ControllerNumber 0 -ControllerLocation 5

Set-VMDvdDrive -VMName $CLI1 -Path $CMBOOT

# Enable Resouse Monitoring. Disable if not used in environment.
Enable-VMResourceMetering -VMName $CLI1

#Start-VM $CLI1