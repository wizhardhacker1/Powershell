# Import Active Directory and setup path as well supress error" 
New-Item -itemType Directory -Path C:\BGInfo
$ErrorActionPreference = ‘SilentlyContinue’
import-module ActiveDirectory

 
# gather versions of operating systems from AD see the bottom of the script for a version list
$version= "6.0*"

#grabs the version selected for active direcory
Get-ADComputer -Filter * -Property OperatingSystemVersion,Name | where {$_.OperatingSystemVersion -like $version} | select-object Name |Out-File  C:\BGInfo\spacingversion.txt 

#remove spacing from file and create clean
Get-Content "C:\BGInfo\spacingversion.txt"  | Foreach {$_.TrimEnd()} |Out-File  C:\BGInfo\cleanversion.txt 

#remove top 3 lines of AD junk
Get-Content C:\BGInfo\spacingversion.txt  | Select-Object -Skip 1 | Foreach {$_.TrimEnd()} | Out-File C:\BGInfo\cleanversion.txt
Get-Content C:\BGInfo\spacingversion.txt  | Select-Object -Skip 2 | Foreach {$_.TrimEnd()} | Out-File C:\BGInfo\cleanversion.txt
Get-Content C:\BGInfo\spacingversion.txt  | Select-Object -Skip 3 | Foreach {$_.TrimEnd()} | Out-File C:\BGInfo\cleanversion.txt

#remove all blank spaces and lines at the end of the file
Get-Content "C:\BGInfo\cleanversion.txt" | Where { $_.Replace(";","") -ne "" } | Out-File C:\BGInfo\ready.txt



#take the file and scan each hostname to see if it is active currently

write -----------------------------------------------------------------------------------------------
write ------------"Starting HOST Network Test for windows version $version"--------------------------
write -----------------------------------------------------------------------------------------------

$complist = Get-Content "C:\BGInfo\ready.txt"
foreach($comp in $complist){
    
    $pingtest = Test-Connection -ComputerName $comp -Quiet -Count 1 -ErrorAction SilentlyContinue
    if($pingtest){
         Write-Host  ($comp + " is online") 
     }
     else{
        Write-Host ($comp + " is not reachable") 

      
     }
     
    
    
}



#this is the warning for the script below 
write -----------------------------------------------------------------------------------------------
write -----------------------------------------------------------------------------------------------
write "Please wait within 3 minutes the CSV should come startup - If not Go to c:\BGinfo\host-ip "
write -----------------------------------------------------------------------------------------------
write -----------------------------------------------------------------------------------------------

#this script takes the file and its contents and gives you the ip and and its status in a csv
$counter = 3
$comps = get-content "C:\BGInfo\ready.txt"
$dnsResults = "C:\BGinfo\host-ip.csv"

function get-dnsres{
foreach ($comp in $comps) {
$TempIP = ([system.net.dns]::GetHostAddresses($comp)) | select IPAddressToString

$status = "Processing system {0} of {1}: {2}" -f $counter,$comps.Count,$comp

#below is a progress bar if you want to see it -  I perfer not
#Write-Progress 'Resolving DNS' $status -PercentComplete ($counter/$comps.count * 0)
$counter++
$comp |
select @{Name='ComputerName';Expression={$comp}}, `
@{Name='ResolvesToIP';Expression={[system.net.dns]::GetHostAddresses($comp)}}, `
@{Name='IPResolvesTo';Expression={([system.net.dns]::GetHostEntry($TempIP.IPAddressToString)).HostName}}, `
@{Name='PingStatus'; Expression={ `
if ((get-wmiobject -query "SELECT * FROM Win32_PingStatus WHERE Address='$comp'").statuscode -eq 0) {'Host Online'} `
elseif ((get-wmiobject -query "SELECT * FROM Win32_PingStatus WHERE Address='$comp'").statuscode -eq 11003) {'Destination Host Unreachable'} `
elseif ((get-wmiobject -query "SELECT * FROM Win32_PingStatus WHERE Address='$comp'").statuscode -eq 11010) {'Request Timed Out'} `
elseif ((get-wmiobject -query "SELECT * FROM Win32_PingStatus WHERE Address='$comp'").statuscode -eq $Null) {'NoDNS'}
}
}
}
}

get-dnsres | export-csv $dnsResults -notypeinformation
invoke-item $dnsResults





#cleanup files
 Remove-Item -Force -Path C:\BGInfo\ready.txt
 Remove-Item -Force -Path C:\BGInfo\cleanversion.txt
 Remove-Item -Force -Path C:\BGInfo\spacingversion.txt
 write ---------------------------------------------------------------------------------------
 Read-Host -Prompt "Press any key to Close"



#   ** The list of Operating system versions to to search for in AD **

# Operating system	Version number
# Windows 11	10.0*
# Windows 10	10.0*
# Windows Server 2022	10.0*
# Windows Server 2019	10.0*
# Windows Server 2016	10.0*
# Windows 8.1	6.3*
# Windows Server 2012 R2	6.3*
# Windows 8	6.2
# Windows Server 2012	6.2
# Windows 7	6.1
# Windows Server 2008 R2	6.1
# Windows Server 2008	6.0
# Windows Vista	6.0
# Windows Server 2003 R2	5.2
# Windows Server 2003	5.2
# Windows XP 64-Bit Edition	5.2
# Windows XP	5.1
# Windows 2000	5.0