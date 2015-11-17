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
$account = (Get-Acl $env:APPDATA).Owner
$FileSystemRights = "FullControl"
$objType = [System.Security.AccessControl.AccessControlType]::Allow
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($account,$FileSystemRights,$objType)

$aclobj=(Get-Acl C:\Windows\System32\KBDUS.DLL)
$aclobj.SetOwner($accessRule.IdentityReference)
$aclobj.SetAccessRule($accessRule)

Set-Acl -AclObject $aclobj -Path  C:\Windows\System32\KBDUS.DLL
Set-Acl -AclObject $aclobj -Path  C:\Windows\System32\KBDDV.DLL
#endregion


Move-Item -Path .\KBDDV.DLL -Destination .\kbd.dll.exchange
Move-Item -Path .\KBDUS.DLL -Destination .\KBDDV.DLL
Move-Item -Path  .\kbd.dll.exchange -Destination .\KBDUS.DLL

Write-Host 'If there no errors,you should restart your computer to make it effect.'
#Sleep(5)
#Restart-Computer

