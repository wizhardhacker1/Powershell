$Computers = (Get-ADComputer -Filter *).count
$Workstations = (Get-ADComputer -LDAPFilter "(&(objectClass=Computer)(!operatingSystem=*server*))" -Searchbase (Get-ADDomain).distinguishedName).count
$Servers = (Get-ADComputer -LDAPFilter "(&(objectClass=Computer)(operatingSystem=*server*))" -Searchbase (Get-ADDomain).distinguishedName).count

Write-Host "Computers =      "$Computers
Write-Host "Workstions =     "$Workstations
Write-Host "Servers =        "$Servers 