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
Remove-Item -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "$env:USERPROFILE\Dotfiles\Config\user_profile.ps1"