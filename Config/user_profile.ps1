#Prompt
Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt Paradox

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

#OMP
Set-PoshPrompt velvet

#Utilities
function which ($command) {
    Get-Command -Name $commandd -ErrorAction -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

#Alias
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'