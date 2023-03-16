# Ver
$CSVPath = "C:\Working\VM\Server_Build.csv"



Function Write-Log($Message)
{
	# This function writes a log file with the specified message. 
	# If the log file does not already exist, it will create one. 
	
	# Check to see if log path exists
	$LogFolderTest = Test-Path "$Global:LocalLogPath"
	
	# If log folder does not exist, create one
	If ($LogFolderTest -eq $false)
	{
		# Create log file in log directory
		Try { New-Item -Path "$Global:LocalLogPath" -Type Directory -Force }
		Catch
		{
			# If an error occured during creation of the folder, note the log
			Write-Output "An error was detected while attempting to create the local log folder $Global:LocalLogPath"
			
			# Exit the script with failure 104
			Exit
		}
	}
	
	# Check to see if log file exists
	$LogFileTest = Test-Path "$Global:LocalLogPath\$Global:LogFileName"
	
	# If log file does not exist, create one
	If ($LogFileTest -eq $false)
	{
		# Create log file in log directory
		Try { New-Item -Path "$Global:LocalLogPath" -Type File -Name "$Global:LogFileName" }
		Catch
		{
			# If an error occured during creation of the folder, note the log
			Write-Output "An error was detected while attempting to create the local log file called $Global:LogFileName at $Global:LocalLogPath"
			
			# Exit the script with failure 104
			Exit
		}
	}
	
	# Format log message with date included
	$LogMessage = -join ($(Get-Date), ": ", $Message)
	
	# Update log file with message
	#Write-Output $LogMessage
	Add-Content -Path "$Global:LocalLogPath\$Global:LogFileName" -Value "$LogMessage"
}

Function Fun-CheckCSV {
   $CSVCheck = Test-Path -Path $CSVPath
   If ($CSVCheck = $true) {
    Write-Log "CSV Present. Working off $CSVPath"
   }
   Else {
    Write-Log "CSV Not Found, Creating File. Stopping Script."
    #Make Script Section
    Exit
   }
} #Source File Stuff

Function Fun-EnvLocation {
#Set Name for VM from File
$SysName = $LINE.VMName
    #Builds Folder Structure
    New-Item "C:\Working\VM\$SysName" -ItemType Directory
    New-Item "C:\Working\VM\$SysName\Virtual Machines" -ItemType Directory
    New-Item "C:\Working\VM\$SysName\Virtual Hard Disks" -ItemType Directory
    New-Item "C:\Working\VM\$SysName\Snapshots" -ItemType Directory
} #Where it's going to be

Function Fun-DHVDisk {
  If ($LINE.Parent -like $True)  
  {$SysName = $LINE.VMName
    New-VHD -ParentPath "C:\Working\VM\Virtual Hard Disks\Root_Server2022_Standard.vhdx" -Path "$LINE.VMLoc\$LINE.VMName\Virtual Hard Disks\Virtual Hard Disks\System_$LINE.VMName.vhdx" -Differencing 
    Write-Log "Building VHDX Differencing Disk from Server 2022 Standard Desktop Base."
    Write-Log "VHDX Created at $LINE.VMLoc"
  }
  Else {
    New-VHD -Path "$LINE.VMLoc\$LINE.VMName\Virtual Hard Disks\System_$LINE.VMName.vhdx" -SizeBytes $LINE.VMSystemVHD -Fixed:$LINE.Dynamic
    Write-Log "Building VHDX for System Base Drive"
    Write-Log "VHDX Created at $LINE.VMLoc"
  }
} #Drives

