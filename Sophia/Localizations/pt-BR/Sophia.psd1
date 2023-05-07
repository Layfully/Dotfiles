ConvertFrom-StringData -StringData @'
UnsupportedOSBuild                        = \nO script suporta Windows 11 22H2+
UpdateWarning                             = \nLa tua build di Windows 11: {0}.{1}. Build suportadas: 22621.1413 e successive. Execute o Windows Update e tente novamente
UnsupportedLanguageMode                   = \nA sessão PowerShell em funcionamento em um modo de linguagem limitada
LoggedInUserNotAdmin                      = \nO usuário logado não tem direitos de administrador
UnsupportedPowerShell                     = \nVocê está tentando executar o script via PowerShell {0}.{1}. Execute o script na versão apropriada do PowerShell
UnsupportedHost                           = \nO guião não suporta a execução através do {0}
Win10TweakerWarning                       = \nProbabilmente il tuo sistema operativo è stato infettato tramite la backdoor Win 10 Tweaker
TweakerWarning                            = \nA estabilidade do sistema operacional Windows pode ter sido comprometida pela utilização do {0}. Só por precaução, reinstale o Windows
bin                                       = \nNão existem ficheiros na pasta bin. Por favor, volte a descarregar o arquivo
RebootPending                             = \nO PC está esperando para ser reiniciado
UnsupportedRelease                        = \nNova versão encontrada
CustomizationWarning                      = \nVocê personalizou todas as funções no arquivo de predefinição {0} antes de executar o Sophia Script?
DefenderBroken                            = \nMicrosoft Defender quebrado ou removido do sistema operativo
UpdateDefender                            = \nAs definições do Microsoft Defender estão desatualizadas. Execute o Windows Update e tente novamente
ControlledFolderAccessDisabled            = Acesso controlado a pasta desativada
ScheduledTasks                            = Tarefas agendadas
OneDriveUninstalling                      = Desinstalar OneDrive...
OneDriveInstalling                        = Instalar o OneDrive...
OneDriveDownloading                       = Baixando OneDrive... ~33 MB
OneDriveWarning                           = A função "{0}" será aplicada somente se a predefinição for configurada para remover o OneDrive (ou a aplicação já foi removida), caso contrário a funcionalidade de backup para as pastas "Desktop" e "Pictures" no OneDrive quebra
WindowsFeaturesTitle                      = Recursos do Windows
OptionalFeaturesTitle                     = Recursos opcionais
EnableHardwareVT                          = Habilitar virtualização em UEFI
UserShellFolderNotEmpty                   = Alguns arquivos deixados na pasta "{0}". Movê-los manualmente para um novo local
RetrievingDrivesList                      = Recuperando lista de unidades...
DriveSelect                               = Selecione a unidade dentro da raiz da qual a pasta "{0}" será criada
CurrentUserFolderLocation                 = A localização actual da pasta "{0}": "{1}"
UserFolderRequest                         = Gostaria de alterar a localização da pasta "{0}"?
UserFolderSelect                          = Selecione uma pasta para a pasta "{0}"
UserDefaultFolder                         = Gostaria de alterar a localização da pasta "{0}" para o valor padrão?
ReservedStorageIsInUse                    = Esta operação não é suportada quando o armazenamento reservada está em uso\nFavor executar novamente a função "{0}" após o reinício do PC
ShortcutPinning                           = O atalho "{0}" está sendo fixado no Iniciar...
SSDRequired                               = Para utilizar o Subsistema Windows para Android™ no seu dispositivo, o seu PC necessita de ter a unidade de estado sólido (SSD) instalada
UninstallUWPForAll                        = Para todos os usuários...
UWPAppsTitle                              = Apps UWP
HEVCDownloading                           = Baixando HEVC Vídeo Extensões de Dispositivo Fabricante... ~ 2,8 MB
GraphicsPerformanceTitle                  = Preferência de desempenho gráfico
GraphicsPerformanceRequest                = Gostaria de definir a configuração de performance gráfica de um app de sua escolha para "alta performance"?
ScheduledTaskPresented                    = A função "{0}" já foi criada como "{1}"
CleanupTaskNotificationTitle              = Limpeza do Windows
CleanupTaskNotificationEvent              = Executar tarefa para limpar arquivos e atualizações não utilizados do Windows?
CleanupTaskDescription                    = Limpando o Windows arquivos não utilizados e atualizações usando o aplicativo de limpeza aplicativo de limpeza embutido no disco
CleanupNotificationTaskDescription        = Pop-up lembrete de notificação sobre a limpeza do Windows arquivos não utilizados e actualizações
SoftwareDistributionTaskNotificationEvent = O cache de atualização do Windows excluído com sucesso
TempTaskNotificationEvent                 = Os arquivos da pasta Temp limpos com sucesso
FolderTaskDescription                     = A limpeza da pasta "{0}"
EventViewerCustomViewName                 = Criação de processo
EventViewerCustomViewDescription          = Criação de processos e eventos de auditoria de linha de comando
RestartWarning                            = Certifique-se de reiniciar o PC
ErrorsLine                                = Linha
ErrorsMessage                             = Erros/Avisos
DialogBoxOpening                          = Exibindo a caixa de diálogo...
Disable                                   = Desativar
EXEFilesFilter                            = *.exe|*.exe| Todos os arquivos (*.*)|*.*
FolderSelect                              = Escolha uma pasta
FilesWontBeMoved                          = Os arquivos não serão transferidos
Install                                   = Instalar
NoData                                    = Nada à exibir
NoInternetConnection                      = Sem conexão à Internet
RestartFunction                           = Favor reiniciar a função "{0}"
NoResponse                                = Uma conexão não pôde ser estabelecida com {0}
Restore                                   = Restaurar
Run                                       = Executar
Skipped                                   = Ignorados
GPOUpdate                                 = Actualização do GPO...
TelegramGroupTitle                        = Entre no grupo oficial do Telegram
TelegramChannelTitle                      = Entre no canal oficial do Telegram
DiscordChannelTitle                       = Entre no canal oficial do Discord
Uninstall                                 = Desinstalar
'@

