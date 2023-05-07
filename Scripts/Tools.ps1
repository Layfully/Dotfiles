#--- Visual Studio ---
#choco install visualstudio2019professional -y --package-parameters "--add Microsoft.VisualStudio.Component.Git" 
#Update-SessionEnvironment #refreshing env due to Git install

#choco install -y visualstudio2019-workload-manageddesktop
#choco install -y visualstudio2019-workload-netcoretools
#choco install -y visualstudio2019-workload-azure 
#choco install -y visualstudio2019-workload-visualstudioextension 

#--- Visual Studio extensions ---
#choco install -y gitdiffmargin
#choco install -y resharper-ultimate-all --package-parameters="'/NoCpp'"

# Install powertoys
winget install -e --id Microsoft.PowerToys

# Install powershell and use symlink to corresponding dotfile
winget install -h PowerShell -s msstore --accept-package-agreements

$PowerShellProfilePath = "$env:USERPROFILE\Documents\PowerShell\" 
$PowerShellProfileFullPath = ($PowerShellProfilePath + $PowerShellProfileFileName)

if (Test-Path $PowerShellProfilePath) {
    if (Test-Path $PowerShellProfileFullPath) {
        Remove-Item -Path $PowerShellProfileFullPath -Force
    }
}
else {
    New-Item -Path "$env:USERPROFILE\Documents" -Name "PowerShell" -ItemType "directory"   
}

New-Item -ItemType SymbolicLink -Path $PowerShellProfileFullPath -Target "$env:USERPROFILE\Dotfiles\Config\user_profile.ps1"