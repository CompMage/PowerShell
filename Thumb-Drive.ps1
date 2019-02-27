Get-Disk | Where-Object -FilterScript {$_.Bustype -Eq "USB"}
#$DDis = Read-Host -Prompt "Select Disk to use"
$DDis = 2
Clear-Disk -Number $DDis -Confirm:$false -RemoveData
#New-Partition -DiskNumber $DDis -Size 30GB -AssignDriveLetter | Format-Volume -FileSystem Fat32
New-Partition -DiskNumber $DDis -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem Fat32
Get-Partition -DiskNumber $DDis | Set-Partition -NewDriveLetter P
 
Copy-Item "D:\WinPE_amd64\WinPE_w_tools\*" -Destination P:\ -Recurse -Force -Verbose