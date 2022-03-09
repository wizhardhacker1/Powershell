

#install DSinternals from manually from https://github.com/MichaelGrafnetter/DSInternals
Install-Module DSInternals -Force



write -----------------------------------------------------------------------------------------------
write -------------!!!Creating Folders!!!---------------------
write -----------------------------------------------------------------------------------------------
#Create folder for download

$FolderName = "C:\DAS_Tools"
if (Test-Path $FolderName) {
   
    Write-Host "Folder Already Exists"
    # Perform Delete file from folder operation
}
else
{
  
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory
    Write-Host "Folder Created successfully"
}




$FolderName = "C:\DAS_Tools\SecurityRisks\"
if (Test-Path $FolderName) {
   
    Write-Host "Folder Already Exists"
    # Perform Delete file from folder operation
}
else
{
  
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory
    Write-Host "Folder Created successfully"
}



#Create folder for download

$FolderName = "C:\DAS_Tools\NMAP-Download\"
if (Test-Path $FolderName) {
   
    Write-Host "Folder Already Exists"
    # Perform Delete file from folder operation
}
else
{
  
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory
    Write-Host "Folder Created successfully"
}



write -----------------------------------------------------------------------------------------------
write -------------!!!Downloading NMAP!!!---------------------
write -----------------------------------------------------------------------------------------------
#download NMAP

# Source file location
$source = 'https://nmap.org/dist/nmap-7.80-setup.exe'
# Destination to save the file
$destination = 'C:\DAS_Tools\NMAP-Download\nmap-7.80-setup.exe'
#Download the file
Invoke-WebRequest -Uri $source -OutFile $destination



write -----------------------------------------------------------------------------------------------
write -------------!!!Installing NMAP-CLICK YES!!!---------------------
write -----------------------------------------------------------------------------------------------
#Install NMAP

$CurrentLocation = "C:\DAS_Tools\NMAP-Download\" 
$exe = "nmap-7.80-setup.exe"
Start-Process -FilePath $CurrentLocation\$exe -ArgumentList "/S" -wait 


write -----------------------------------------------------------------------------------------------
write -------------!!! Downloading custom NSEs !!!---------------------
write -----------------------------------------------------------------------------------------------

#Download Custom NSEs

# Source file location
$source = 'https://pastebin.com/raw/YBewdfj0'
# Destination to save the file
$destination = 'C:\DAS_Tools\NMAP-Download\smtp-vuln-cve2020-28017-through-28026-21nails.nse'
Invoke-WebRequest -Uri $source -OutFile $destination

# Source file location
$source = 'https://pastebin.com/raw/eFgkVEDx'
# Destination to save the file
$destination = 'C:\DAS_Tools\NMAP-Download\mysql-auth-bypass.nse'
Invoke-WebRequest -Uri $source -OutFile $destination



write -----------------------------------------------------------------------------------------------
write -------------!!! UPDATE NMAP Database !!!---------------------
write -----------------------------------------------------------------------------------------------

Nmap  --script-updatedb


write -----------------------------------------------------------------------------------------------
write -------------!!! Download Custom Powershell scripts!!!---------------------
write -----------------------------------------------------------------------------------------------

#download custom powershell files

# Source file location
$source = 'https://pastebin.com/raw/a1CyDqic'
# Destination to save the file
$destination = 'C:\DAS_Tools\NMAP-Download\Get-UnlinkedGPO.ps1'
Invoke-WebRequest -Uri $source -OutFile $destination

# Source file location
$source = 'https://pastebin.com/raw/KtVdnasd'
# Destination to save the file
$destination = 'C:\DAS_Tools\NMAP-Download\get-machinecount.ps1'
Invoke-WebRequest -Uri $source -OutFile $destination

# Source file location
$source = 'https://pastebin.com/raw/SdVbmAp5'
# Destination to save the file
$destination = 'C:\DAS_Tools\NMAP-Download\Get-GPOsLinkedToEmptyOUs.ps1'
Invoke-WebRequest -Uri $source -OutFile $destination

