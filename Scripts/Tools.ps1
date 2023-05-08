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

winget install -e --id Microsoft.PowerToys
winget install fzf

# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install font used by terminal
choco install jetbrainsmononf -y

# Install z for faster folder navigation
Install-Module -Name z 

# Install PSFzf to use fzf in PowerShell
Install-Module -Name PSFzf 

# ---------------------------------------------- #
# Prompt  -------------------------------------- #
# ---------------------------------------------- #
pwsh -Command { Install-Module posh-git -Scope CurrentUser -Force}
winget install JanDeDobbeleer.OhMyPosh -s winget

# Install powershell and use symlink to corresponding dotfile
winget install -h PowerShell -s msstore --accept-package-agreements

$PowerShellProfilePath = "$env:USERPROFILE\Documents\PowerShell\" 
$PowerShellProfileFullPath = ($PowerShellProfilePath + "Microsoft.PowerShell_profile.ps1")

if (Test-Path $PowerShellProfilePath) {
    if (Test-Path $PowerShellProfileFullPath) {
        Remove-Item -Path $PowerShellProfileFullPath -Force
    }
}
else {
    New-Item -Path "$env:USERPROFILE\Documents" -Name "PowerShell" -ItemType "directory"   
}

New-Item -ItemType SymbolicLink -Path $PowerShellProfileFullPath -Target "$env:USERPROFILE\Dotfiles\Config\user_profile.ps1"