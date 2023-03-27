# Let there be light
# RSAT AD tools must be installed

$LABName = "Lab"
$LABDomain = "CMLab.Local" 
$LABDC = "CMLAB-DC01Core"

#Basic OU Structure
New-ADOrganizationalUnit -DisplayName "Lab" -Path "DC=CMLab,DC=Local"
New-ADOrganizationalUnit -DisplayName "Systems" -Path "OU=LAB,DC=CMLab,DC=Local"
New-ADOrganizationalUnit -DisplayName "Users" -Path "OU=LAB,DC=CMLab,DC=Local"
New-ADOrganizationalUnit -DisplayName "Groups" -Path "OU=LAB,DC=CMLab,DC=Local"

New-ADOrganizationalUnit -DisplayName "Servers" -Path "OU=Systems,OU=LAB,DC=CMLab,DC=Local"
New-ADOrganizationalUnit -DisplayName "Workstations" -Path "OU=Systems,OU=LAB,DC=CMLab,DC=Local"
New-ADOrganizationalUnit -DisplayName "Admin" -Path "OU=Systems,OU=LAB,DC=CMLab,DC=Local"



New-ADGroup -Name "LAB Admins" -SamAccountName LAB-Admins -GroupCategory Security -GroupScope Local -DisplayName "LAB Administrators" -Path "CN=Groups,DC=CMLab,DC=Local" -Description "Members of this group are LAB Administrators"
New-ADGroup -Name "LAB Servers" -SamAccountName LAB-Servers -GroupCategory Security -GroupScope Local -DisplayName "Servers" -Path "CN=Groups,DC=CMLab,DC=Local" -Description "Members of this group are LAB Administrators"
New-ADGroup -Name "LAB Workstations" -SamAccountName LAB-Workstations -GroupCategory Security -GroupScope Local -DisplayName "Workstations" -Path "CN=Groups,DC=CMLab,DC=Local" -Description "Members of this group are LAB Administrators"
New-ADGroup -Name "CA Admins" -SamAccountName CA-Admins -GroupCategory Security -GroupScope Local -DisplayName "Workstations" -Path "CN=Groups,DC=CMLab,DC=Local" -Description "Members of this group are LAB Administrators"
New-ADGroup -Name "LAB Admins" -SamAccountName MECM-Servers -GroupCategory Security -GroupScope Local -DisplayName "MECM-Servers" -Path "CN=Groups,DC=CMLab,DC=Local" -Description "Members of this group are LAB Administrators"
New-ADGroup -Name "LAB Admins" -SamAccountName MECM-Admins -GroupCategory Security -GroupScope Local -DisplayName "MECM-Admins" -Path "CN=Groups,DC=CMLab,DC=Local" -Description "Members of this group are LAB Administrators"
New-ADGroup -Name "LAB Admins" -SamAccountName MECM-Reports -GroupCategory Security -GroupScope Local -DisplayName "MECM-Reports" -Path "CN=Groups,DC=CMLab,DC=Local" -Description "Members of this group are LAB Administrators"



New-ADUser -SamAccountName "CompMage" -UserPrincipalName "CompMage" -Enabled $true -Path "OU=Users,OU=Lab,CN=CMLAB,CN=Local" -ChangePasswordAtLogon $true -AccountPassword (convertto-securestring $password -AsPlainText -Force)
New-ADUser -SamAccountName "Service-MECM" -UserPrincipalName "Service-MECM" -Enabled $true -Path "OU=Users,OU=Lab,CN=CMLAB,CN=Local" -ChangePasswordAtLogon $true -AccountPassword (convertto-securestring $password -AsPlainText -Force)
New-ADUser -SamAccountName "Service-CA" -UserPrincipalName "Service-CA" -Enabled $true -Path "OU=Users,OU=Lab,CN=CMLAB,CN=Local" -ChangePasswordAtLogon $true -AccountPassword (convertto-securestring $password -AsPlainText -Force)
New-ADUser -SamAccountName "BaseUser1" -UserPrincipalName "BaseUser1" -Enabled $false -Path "OU=Users,OU=Lab,CN=CMLAB,CN=Local" -ChangePasswordAtLogon $true -AccountPassword (convertto-securestring $password -AsPlainText -Force)
New-ADUser -SamAccountName "BaseUser2" -UserPrincipalName "BaseUser2" -Enabled $false -Path "OU=Users,OU=Lab,CN=CMLAB,CN=Local" -ChangePasswordAtLogon $true -AccountPassword (convertto-securestring $password -AsPlainText -Force)
New-ADUser -SamAccountName "BaseUser3" -UserPrincipalName "BaseUser3" -Enabled $false -Path "OU=Users,OU=Lab,CN=CMLAB,CN=Local" -ChangePasswordAtLogon $true -AccountPassword (convertto-securestring $password -AsPlainText -Force)
