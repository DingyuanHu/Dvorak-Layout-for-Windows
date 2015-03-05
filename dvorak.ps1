#region Run As Administrator
$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent() 
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi
 
if( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 
{ 
  $boundPara = ($MyInvocation.BoundParameters.Keys | foreach{
     '-{0} {1}' -f  $_ ,$MyInvocation.BoundParameters[$_]} ) -join ' '
  $currentFile =$MyInvocation.MyCommand.Path
 
 $fullPara = $boundPara + ' ' + $args -join ' '
 Start-Process "$psHome\powershell.exe"   -ArgumentList "$currentFile $fullPara"   -verb runas 
 return
} 
#endregion

Set-Location C:\Windows\System32

#region Set ACL of file
$dvacl=Get-Acl .\KBDDV.DLL
$usacl=Get-Acl .\KBDUS.DLL

$account = "BUILTIN\Administrators"
$FileSystemRights = "FullControl"
$objType = [System.Security.AccessControl.AccessControlType]::Allow
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($account,$FileSystemRights,$objType)
$owner = New-Object System.Security.Principal.NTAccount("BUILTIN","Administrators")

$dvacl.SetOwner($owner)
$usacl.SetOwner($owner)
Set-Acl -Path .\KBDDV.DLL -AclObject $dvacl
Set-Acl -Path .\KBDUS.DLL -AclObject $usacl

$dvacl.SetAccessRule($accessRule)
$usacl.SetAccessRule($accessRule)
Set-Acl -Path .\KBDDV.DLL -AclObject $dvacl
Set-Acl -Path .\KBDUS.DLL -AclObject $usacl
#endregion


Move-Item -Path .\KBDDV.DLL -Destination .\kbd.dll.exchange
Move-Item -Path .\KBDUS.DLL -Destination .\KBDDV.DLL
Move-Item -Path  .\kbd.dll.exchange -Destination .\KBDUS.DLL

Write-Host 'If there no errors,you should restart your computer to make it effect.'
#Sleep(5)
#Restart-Computer

