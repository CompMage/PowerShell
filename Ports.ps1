$CompList = Get-Content D:\Working\sccm_servers.txt
$PortRange = 80,443,445

Foreach ($server in $CompList)
    {
    Test-Connection -ComputerName $server -Count 1 | Format-Table -AutoSize -ErrorAction Continue
    Foreach ($Port in $PortRange)
        {
        $Socket = New-Object Net.Sockets.TcpClient
        $ErrorActionPreference = 'SilentlyContinue'
        $Socket.Connect($server, $Port)
        if ($Socket.Connected)
           {
           Write-Host "Connected on port $Port on Server $server" -ForegroundColor Green
           $socket.Close()
           }
        else
           {
           Write-Host "Connection on port $Port failed on Server $server" -ForegroundColor Red
           }        
    }
    Test-WSMan $server
}