# Source file location
$source = 'https://pastebin.com/raw/7TKfRVm2'
# Destination to save the file
$destination = 'C:\DAS_Tools\NMAP-Download\Get-GPOExtraRegistry.ps1'
Invoke-WebRequest -Uri $source -OutFile $destination

# Source file location
$source = 'https://pastebin.com/raw/hdeTMBLM'
# Destination to save the file
$destination = 'C:\DAS_Tools\NMAP-Download\Get-EmptyGPO.ps1'
Invoke-WebRequest -Uri $source -OutFile $destination

# Source file location
$source = 'https://pastebin.com/raw/HgxfvA1F'
# Destination to save the file
$destination = 'C:\DAS_Tools\NMAP-Download\Get-DomainAdmins.ps1'
Invoke-WebRequest -Uri $source -OutFile $destination




write -----------------------------------------------------------------------------------------------
write -------------!!! Creating Folder for results!!!---------------------
write -----------------------------------------------------------------------------------------------

#Create folder for for results

$FolderName = "C:\DAS_Tools\SecurityRisks"
if (Test-Path $FolderName) {
   
    Write-Host "Folder Already Exists"
    # Perform Delete file from folder operation
}
else
{
  
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory
    Write-Host "Folder Created successfully"
}





# NMAP SCANS TO COMPLETE
write -----------------------------------------------------------------------------------------------
write ----------------------- Gather information for NMAP scans ------------------------------------- 
write -----------------------------------------------------------------------------------------------
$hosts=Read-Host "Please enter network to scan"
$sub=Read-Host "Please enter subnet example: 24"


cmd.exe /c dir c:\|Tee-Object C:\DAS_Tools\SecurityRisks\log4jscan$hosts.txt

write --------------------------------------------------------------
write --------------------  Scanning for Log4J  --------------------       
write --------------------------------------------------------------
C:'\Program Files (x86)'\Nmap\nmap.exe  -p 80,443,631,7080,8080,8443,8088,5800,3872,8180,8000 --script http-vuln-cve2017-5638 $hosts/$sub  |Tee-Object C:\DAS_Tools\SecurityRisks\log4jscan$hosts.txt




cmd.exe /c dir c:\|Tee-Object C:\DAS_Tools\SecurityRisks\EternalBluescan$hosts.txt
write --------------------------------------------------------------------------
write --------------------   Scanning for EternalBlue --------------------------          
write --------------------------------------------------------------------------
C:'\Program Files (x86)'\Nmap\nmap.exe  -p 445 --script smb-vuln-ms17-010 $hosts/$sub  |Tee-Object C:\DAS_Tools\SecurityRisks\EternalBluescan$hosts.txt




cmd.exe /c dir c:\|Tee-Object C:\DAS_Tools\SecurityRisks\BlueKeepscan$hosts.txt

write ------------------------------------------------------------------
write --------------------- Scanning for BlueKeep  ---------------------          
write ------------------------------------------------------------------
C:'\Program Files (x86)'\Nmap\nmap.exe  -sV --script=rdp-vuln-ms12-020 -p 3389 $hosts/$sub |Tee-Object C:\DAS_Tools\SecurityRisks\BlueKeepscan$hosts.txt




cmd.exe /c dir c:\|Tee-Object C:\DAS_Tools\SecurityRisks\HeartBleed$hosts.txt

write ---------------------------------------------------------------------
write --------------------  Scanning for HeartBleed -----------------------      
write ---------------------------------------------------------------------
C:'\Program Files (x86)'\Nmap\nmap.exe  -p 443 --script ssl-heartbleed $hosts/$sub |Tee-Object C:\DAS_Tools\SecurityRisks\HeartBleed$hosts.txt



cmd.exe /c dir c:\|Tee-Object C:\DAS_Tools\SecurityRisks\HeartBleed$hosts.txt

write -------------------------------------------------------------------
write --------------------- Scanning for HeartBleed ---------------------       
write -------------------------------------------------------------------
C:'\Program Files (x86)'\Nmap\nmap.exe  -p 443 --script ssl-heartbleed $hosts/$sub |Tee-Object C:\DAS_Tools\SecurityRisks\HeartBleed$hosts.txt




