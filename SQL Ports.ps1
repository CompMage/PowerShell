Write-host "========= SQL Server Ports ==================="
 
Write-host "Enabling SQLServer default instance port 1433"
 
#netsh firewall set portopening TCP 1433 "SQLServer"
 
New-NetFirewallRule -DisplayName "Allow inbound TCP Port 1433" -Group "SQL Server Ports" –Direction inbound –LocalPort 1433 -Protocol TCP -Action Allow
 
New-NetFirewallRule -DisplayName "Allow outbound TCP Port 1433" -Group "SQL Server Ports" –Direction outbound –LocalPort 1433 -Protocol TCP -Action Allow
 
Write-host "Enabling Dedicated Admin Connection port 1434"
 
#netsh firewall set portopening TCP 1434 "SQL Admin Connection"
 
New-NetFirewallRule -DisplayName "Allow inbound TCP Port 1434" -Group "SQL Server Ports" -Direction inbound –LocalPort 1434 -Protocol TCP -Action Allow
 
New-NetFirewallRule -DisplayName "Allow outbound TCP Port 1434" -Group "SQL Server Ports" -Direction outbound –LocalPort 1434 -Protocol TCP -Action Allow
 
Write-host "Enabling conventional SQL Server Service Broker port 4022"
 
#netsh firewall set portopening TCP 4022 "SQL Service Broker"
 
New-NetFirewallRule -DisplayName "Allow inbound TCP Port 4022" -Group "SQL Server Ports" -Direction inbound –LocalPort 4022 -Protocol TCP -Action Allow
 
New-NetFirewallRule -DisplayName "Allow outbound TCP Port 4022" -Group "SQL Server Ports" -Direction outbound –LocalPort 4022 -Protocol TCP -Action Allow
 
Write-host "Enabling Transact-SQL Debugger/RPC port 135"
 
#netsh firewall set portopening TCP 135 "SQL Debugger/RPC"
 
New-NetFirewallRule -DisplayName "Allow inbound TCP Port 135" -Group "SQL Server Ports" -Direction inbound –LocalPort 135 -Protocol TCP -Action Allow
 
New-NetFirewallRule -DisplayName "Allow outbound TCP Port 135" -Group "SQL Server Ports" -Direction outbound –LocalPort 135 -Protocol TCP -Action Allow

Write-host "Enabling port for SQL Server Browser Service's 'Browse"

#netsh firewall set portopening UDP 1434 "SQL Browser"
 
New-NetFirewallRule -DisplayName "Allow inbound UDP Port 1434" -Group "SQL Server Ports" -Direction inbound –LocalPort 1434 -Protocol UDP -Action Allow
 
New-NetFirewallRule -DisplayName "Allow outbound UDP Port 1434" -Group "SQL Server Ports" -Direction outbound –LocalPort 1434 -Protocol UDP -Action Allow
 
Write-host "========= Analysis Services Ports =============="
 
Write-host "Enabling SSAS Default Instance port 2383"
 
#netsh firewall set portopening TCP 2383 "Analysis Services"
 
New-NetFirewallRule -DisplayName "Allow inbound TCP Port 2383" -Group "SQL Analysis Services Ports" -Direction inbound –LocalPort 2383 -Protocol TCP -Action Allow
 
New-NetFirewallRule -DisplayName "Allow outbound TCP Port 2383" -Group "SQL Analysis Services Ports" -Direction outbound –LocalPort 2383 -Protocol TCP -Action Allow
 
Write-host "Enabling SQL Server Browser Service port 2382"
 
#netsh firewall set portopening TCP 2382 "SQL Browser"
 
New-NetFirewallRule -DisplayName "Allow inbound TCP Port 2382" -Group "SQL Analysis Services Ports" -Direction inbound –LocalPort 2382 -Protocol TCP -Action Allow
 
New-NetFirewallRule -DisplayName "Allow outbound TCP Port 2382" -Group "SQL Analysis Services Ports" -Direction outbound –LocalPort 2382 -Protocol TCP -Action Allow
 
Write-host "========= Misc Applications =============="
 
Write-host "Enabling HTTP port 80"
 
#netsh firewall set portopening TCP 80 "HTTP"
 
New-NetFirewallRule -DisplayName "Allow inbound TCP Port 80" -Direction inbound –LocalPort 80 -Protocol TCP -Action Allow
 
New-NetFirewallRule -DisplayName "Allow outbound TCP Port 80" -Direction outbound –LocalPort 80 -Protocol TCP -Action Allow
 
Write-host "Enabling SSL port 443"
 
#netsh firewall set portopening TCP 443 "SSL"
 
New-NetFirewallRule -DisplayName "Allow inbound TCP Port 443" -Direction inbound –LocalPort 443 -Protocol TCP -Action Allow
 
New-NetFirewallRule -DisplayName "Allow outbound TCP Port 443" -Direction outbound –LocalPort 443 -Protocol TCP -Action Allow
 

 