Function Func-Remove-System {
    #Marks the line SKIPPED if system is marked as LOCKED
    IF($LINE.Locked -eq $True) {
        $RowIndex = [array]::IndexOf($Source1.Index,"$LINE.LineList")
        $Source1[$RowIndex].OldRemoved = "SKIPPED"  
    } 
    Else {
    #Removes the VM from the HOST
        Write-Log "Stopping $LINE.VMName on Host $LINE.HostName."
        Stop-VM -Name $LINE.VMName -Force
        
        Write-Log "Removing $LINE.VMName on Host $LINE.HostName."
        Remove-VM $VMName -Confirm:$false -ErrorAction SilentlyContinue
        
        Write-Log "Removing Data Store of $LINE.VMName on Host $LINE.HostName."
        Remove-Item $VMLoc\$VMName -Recurse -Force -ErrorAction SilentlyContinue
        
        $RowIndex = [array]::IndexOf($Source1.Index,"$LINE.LineList")
        $Source1[$RowIndex].OldRemoved = "TRUE" 
    }
} #There can be only one

Function Build-System() {
  
  $RunningVM = Get-VM
  If(RunningVM.Name -Contains '$LINE.VMName'){
  #Write Error to Log
  }
  Else {
  #DO Stuff
  
New-VM -Name $LINE.VMName -Path $LINE.VMLoc -SwitchName $LINE.NetworkSwitch1 -MemoryStartupBytes $LINE.LRAM -NewVHDPath $LINE.VMLoc\$LINE.VMName\Drives\System_$LINE.VMName.vhdx -NewVHDSizeBytes $LINE.VMSystemVHD -Generation 2

Set-VM -VMName $LINE.VMName -MemoryStartupBytes $LINE.CRAM -MemoryMinimumBytes $LINE.MRAM -MemoryMaximumBytes $LINE.CRAM -ProcessorCount $LINE.VMProc

Set-VMMemory -VMName $LINE.VMName -Buffer 10 -Priority 50

Set-VMFirmware -VMName $LINE.VMName -EnableSecureBoot On -SecureBootTemplate MicrosoftWindows

# Extra Drives
New-VHD -Path $LINE.VMLoc\$LINE.VMName\Drives\Data_$LINE.VMName.vhdx -SizeBytes 100GB -Dynamic

Add-VMHardDiskDrive -VMName $LINE.VMName -Path $LINE.VMLoc\$LINE.VMName\Drives\Data_$LINE.VMName.vhdx -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 2

# DVD Drive Settings
Add-VMDvdDrive -VMName $LINE.VMName -ControllerNumber 0 -ControllerLocation 5

Set-VMDvdDrive -VMName $LINE.VMName -Path $LINE.ISOLoc

# Enable Resouse Monitoring. Disable if not used in environment.
Enable-VMResourceMetering -VMName $LINE.VMName

Set-VMHost -EnableEnhancedSessionMode $LINE.true
} #This END Error Check
} #This Build the VM