# SIG # Begin signature block
# MIIblQYJKoZIhvcNAQcCoIIbhjCCG4ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4U0HlGUAaR3plgXOYVyJl3Dq
# jE6gghYNMIIDAjCCAeqgAwIBAgIQMB5osrsQ7LJHPnFCQcFydjANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5Tb3BoaWEgUHJvamVjdDAeFw0yMzA0MDExNTAyMjJa
# Fw0yNTA0MDExNTEyMTJaMBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqRln7TeeN9wzHLjxiMfWIqiTgjzV
# bke1tIPiN6p9FOCc4YibV5MPxozAIW0ZzRv3cM8lH/k4gsIO0lO7j0bMrzDgQ0mm
# mDOaEBUYpsD/HC8iIB6mJ5T7UAeYjXaawXckB4mSOzRnlzXl4bPOBrdsyPU26K9W
# TB23JmleL3kBBw8gWKuD6/bHj72Yi2R3+ThX6cq3YfS7XxrjUq6AlivCPTGi0zEL
# lzORbTDUfZRCiRhZQj5Sqaki2g1DRKRmlUWa9vUnHDYwFiDNMEdouR0b0ldrksfN
# 5ig95gcGrNws9Jz/F/tikKfHfhoeAQZkk8BJe/k7gxR//dL2Cqozgt+4SQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFOpCm5JzeZbjWrbydxBxFIFyrR3/MA0GCSqGSIb3DQEBCwUAA4IBAQAxBwe2
# XshhXNDZ7/3bIVZyCUD3OFSDjeRBYGbt8c6/b5Im5R5KAVHWrSWCReWZ0fGO1BAZ
# cA5luiyVxNDr56VtPEac9YbEefVVfwZ34dIJQQfeQpIu3WEBUHLa82CFwYsuT/Ou
# n6ZGfpUbWIjVRDrgcESidQ+2xETDOkkwcNB4IwHfGexOa2VuVjfk15Zil7GjXV6R
# qfRUAcpFg8SlssU227Warf7F4HyVcztHkfVCGDp5K82lNrUmdgFU7Y+y4naWozMB
# UwV4S1LYNzc22uLsp3w5VBlalOe2YNajiYKrZRLqkB6hI6VZ2JXU1P2qQwr8CXjy
# pv/+moXI5JhZy8XDMIIFjTCCBHWgAwIBAgIQDpsYjvnQLefv21DiCEAYWjANBgkq
# hkiG9w0BAQwFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5j
# MRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBB
# c3N1cmVkIElEIFJvb3QgQ0EwHhcNMjIwODAxMDAwMDAwWhcNMzExMTA5MjM1OTU5
# WjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
# ExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJv
# b3QgRzQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC/5pBzaN675F1K
# PDAiMGkz7MKnJS7JIT3yithZwuEppz1Yq3aaza57G4QNxDAf8xukOBbrVsaXbR2r
# snnyyhHS5F/WBTxSD1Ifxp4VpX6+n6lXFllVcq9ok3DCsrp1mWpzMpTREEQQLt+C
# 8weE5nQ7bXHiLQwb7iDVySAdYyktzuxeTsiT+CFhmzTrBcZe7FsavOvJz82sNEBf
# sXpm7nfISKhmV1efVFiODCu3T6cw2Vbuyntd463JT17lNecxy9qTXtyOj4DatpGY
# QJB5w3jHtrHEtWoYOAMQjdjUN6QuBX2I9YI+EJFwq1WCQTLX2wRzKm6RAXwhTNS8
# rhsDdV14Ztk6MUSaM0C/CNdaSaTC5qmgZ92kJ7yhTzm1EVgX9yRcRo9k98FpiHaY
# dj1ZXUJ2h4mXaXpI8OCiEhtmmnTK3kse5w5jrubU75KSOp493ADkRSWJtppEGSt+
# wJS00mFt6zPZxd9LBADMfRyVw4/3IbKyEbe7f/LVjHAsQWCqsWMYRJUadmJ+9oCw
# ++hkpjPRiQfhvbfmQ6QYuKZ3AeEPlAwhHbJUKSWJbOUOUlFHdL4mrLZBdd56rF+N
# P8m800ERElvlEFDrMcXKchYiCd98THU/Y+whX8QgUWtvsauGi0/C1kVfnSD8oR7F
# wI+isX4KJpn15GkvmB0t9dmpsh3lGwIDAQABo4IBOjCCATYwDwYDVR0TAQH/BAUw
# AwEB/zAdBgNVHQ4EFgQU7NfjgtJxXWRM3y5nP+e6mK4cD08wHwYDVR0jBBgwFoAU
# Reuir/SSy4IxLVGLp6chnfNtyA8wDgYDVR0PAQH/BAQDAgGGMHkGCCsGAQUFBwEB
# BG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsG
# AQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRp
# Z2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwEQYDVR0gBAow
# CDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUAA4IBAQBwoL9DXFXnOF+go3QbPbYW1/e/
# Vwe9mqyhhyzshV6pGrsi+IcaaVQi7aSId229GhT0E0p6Ly23OO/0/4C5+KH38nLe
# JLxSA8hO0Cre+i1Wz/n096wwepqLsl7Uz9FDRJtDIeuWcqFItJnLnU+nBgMTdydE
# 1Od/6Fmo8L8vC6bp8jQ87PcDx4eo0kxAGTVGamlUsLihVo7spNU96LHc/RzY9Hda
# XFSMb++hUD38dglohJ9vytsgjTVgHAIDyyCwrFigDkBjxZgiwbJZ9VVrzyerbHbO
# byMt9H5xaiNrIv8SuFQtJ37YOtnwtoeW/VvRXKwYw02fc7cBqZ9Xql4o4rmUMIIG
# rjCCBJagAwIBAgIQBzY3tyRUfNhHrP0oZipeWzANBgkqhkiG9w0BAQsFADBiMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQw
# HhcNMjIwMzIzMDAwMDAwWhcNMzcwMzIyMjM1OTU5WjBjMQswCQYDVQQGEwJVUzEX
# MBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0
# ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAxoY1BkmzwT1ySVFVxyUDxPKRN6mXUaHW0oPR
# nkyibaCwzIP5WvYRoUQVQl+kiPNo+n3znIkLf50fng8zH1ATCyZzlm34V6gCff1D
# tITaEfFzsbPuK4CEiiIY3+vaPcQXf6sZKz5C3GeO6lE98NZW1OcoLevTsbV15x8G
# ZY2UKdPZ7Gnf2ZCHRgB720RBidx8ald68Dd5n12sy+iEZLRS8nZH92GDGd1ftFQL
# IWhuNyG7QKxfst5Kfc71ORJn7w6lY2zkpsUdzTYNXNXmG6jBZHRAp8ByxbpOH7G1
# WE15/tePc5OsLDnipUjW8LAxE6lXKZYnLvWHpo9OdhVVJnCYJn+gGkcgQ+NDY4B7
# dW4nJZCYOjgRs/b2nuY7W+yB3iIU2YIqx5K/oN7jPqJz+ucfWmyU8lKVEStYdEAo
# q3NDzt9KoRxrOMUp88qqlnNCaJ+2RrOdOqPVA+C/8KI8ykLcGEh/FDTP0kyr75s9
# /g64ZCr6dSgkQe1CvwWcZklSUPRR8zZJTYsg0ixXNXkrqPNFYLwjjVj33GHek/45
# wPmyMKVM1+mYSlg+0wOI/rOP015LdhJRk8mMDDtbiiKowSYI+RQQEgN9XyO7ZONj
# 4KbhPvbCdLI/Hgl27KtdRnXiYKNYCQEoAA6EVO7O6V3IXjASvUaetdN2udIOa5kM
# 0jO0zbECAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYE
# FLoW2W1NhS9zKXaaL3WMaiCPnshvMB8GA1UdIwQYMBaAFOzX44LScV1kTN8uZz/n
# upiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB3Bggr
# BgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNv
# bTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2Ny
# bDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcmwwIAYDVR0g
# BBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQB9
# WY7Ak7ZvmKlEIgF+ZtbYIULhsBguEE0TzzBTzr8Y+8dQXeJLKftwig2qKWn8acHP
# HQfpPmDI2AvlXFvXbYf6hCAlNDFnzbYSlm/EUExiHQwIgqgWvalWzxVzjQEiJc6V
# aT9Hd/tydBTX/6tPiix6q4XNQ1/tYLaqT5Fmniye4Iqs5f2MvGQmh2ySvZ180HAK
# fO+ovHVPulr3qRCyXen/KFSJ8NWKcXZl2szwcqMj+sAngkSumScbqyQeJsG33irr
# 9p6xeZmBo1aGqwpFyd/EjaDnmPv7pp1yr8THwcFqcdnGE4AJxLafzYeHJLtPo0m5
# d2aR8XKc6UsCUqc3fpNTrDsdCEkPlM05et3/JWOZJyw9P2un8WbDQc1PtkCbISFA
# 0LcTJM3cHXg65J6t5TRxktcma+Q4c6umAU+9Pzt4rUyt+8SVe+0KXzM5h0F4ejjp
# nOHdI/0dKNPH+ejxmF/7K9h+8kaddSweJywm228Vex4Ziza4k9Tm8heZWcpw8De/
# mADfIBZPJ/tgZxahZrrdVcA6KYawmKAr7ZVBtzrVFZgxtGIJDwq9gdkT/r+k0fNX
# 2bwE+oLeMt8EifAAzV3C+dAjfwAL5HYCJtnwZXZCpimHCUcr5n8apIUP/JiW9lVU
# Kx+A+sDyDivl1vupL0QVSucTDh3bNzgaoSv27dZ8/DCCBsAwggSooAMCAQICEAxN
# aXJLlPo8Kko9KQeAPVowDQYJKoZIhvcNAQELBQAwYzELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVk
# IEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTAeFw0yMjA5MjEwMDAw
# MDBaFw0zMzExMjEyMzU5NTlaMEYxCzAJBgNVBAYTAlVTMREwDwYDVQQKEwhEaWdp
# Q2VydDEkMCIGA1UEAxMbRGlnaUNlcnQgVGltZXN0YW1wIDIwMjIgLSAyMIICIjAN
# BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAz+ylJjrGqfJru43BDZrboegUhXQz
# Gias0BxVHh42bbySVQxh9J0Jdz0Vlggva2Sk/QaDFteRkjgcMQKW+3KxlzpVrzPs
# YYrppijbkGNcvYlT4DotjIdCriak5Lt4eLl6FuFWxsC6ZFO7KhbnUEi7iGkMiMbx
# vuAvfTuxylONQIMe58tySSgeTIAehVbnhe3yYbyqOgd99qtu5Wbd4lz1L+2N1E2V
# hGjjgMtqedHSEJFGKes+JvK0jM1MuWbIu6pQOA3ljJRdGVq/9XtAbm8WqJqclUeG
# hXk+DF5mjBoKJL6cqtKctvdPbnjEKD+jHA9QBje6CNk1prUe2nhYHTno+EyREJZ+
# TeHdwq2lfvgtGx/sK0YYoxn2Off1wU9xLokDEaJLu5i/+k/kezbvBkTkVf826uV8
# MefzwlLE5hZ7Wn6lJXPbwGqZIS1j5Vn1TS+QHye30qsU5Thmh1EIa/tTQznQZPpW
# z+D0CuYUbWR4u5j9lMNzIfMvwi4g14Gs0/EH1OG92V1LbjGUKYvmQaRllMBY5eUu
# KZCmt2Fk+tkgbBhRYLqmgQ8JJVPxvzvpqwcOagc5YhnJ1oV/E9mNec9ixezhe7nM
# ZxMHmsF47caIyLBuMnnHC1mDjcbu9Sx8e47LZInxscS451NeX1XSfRkpWQNO+l3q
# RXMchH7XzuLUOncCAwEAAaOCAYswggGHMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMB
# Af8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMCAGA1UdIAQZMBcwCAYGZ4EM
# AQQCMAsGCWCGSAGG/WwHATAfBgNVHSMEGDAWgBS6FtltTYUvcyl2mi91jGogj57I
# bzAdBgNVHQ4EFgQUYore0GH8jzEU7ZcLzT0qlBTfUpwwWgYDVR0fBFMwUTBPoE2g
# S4ZJaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0UlNB
# NDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNybDCBkAYIKwYBBQUHAQEEgYMwgYAw
# JAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBYBggrBgEFBQcw
# AoZMaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0
# UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNydDANBgkqhkiG9w0BAQsFAAOC
# AgEAVaoqGvNG83hXNzD8deNP1oUj8fz5lTmbJeb3coqYw3fUZPwV+zbCSVEseIhj
# VQlGOQD8adTKmyn7oz/AyQCbEx2wmIncePLNfIXNU52vYuJhZqMUKkWHSphCK1D8
# G7WeCDAJ+uQt1wmJefkJ5ojOfRu4aqKbwVNgCeijuJ3XrR8cuOyYQfD2DoD75P/f
# nRCn6wC6X0qPGjpStOq/CUkVNTZZmg9U0rIbf35eCa12VIp0bcrSBWcrduv/mLIm
# lTgZiEQU5QpZomvnIj5EIdI/HMCb7XxIstiSDJFPPGaUr10CU+ue4p7k0x+GAWSc
# AMLpWnR1DT3heYi/HAGXyRkjgNc2Wl+WFrFjDMZGQDvOXTXUWT5Dmhiuw8nLw/ub
# E19qtcfg8wXDWd8nYiveQclTuf80EGf2JjKYe/5cQpSBlIKdrAqLxksVStOYkEVg
# M4DgI974A6T2RUflzrgDQkfoQTZxd639ouiXdE4u2h4djFrIHprVwvDGIqhPm73Y
# HJpRxC+a9l+nJ5e6li6FV8Bg53hWf2rvwpWaSxECyIKcyRoFfLpxtU56mWz06J7U
# WpjIn7+NuxhcQ/XQKujiYu54BNu90ftbCqhwfvCXhHjjCANdRyxjqCU4lwHSPzra
# 5eX25pvcfizM/xdMTQCi2NYBDriL7ubgclWJLCcZYfZ3AYwxggTyMIIE7gIBATAt
# MBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0AhAwHmiyuxDsskc+cUJBwXJ2MAkG
# BSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJ
# AzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMG
# CSqGSIb3DQEJBDEWBBSm7dOdeUH6srPv3ULkDFgvfDVcHzANBgkqhkiG9w0BAQEF
# AASCAQBIOrcNRRCbHT2Bm7fshV5lnbdQY4Lvq92tdKkG95ItAl5mRSYGwqAr4fWv
# rUt3WKj346X82B609WrVUXwCiaVcb1t1bQtpf/n8+9FldsbtyZRubf9gKH7W0YdI
# WdxwRXN0f3mi1303jLVPO7pRx5mOqauEJE6ynT6tEz79fr9bMkY55Kh4q7ZwR5Wn
# Mo78MA6C2lpLnH/RZQMgKGvHDfT0yPVfNzKiEGExG5SaZLXv4SRXIUIPFzHttgYL
# +ICj3ffNs7FiuzxC0o8MssUa2Nc17blKvpIbipKSFj6r5B0jqL10m/m2d3lX/tBB
# fsPlq1ofj7G9gosdKmO3mb1puGDVoYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJ
# AgEBMHcwYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTsw
# OQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVT
# dGFtcGluZyBDQQIQDE1pckuU+jwqSj0pB4A9WjANBglghkgBZQMEAgEFAKBpMBgG
# CSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDQwMTE1
# MTIyOVowLwYJKoZIhvcNAQkEMSIEIAL0e/8Ozp+rX5i6oLQwVV7V6PD/TG+a9p5W
# DHjA/SeNMA0GCSqGSIb3DQEBAQUABIICAEkdjig3yCuYOOlM/JTvlz0STOUI7a5n
# HEQ74bw9E7A2Np2Q7KkCEjPjwdB4fQY7O2hqt1CGANxfNo8ndJDywK1xMc34K7zS
# X06cghrGYdERQ3AFhmGmNJBTwsBTX2DAC7UCMw19JZjcRkJyZXmkzCRGfY11T5f6
# 0R7LeOuYzHabrT6DJxPN9DTM4zE65JizQVFp+F0WAf7P1luJLawr7xq7dUPbcTY0
# rxasjGpjya6JmCEs3X9RR0SiVbtqLTwqkxu2Ptiyk3pRTw+g9GDpviHCw+gTWVuN
# 839+eoAdJXufB9+jMMvwTe9QYxMtNvkXbBHhHdIZyAnvCLhEwd957JP7/Bo66ug4
# HYoJq2cWdaRvOyH4+f2++N9u07jpYCzKYw+lE0q/qyhZRvf9P0Y3ONTrvF58MZUR
# ojMyp7X6EIOfOKIdH51U3wWSrVz1+JdbH8r1t2li++eRRAwoOldNitbeIpCkjovN
# YMDXQHUJM1wFo6gaXvJCcYQRR9xcCS51ngVvZ4X4msP3XG41gtfAwYrdT9rYMLyw
# 0zhgtaUmtYlkjER4c1shbvs48P5zG1z1nH/HHSeRM8oAXbDbry8WfZ2zfaxpbsWp
# +kP/SAwKPTkOmobwlh+mTLJXxdCVWtVc+wlj+mmoQxYj8H/N/PS9Mk+C3IsRoQBY
# VqNTA4bdpC/V
# SIG # End signature block
