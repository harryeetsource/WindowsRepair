
$url1 = "https://go.microsoft.com/fwlink/?LinkId=212732"
$folder1 = "$env:appdata\msert"
$url2 = "https://go.microsoft.com/fwlink/?LinkID=799445"
$folder2 = "$env:appdata\WUA"
$url3 = "https://download.sysinternals.com/files/Autoruns.zip"
$folder3 = "$env:appdata\autoruns"
$url4 = "https://download.sysinternals.com/files/ProcessExplorer.zip"
$folder4 = "$env:appdata\procexp"
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -executionpolicy bypass -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}
if (Test-Path -Path $folder1) {Write-Host "msert directory already exists, removing old version."
    Remove-Item -Path $folder1 -Recurse
    New-Item -Path "$env:appdata\" -Name "msert" -ItemType "directory"
    Invoke-WebRequest $url1 -OutFile "$folder1\msert.exe"
    Start-Process "$folder1\msert.exe"
}
else {
    New-Item -Path "$env:appdata\" -Name "msert" -ItemType "directory"
    Invoke-WebRequest $url1 -OutFile "$folder1\msert.exe"
    Start-Process "$folder1\msert.exe"
}
if (Test-Path -Path $folder2) {Write-Host "WUA directory already exists, removing old version"
    Remove-Item -Path $folder2 -Recurse
    New-Item -Path "$env:appdata\" -Name "WUA" -ItemType "directory"
    Invoke-WebRequest $url2 -OutFile "$folder2\WUA.exe"
    Start-Process "$folder2\WUA.exe"
}
else {
    New-Item -Path "$env:appdata\" -Name "WUA" -ItemType "directory"
    Invoke-WebRequest $url2 -OutFile "$folder2\WUA.exe"
    Start-Process "$folder2\WUA.exe"
}
if (Test-Path -Path $folder3) {Write-Host "Sysinternals directory already exists, removing old version"
    Remove-Item -Path $folder3 -Recurse
    New-Item -Path "$env:appdata\" -Name "autoruns" -ItemType "directory"
    Invoke-WebRequest $url3 -Outfile "$folder3\autoruns.zip"
    Expand-Archive -LiteralPath "$folder3\autoruns.zip" -DestinationPath "$folder3\autoruns\"
    Start-Process "$folder3\autoruns\autoruns64.exe"
}

else {
    New-Item -Path "$env:appdata\" -Name "autoruns" -ItemType "directory"
    Invoke-WebRequest $url3 -Outfile "$env:appdata\autoruns\autoruns.zip"
    Expand-Archive -LiteralPath "$env:appdata\autoruns\autoruns.zip" -DestinationPath "$env:appdata\autoruns\autoruns\"
    Start-Process "$env:appdata\autoruns\autoruns\autoruns64.exe"
}
if (Test-Path -Path $folder4) {Write-Host "procexp directory already exists, removing old version"
    Remove-Item -Path $folder3 -Recurse
    New-Item -Path "$env:appdata\" -Name "procexp" -ItemType "directory"
    Invoke-WebRequest $url4 -Outfile "$folder4\procexp.zip"
    Expand-Archive -LiteralPath "$folder4\procexp.zip" -DestinationPath "$folder4\procexp\"
    Start-Process "$folder4\procexp\procexp64.exe"
}

else {
     New-Item -Path "$env:appdata\" -Name "procexp" -ItemType "directory"
    Invoke-WebRequest $url4 -Outfile "$folder4\procexp.zip"
    Expand-Archive -LiteralPath "$folder4\procexp.zip" -DestinationPath "$folder4\procexp\"
    Start-Process "$folder4\procexp\procexp64.exe"
}
#Get-AppxPackage *Microsoft.Windows.SecHealthUI* | Reset-AppxPackage
#Get-AppxPackage Microsoft.SecHealthUI -AllUsers | Reset-AppxPackage
Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register -ErrorAction SilentlyContinue "$($_.InstallLocation)\AppXManifest.xml"} 
Repair-WindowsImage -Online -Scanhealth -StartComponentCleanup -ResetBase
