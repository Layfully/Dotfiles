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

    # Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = $MyInvocation.MyCommand.Path + $MyInvocation.UnboundArguments
        Write-Output $CommandLine
        Start-Process -Verb RunAs wt -ArgumentList "C:\Users\admin\Dotfiles\Scripts\Tools.ps1"
        Exit
    }
}

#Install powertoys fzf and windows terminal
winget upgrade --id Microsoft.PowerToys
winget upgrade fzf -h
winget upgrade --id Microsoft.WindowsTerminal

# Trust PSGallery
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Install chocolatey
if(-not(test-path "C:\ProgramData\chocolatey\bin\choco.exe")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
else {
    choco upgrade chocolatey
}

# Install font used by terminal
choco upgrade jetbrainsmononf -y

# Install z for faster folder navigation
Install-Module -Name z -Repository PSGallery

# Install PSFzf to use fzf in PowerShell
Install-Module -Name PSFzf

# Install PSReadLine predictions
Install-Module -Name CompletionPredictor -Repository PSGallery

# Install prompt posh-git
Install-Module -Name posh-git

# Install terminal icons
Install-Module -Name Terminal-Icons

# Install oh my posh
winget upgrade JanDeDobbeleer.OhMyPosh -s winget

# Install powershell and use symlink to corresponding dotfile
winget upgrade -h PowerShell -s msstore --accept-package-agreements

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

# Install windows terminal and use symlink to corresponding dotfile
$WindowsTerminalProfilePath = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"
$WindowsTerminalProfileFullPath = ($WindowsTerminalProfilePath + "settings.json")

if (Test-Path $WindowsTerminalProfilePath) {
    if (Test-Path $WindowsTerminalProfileFullPath) {
        Remove-Item -Path $WindowsTerminalProfileFullPath -Force
    }
}
else {
    New-Item -Path "$env:USERPROFILE\Documents" -Name "PowerShell" -ItemType "directory"   
}

New-Item -ItemType SymbolicLink -Path $WindowsTerminalProfileFullPath -Target "$env:USERPROFILE\Dotfiles\Config\WindowsTerminal\settings.json"

