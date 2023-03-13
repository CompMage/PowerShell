# Variables
$CRAM = 8GB
$LRAM = 2GB
$MRAM = 4GB
$VMName = "1809_Test_3"		           # Name of VM running Client Operating System
$VMProc = 2
$VMRam = 8GB				                       # RAM assigned to Client Operating System
$VMLRam = 2GB                                    # Min Memory Size
$VMSystemVHD = 60GB				                   # Size of Hard-Drive for Client Operating System
$VMLoc = "D:\Working\VM"			           # Location of the VM and VHDX files

$NetworkSwitch1 = "HQ - Virtual Switch"	       # Name of the Network Switch
$ISOLoc= "D:\Working\ISO\CMBoot_19.iso"	# Installer / Booter

Remove-VM $VMName -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item $VMLoc\$VMName -Recurse -Force -ErrorAction SilentlyContinue

# Create Virtual Machines
New-VM -Name $VMName -Path $VMLoc -SwitchName $NetworkSwitch1 -MemoryStartupBytes $LRAM -NewVHDPath $VMLoc\$VMName\Drives\System_$VMName.vhdx -NewVHDSizeBytes $VMSystemVHD -Generation 2

Set-VM -VMName $VMName -MemoryStartupBytes $CRAM -MemoryMinimumBytes $MRAM -MemoryMaximumBytes $CRAM -ProcessorCount $VMProc

Set-VMMemory -VMName $VMName -Buffer 10 -Priority 50

Set-VMFirmware -VMName $VMName -EnableSecureBoot On -SecureBootTemplate MicrosoftWindows

# Extra Drives
New-VHD -Path $VMLoc\$VMName\Drives\Data_$VMName.vhdx -SizeBytes 100GB -Dynamic

Add-VMHardDiskDrive -VMName $VMName -Path $VMLoc\$VMName\Drives\Data_$VMName.vhdx -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 2

# DVD Drive Settings
Add-VMDvdDrive -VMName $VMName -ControllerNumber 0 -ControllerLocation 5

Set-VMDvdDrive -VMName $VMName -Path $ISOLoc

# Enable Resouse Monitoring. Disable if not used in environment.
Enable-VMResourceMetering -VMName $VMName

Set-VMHost -EnableEnhancedSessionMode $true

Start-VM $VMName