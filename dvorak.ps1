#region Run As Administrator
$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent() 
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi
 
if( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 
{ 
  Write-Error "Please Run As Administrator."
  return
} 
#endregion

if(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\00000804")
{
  Push-Location "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts"
  $currentLayout= Get-ItemProperty -Path 00000804 -Name 'Layout Text'
  Write-Host "Setting "+ $currentLayout.'Layout Text' + " -> Dvorak"
  Set-ItemProperty -Path 00000804 -Name 'Layout File' -Value "KBDDV.dll"
  Set-ItemProperty -Path 00000804 -Name 'Layout Text' -Value "Chinese (Simplified) - Dvorak Keyboard"
  Pop-Location
  Write-Host "please restart computer."
  #Sleep(5)
  #Restart-Computer
}
else
{
  Write-Error  "can't find keyboard layout"
}