cmd.exe /c dir c:\|Tee-Object C:\DAS_Tools\SecurityRisks\cve2020-28017-through-28026-21-$hosts.txt

write -------------------------------------------------------------------------------------
write -------------------- Scanning for cve2020-28017-through-28026-21 --------------------   
write -------------------------------------------------------------------------------------
C:'\Program Files (x86)'\Nmap\nmap.exe  --script C:\DAS_Tools\NMAP-Download\smtp-vuln-cve2020-28017-through-28026-21nails.nse $hosts/$sub |Tee-Object C:\DAS_Tools\SecurityRisks\cve2020-28017-through-28026-21-$hosts.txt





cmd.exe /c dir c:\|Tee-Object C:\DAS_Tools\SecurityRisks\mysql-auth-bypass-$hosts.txt
write ------------------------------------------------------------------------
write -------------------- Scanning for mysql-auth-bypass --------------------    
write ------------------------------------------------------------------------
C:'\Program Files (x86)'\Nmap\nmap.exe -sV -p 3306 --script C:\DAS_Tools\NMAP-Download\mysql-auth-bypass.nse $hosts/$sub |Tee-Object C:\DAS_Tools\SecurityRisks\mysql-auth-bypass-$hosts.txt



cmd.exe /c dir c:\|Tee-Object C:\DAS_Tools\SecurityRisks\mysql-auth-bypass-$hosts.txt
write ---------------------------------------------
write          - Scanning for mysql-auth-bypass  -    
write ---------------------------------------------
C:'\Program Files (x86)'\Nmap\nmap.exe -sV -p 3306 --script C:\DAS_Tools\NMAP-Download\mysql-auth-bypass.nse $hosts/$sub |Tee-Object C:\DAS_Tools\SecurityRisks\mysql-auth-bypass-$hosts.txt





cmd.exe /c dir c:\|Tee-Object C:\DAS_Tools\SecurityRisks\Vulners-$hosts.txt
write --------------------------------------------------------------------
write --------------------- Scanning for vulners.nse ---------------------   
write --------------------- https://github.com/scipag --------------------- 
write ---------------------------------------------------------------------
C:'\Program Files (x86)'\Nmap\nmap.exe -sV --version-light  --script vulners.nse [--script-args mincvss=<arg_val>] $hosts/$sub |Tee-Object C:\DAS_Tools\SecurityRisks\Vulners-$hosts.txt




write -----------------------------------------------------------------------------------------------
write -------------!!! This is the of NMAP Scans moving to AD Security Risks !!!---------------------
write -----------------------------------------------------------------------------------------------

#Create weak password file
New-Item C:\DAS_Tools\NMAP-Download\weakpasswords.txt
#creating file and adding 1  password to file. ADD TYOUR own files
Set-Content C:\DAS_Tools\NMAP-Download\weakpasswords.txt 'P@ssw0rd!'


write -----------------------------------------------------------------------------------------------
write -------------!!! Getting Server and workstation counts!!!---------------------
write -----------------------------------------------------------------------------------------------

#Get Computer and Server counts
powershell C:\DAS_Tools\NMAP-Download\get-machinecount.ps1 > C:\DAS_Tools\SecurityRisks\servers_Workstation_counts.txt


write -----------------------------------------------------------------------------------------------
write -------------!!! Getting Computer Accounts no Passwords !!!---------------------
write -----------------------------------------------------------------------------------------------

#Getting Computer Accounts no Passwords
Get-ADComputer -Filter {((Enabled -eq $true) -and (PasswordNotRequired -eq $true))} -Properties PasswordLastSet  | Export-Csv -Path C:\DAS_Tools\SecurityRisks\computer_noPass.csv



write -----------------------------------------------------------------------------------------------
write -------------!!! Getting Empty GPOs !!!---------------------
write -----------------------------------------------------------------------------------------------

