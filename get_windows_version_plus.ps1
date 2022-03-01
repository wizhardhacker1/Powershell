# Import Active Directory in powershell
import-module ActiveDirectory


 
# gather versions of operating systems from AD 
Get-ADComputer -Filter * -Property OperatingSystemVersion,Name | where {$_.OperatingSystemVersion -like "5.1*"} | select-object Name |Out-File  C:\BGInfo\spacingversion.txt 

#remove spacing from file and create clean
Get-Content "C:\BGInfo\spacingversion.txt"  | Foreach {$_.TrimEnd()} |Out-File  C:\BGInfo\cleanversion.txt 

#remove top 3 lines of AD junk
Get-Content C:\BGInfo\spacingversion.txt  | Select-Object -Skip 1 | Out-File C:\BGInfo\cleanversion.txt
Get-Content C:\BGInfo\spacingversion.txt  | Select-Object -Skip 2 | Out-File C:\BGInfo\cleanversion.txt
Get-Content C:\BGInfo\spacingversion.txt  | Select-Object -Skip 3 | Out-File C:\BGInfo\cleanversion.txt

#remove all blank spaces and lines at the end of the file
Get-Content "C:\BGInfo\cleanversion.txt" | Where { $_.Replace(";","") -ne "" } | Out-File C:\BGInfo\ready.txt



#take the file and scan each hostname to see if it is active currently

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

#cleanup files
 Remove-Item -Force -Path C:\BGInfo\ready.txt
 Remove-Item -Force -Path C:\BGInfo\cleanversion.txt
 Remove-Item -Force -Path C:\BGInfo\spacingversion.txt



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