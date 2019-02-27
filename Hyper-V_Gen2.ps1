# This script configures the Hyper-V machines used for the 50331 Course.
# PowerShell 3.0 and Windows Server 2012 or Windows 8 Pro are required to perform this setup.
# The C:\ Drive should have at least 200GB of free space available.
# All the files on the 50331 Student CD should be copied to C:\Labfiles before performing this setup.

# Variables
$CLI1 = "SILCIO-X-CMHER4"		# Name of VM running Client Operating System
$CRAM = 8GB				                # RAM assigned to Client Operating System
$CLI1VHD = 60GB				                # Size of Hard-Drive for Client Operating System
$VMLOC = "D:\Working\VM"			        # Location of the VM and VHDX files
$NetworkSwitch1 = "PrivateSwitch1"	# Name of the Network Switch
$CMBOOT = "D:\Working\ISO\HQ2_Exp_CMBOOT.iso"	# PE SCCM Booter


# Create VM Folder and Network Switch
MD $VMLOC -ErrorAction SilentlyContinue
$TestSwitch = Get-VMSwitch -Name $NetworkSwitch1 -ErrorAction SilentlyContinue; if ($TestSwitch.Count -EQ 0){New-VMSwitch -Name $NetworkSwitch1 -SwitchType Private}

# Create Virtual Machines
New-VM -Name $CLI1 -Path $VMLOC -MemoryStartupBytes $CRAM -NewVHDPath $VMLOC\$CLI1.vhdx -NewVHDSizeBytes $CLI1VHD -SwitchName $NetworkSwitch1

# Configure Virtual Machines
Set-VMDvdDrive -VMName $CLI1 -Path $CMBOOT

# Settings
Set-VMProcessor -VMName $CLT1 -Count 2 -Reserve 10 -Maximum 85

Start-VM $CLI1