#Empty GPOs
powershell C:\DAS_Tools\NMAP-Download\Get-EmptyGPO.ps1 > C:\DAS_Tools\SecurityRisks\EmptyGPO.txt


write -----------------------------------------------------------------------------------------------
write -------------!!! Getting GPOs with extra Reg Keys !!!---------------------
write -----------------------------------------------------------------------------------------------

#GPO with Extra Registry
powershell C:\DAS_Tools\NMAP-Download\Get-GPOExtraRegistry.ps1 > C:\DAS_Tools\SecurityRisks\GPOExtraRegistry.txt


write -----------------------------------------------------------------------------------------------
write -------------!!! Getting GPOS Linked to empty OUs !!!---------------------
write -----------------------------------------------------------------------------------------------

#GPOs Linked To Empty OUs
powershell C:\DAS_Tools\NMAP-Download\Get-GPOsLinkedToEmptyOUs.ps1 > C:\DAS_Tools\SecurityRisks\GPOsLinkedToEmptyOUs.txt



write -----------------------------------------------------------------------------------------------
write -------------!!! Getting Unlinked GPOs !!!---------------------
write -----------------------------------------------------------------------------------------------

#Unlinked GPOs
powershell C:\DAS_Tools\NMAP-Download\Get-UnlinkedGPO.ps1 > C:\DAS_Tools\SecurityRisks\UnlinkedGPO.txt


write -----------------------------------------------------------------------------------------------
write -------------!!! Getting DOMAIN ADMIN users information !!!---------------------
write -----------------------------------------------------------------------------------------------

#Gather Domain Admins
Get-ADGroupMember -Identity "Domain Admins" | Get-ADUser -Properties PasswordLastSet | Select-Object -Property Name, PasswordLastSet > C:\DAS_Tools\SecurityRisks\DomainAdminInfo.txt



#check for weak passwords
write -----------------------------------------------------------------------------------------------
write ----------------------- WE ARE CHECKING  WEAK AND PASSWORD SECURITY ---------------------------
write -----------------------------------------------------------------------------------------------
$DictFile = "C:\DAS_Tools\NMAP-Download\weakpasswords.txt"
$DC=Read-Host "Please enter AD Server"
$Domain=Read-Host "Enter OU | example: DC=ROOT,DC=DOMAIN,DC=ORG"

Get-ADReplAccount -All -Server $DC -NamingContext $Domain | Test-PasswordQuality -WeakPasswordsFile $DictFile > C:\DAS_Tools\SecurityRisks\weakpasswords_Report_Found.txt


#making sure ware running DSinternals
Import-Module DSInternals

#Run As Admin Account to get hashes
$cred = Get-Credential

# Getting Hashes from AD
write -----------------------------------------------------------------------------------------------
write --------------------------- WE ARE GETING PASSWORD HASHES -------------------------------------
write -----------------------------------------------------------------------------------------------
$server=Read-Host " What AD server to want to use?"
$OU=Read-Host "What OU do you want to get Hashes from? example: DC=ROOT,DC=DOMAIN,DC=ORG" 
$file = "C:\DAS_Tools\SecurityRisks\HASHoutfile.csv"

Function GetLine ($sam){
 $s = $sam
 $account=Get-ADReplAccount -SamAccountName $sam -Server $server -Credential $cred
 for ($i=1;$i -le $account.nthashhistory.count;$i++){
  $h = ConvertTo-Hex -input $account.nthashhistory[$i-1]
  $s += ","+$h
  }
 return $s
}

#### MAIN SCRIPT FOR HASH

# Set filter to desired population (1 or more accounts are acceptable)
$accounts = Get-ADUser -Filter "Enabled -eq 'true' " -SearchBase $OU



# Loop and write to a file
foreach ($a in $accounts){
 GetLine ($a.SamAccountname) >> $file
}


write -----------------------------------------------------------------------------------------------
wrire ---------------------Opening security results folder-----------------------------------------
write -----------------------------------------------------------------------------------------------


#Opening security results folder
explorer.exe C:\DAS_Tools\SecurityRisks