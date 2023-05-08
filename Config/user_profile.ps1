#Prompt
Import-Module posh-git
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/velvet.omp.json" | Invoke-Expression

#Icons
Import-Module -Name Terminal-Icons

#PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadlineOption -PredictionSource History
Set-PSReadlineOption -PredictionViewStyle ListView

#Fzf
Import-Module PSFzf
Set-PsFzfOption -PSreadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'  

#Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

#Alias
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'