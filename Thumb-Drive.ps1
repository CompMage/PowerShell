<#
By Christopher.Hermance
EMAIL cmhermance@gmail.com

This powershell script must be run as admin.

This script is for building thumb drives from ISO sources. This was orginally made to build WinPE
drives for imaging using OSD on SCCM/MECM/MDT. It works for others such as Base OS builds for 
Windows. 

/#>

#Removes Destination
Remove-Item C:\ISOMount -Recurse -Force -ErrorAction SilentlyContinue

#Makes Target Folder to Hold ISO
New-Item C:\ISOMount -ItemType 'Directory' -Force

Copy-Item -Path '\\SERVER\REPO-Share\ISO\CMBOOT.iso' -Destination 'C:\ISOMount\CMBOOT.iso'

$ImagePath1 = 'C:\ISOMount\CMBOOT.iso'

#Mounts the ISO
$ISODrive = (Get-DiskImage -ImagePath $ImagePath1 | Get-Volume).DriveLetter
IF (!$ISODrive) 
{
Mount-DiskImage -ImagePath $ImagePath1 -StorageType ISO
}
$ISODrive = (Get-DiskImage -ImagePath $ImagePath1 | Get-Volume).DriveLetter
Write-Host ('ISO Drive is ' + $ISODrive)

#List and Prompts for selection of USB Thumb Drive
Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"} | Format-Table FriendlyName,AllocatedSize,DiskNumber
$DDis = Read-Host -Prompt "Select Disk to use"

#Clears all data off disk. Warning no recovery
Clear-Disk -Number $DDis -Confirm:$false -RemoveData

#Gets Information Based on the thumb drive used.
$Thumb = Get-Disk -Number $DDis
$FormatSize = IF ($Thumb.Size -gt 32000000000) {"32_Plus"} Else {"32_Neg"}

#Sets a useable partition size based on size of thumb drive. 
Switch ($FormatSize) 
{
32_Plus {New-Partition -DiskNumber $DDis -Size 30GB -AssignDriveLetter | Format-Volume -FileSystem NTFS}
32_Neg {New-Partition -DiskNumber $DDis -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS}
}

#Mounts the Partition
Get-Partition -DiskNumber $DDis | Set-Partition -NewDriveLetter P

#Copy Copy Copy
Copy-Item $ISODrive`:\* -Destination P:\ -Recurse -Force -Verbose

#Clean Up
Dismount-DiskImage -ImagePath $ImagePath1

Remove-Item C:\ISOMount -Recurse -Force
