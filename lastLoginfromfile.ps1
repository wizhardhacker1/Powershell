 $file = Get-Content -Path "C:\BGinfo\users.txt"
 foreach ($user in $file)
     {
     Get-ADUser -Identity $user -Properties LastLogonDate | Select-Object SamAccountName, LastLogonDate
     }