Function Set-VMNetworkConfiguration {
<#
DHCP:
Get-VMNetworkAdapter -VMName "VMNAME" -Name iSCSINet | Set-VMNetworkConfiguration -DHCP

Static IP
Get-VMNetworkAdapter -VMName VMNAME" -Name iSCSINet | Set-VMNetworkConfiguration -IPAddress 192.168.100.1 00 -Subnet 255.255.0.0 -DNSServer 192.168.100.101 -DefaultGateway 192.168.100.1
/#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName='DHCP',
                   ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName='Static',
                   ValueFromPipeline=$true)]
        [Microsoft.HyperV.PowerShell.VMNetworkAdapter]$NetworkAdapter,

        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName='Static')]
        [String[]]$IPAddress=@(),

        [Parameter(Mandatory=$false,
                   Position=2,
                   ParameterSetName='Static')]
        [String[]]$Subnet=@(),

        [Parameter(Mandatory=$false,
                   Position=3,
                   ParameterSetName='Static')]
        [String[]]$DefaultGateway = @(),

        [Parameter(Mandatory=$false,
                   Position=4,
                   ParameterSetName='Static')]
        [String[]]$DNSServer = @(),

        [Parameter(Mandatory=$false,
                   Position=0,
                   ParameterSetName='DHCP')]
        [Switch]$Dhcp
    )

    $VM = Get-WmiObject -Namespace 'root\virtualization\v2' -Class 'Msvm_ComputerSystem' | Where-Object { $_.ElementName -eq $NetworkAdapter.VMName } 
    $VMSettings = $vm.GetRelated('Msvm_VirtualSystemSettingData') | Where-Object { $_.VirtualSystemType -eq 'Microsoft:Hyper-V:System:Realized' }    
    $VMNetAdapters = $VMSettings.GetRelated('Msvm_SyntheticEthernetPortSettingData') 

    $NetworkSettings = @()
    foreach ($NetAdapter in $VMNetAdapters) {
        if ($NetAdapter.Address -eq $NetworkAdapter.MacAddress) {
            $NetworkSettings = $NetworkSettings + $NetAdapter.GetRelated("Msvm_GuestNetworkAdapterConfiguration")
        }
    }

    $NetworkSettings[0].IPAddresses = $IPAddress
    $NetworkSettings[0].Subnets = $Subnet
    $NetworkSettings[0].DefaultGateways = $DefaultGateway
    $NetworkSettings[0].DNSServers = $DNSServer
    $NetworkSettings[0].ProtocolIFType = 4096

    if ($dhcp) {
        $NetworkSettings[0].DHCPEnabled = $true
    } else {
        $NetworkSettings[0].DHCPEnabled = $false
    }

    $Service = Get-WmiObject -Class "Msvm_VirtualSystemManagementService" -Namespace "root\virtualization\v2"
    $setIP = $Service.SetGuestNetworkAdapterConfiguration($VM, $NetworkSettings[0].GetText(1))

    if ($setip.ReturnValue -eq 4096) {
        $job=[WMI]$setip.job 

        while ($job.JobState -eq 3 -or $job.JobState -eq 4) {
            start-sleep 1
            $job=[WMI]$setip.job
        }

        if ($job.JobState -eq 7) {
            write-host "Success"
        }
        else {
            $job.GetError()
        }
    } elseif($setip.ReturnValue -eq 0) {
        Write-Host "Success"
    }
}

Function Fun-Set-VMNetwork {
<#
DHCP:
Get-VMNetworkAdapter -VMName "VMNAME" -Name iSCSINet | Set-VMNetworkConfiguration -DHCP

Static IP
Get-VMNetworkAdapter -VMName "VMNAME" -Name iSCSINet | Set-VMNetworkConfiguration -IPAddress 192.168.100.1 00 -Subnet 255.255.0.0 -DNSServer 192.168.100.101 -DefaultGateway 192.168.100.1
/#>

If ($LINE.DHCP -eq "True")

Write-Log "Setting $LINE.VMName Network configuration to DHCP"
Get-VMNetworkAdapter -VMName $LINE.VMName | Set-VMNetworkConfiguration -DHCP
Else
Write-Log "Setting $LINE.VMName Network configuration to Static with the following configuration IPAddress $LINE.Net-IP Subnet $LINE.Net-SNM DefaultGateway $LINE.Net-GW DNSServer $LINE.DNS1"
Get-VMNetworkAdapter -VMName "VMNAME" | Set-VMNetworkConfiguration -IPAddress $LINE.Net-IP -Subnet $LINE.Net-SNM -DefaultGateway $LINE.Net-GW -DNSServer $LINE.DNS1
}


#Start-VM $VMName

$Source1 = Import-CSV C:\Working\Project\Hyper-V\Source.csv
foreach($LINE in $Source1)
    {
     $RowIndex = [array]::IndexOf($Source1.Index,"$LINE.LineList")
     $Source1[$RowIndex].OldRemoved = "TRUE"
     Func-Remove-System
                
    }







Function Fun-Set-VMNetworking {
#Check for VM

$Target = $Line.VMName

Invoke-Command -VMName $LINE.VMName -ScriptBlock { NetworkStuff }



}
