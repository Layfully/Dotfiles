ConvertFrom-StringData -StringData @'
UnsupportedOSBuild                        = \nEl script es compatible con Windows 11 22H2+
UpdateWarning                             = \nSu build de Windows 11: {0}.{1}. Compilaciones compatibles: 22621.1413 y superiores. Ejecute Windows Update y vuelva a intentarlo
UnsupportedLanguageMode                   = \nSesión de PowerShell ejecutada en modo de lenguaje limitado
LoggedInUserNotAdmin                      = \nEl usuario que inició sesión no tiene derechos de administrador
UnsupportedPowerShell                     = \nEstás intentando ejecutar el script a través de PowerShell {0}.{1}. Ejecute el script en la versión apropiada de PowerShell
UnsupportedHost                           = \nEl script no es compatible con la ejecución a través de {0}
Win10TweakerWarning                       = \nProbablemente su sistema operativo fue infectado a través del backdoor Win 10 Tweaker
TweakerWarning                            = \nLa estabilidad del sistema operativo Windows puede haberse visto comprometida al utilizar el {0}. Por si acaso, reinstala Windows
bin                                       = \nNo hay archivos en la carpeta bin. Por favor, vuelva a descargar el archivo
RebootPending                             = \nEl PC está esperando a ser reiniciado
UnsupportedRelease                        = \nUna nueva versión encontrada
CustomizationWarning                      = \n¿Ha personalizado todas las funciones del archivo predeterminado {0} antes de ejecutar Sophia Script?
DefenderBroken                            = \nMicrosoft Defender dañado o eliminado del sistema operativo
UpdateDefender                            = \nLas definiciones de Microsoft Defender no están actualizadas. Ejecute Windows Update y vuelva a intentarlo
ControlledFolderAccessDisabled            = Acceso a la carpeta controlada deshabilitado
ScheduledTasks                            = Tareas programadas
OneDriveUninstalling                      = Desinstalar OneDrive...
OneDriveInstalling                        = Instalación de OneDrive...
OneDriveDownloading                       = Descargando OneDrive... ~33 MB
OneDriveWarning                           = La función "{0}" se aplicará sólo si el preajuste está configurado para eliminar OneDrive (o la aplicación ya fue eliminada), de lo contrario la funcionalidad de copia de seguridad para las carpetas "Escritorio" e "Imágenes" en OneDrive se rompe
WindowsFeaturesTitle                      = Características de Windows
OptionalFeaturesTitle                     = Características opcionales
EnableHardwareVT                          = Habilitar la virtualización en UEFI
UserShellFolderNotEmpty                   = Algunos archivos quedan en la carpeta "{0}". Moverlos manualmente a una nueva ubicación
RetrievingDrivesList                      = Recuperando lista de unidades...
DriveSelect                               = Seleccione la unidad dentro de la raíz de la cual se creó la carpeta "{0}"
CurrentUserFolderLocation                 = La ubicación actual de la carpeta "{0}": "{1}"
UserFolderRequest                         = ¿Le gustaría cambiar la ubicación de la "{0}" carpeta?
UserFolderSelect                          = Seleccione una carpeta para la carpeta "{0}"
UserDefaultFolder                         = ¿Le gustaría cambiar la ubicación de la carpeta "{0}" para el valor por defecto?
ReservedStorageIsInUse                    = Esta operación no es compatible cuando el almacenamiento reservada está en uso\nPor favor, vuelva a ejecutar la función "{0}" después de reiniciar el PC
ShortcutPinning                           = El acceso directo "{0}" está siendo clavado en Start...
SSDRequired                               = Para utilizar Windows Subsystem for Android™ en su dispositivo, su PC debe tener instalada una unidad de estado sólido (SSD)
UninstallUWPForAll                        = Para todos los usuarios
UWPAppsTitle                              = Aplicaciones UWP
HEVCDownloading                           = Descargando HEVC Vídeo Extensiones del Fabricante del dispositivo... ~2,8 MB
GraphicsPerformanceTitle                  = Preferencia de rendimiento gráfico
GraphicsPerformanceRequest                = ¿Le gustaría establecer la configuración de rendimiento gráfico de una aplicación de su elección a "alto rendimiento"?
ScheduledTaskPresented                    = La función "{0}" ya fue creada como "{1}"
CleanupTaskNotificationTitle              = Limpieza de Windows
CleanupTaskNotificationEvent              = ¿Ejecutar la tarea de limpiar los archivos no utilizados y actualizaciones de Windows?
CleanupTaskDescription                    = La limpieza de Windows los archivos no utilizados y actualizaciones utilizando una función de aplicación de limpieza de discos
CleanupNotificationTaskDescription        = Pop-up recordatorio de notificaciones sobre la limpieza de archivos no utilizados de Windows y actualizaciones
SoftwareDistributionTaskNotificationEvent = La caché de actualización de Windows eliminado correctamente
TempTaskNotificationEvent                 = Los archivos de la carpeta Temp limpiados con éxito
FolderTaskDescription                     = La limpieza de la carpeta "{0}"
EventViewerCustomViewName                 = Creación de proceso
EventViewerCustomViewDescription          = Eventos de auditoría de línea de comandos y creación de procesos
RestartWarning                            = Asegúrese de reiniciar su PC
ErrorsLine                                = Línea
ErrorsMessage                             = Errores/Advertencias
DialogBoxOpening                          = Viendo el cuadro de diálogo...
Disable                                   = Desactivar
EXEFilesFilter                            = *.exe|*.exe|Todos los Archivos (*.*)|*.*
FolderSelect                              = Seleccione una carpeta
FilesWontBeMoved                          = Los archivos no se transferirán
Install                                   = Instalar
NoData                                    = Nada que mostrar
NoInternetConnection                      = No hay conexión a Internet
RestartFunction                           = Por favor, reinicie la función "{0}"
NoResponse                                = No se pudo establecer una conexión con {0}
Restore                                   = Restaurar
Run                                       = Iniciar
Skipped                                   = Omitido
GPOUpdate                                 = Actualización de GPO...
TelegramGroupTitle                        = Únete a nuestro grupo oficial de Telegram
TelegramChannelTitle                      = Únete a nuestro canal oficial de Telegram
DiscordChannelTitle                       = Únete a nuestro canal oficial de Discord
Uninstall                                 = Desinstalar
'@

# SIG # Begin signature block
# MIIblQYJKoZIhvcNAQcCoIIbhjCCG4ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUF59XL2r6wL/F9OJS1oTnFS9v
# /dygghYNMIIDAjCCAeqgAwIBAgIQMB5osrsQ7LJHPnFCQcFydjANBgkqhkiG9w0B
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
# CSqGSIb3DQEJBDEWBBQInbdhkloQWuH+pzFFEQJM6ZCCQzANBgkqhkiG9w0BAQEF
# AASCAQBbjXhJa1nUsgV6Vtrbk+FN+eB86RHLZZyfzAzDsOt+jpQKTJ/ZYMmAEM2C
# 4mMduOBg1La6cxS0JLvLtxntWJ8ue3QAaMAHYi9qqHA37FX4ef8ksaDPU7f+M++A
# RWzCNUkVoS1cSVpo8tqZFwOT+GOLMkXWGD1mB3X+mPXjtkFUMCExcHeNirs9W5bM
# n6PDsU4RxAE9A87rGFPi/M8A7ha5UX1AOQYMBYnYBzhcm37c5u7XiHjzBxfox78D
# SeP0QCqAqnx/ODmli5jBb9+JF8nKYWsvKj0Gy9RkTIS7TtN9h7M1JxNKDUaEPCF8
# qtj3IBcT+G5YQVJfIQsc23jeiKv9oYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJ
# AgEBMHcwYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTsw
# OQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVT
# dGFtcGluZyBDQQIQDE1pckuU+jwqSj0pB4A9WjANBglghkgBZQMEAgEFAKBpMBgG
# CSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDQwMTE1
# MTIyOFowLwYJKoZIhvcNAQkEMSIEINuEUYXAH7rcqCjEmFIDB/3Ta5uYxGL3DbQA
# A3YsyMjtMA0GCSqGSIb3DQEBAQUABIICAGddD5z6r8ClNxZ2Ho+7ItvbrFwwq/BP
# ZeBicpBRs3Z3j0fMl4ebH7SgIDZaWE+QG6LAQ+IoI0srRlMKgKdgR5WZ6Oqm6cSV
# 0+h39cv3Mtf241I/4IS4KeSgWI9i+xDaE00cLw+jX59g1MI2LLpb8LtdOEPQJ50z
# Ps1JhskBEqbS76XHjpqxKYbu9fwQqmB4x84KD6qaHAQWya238YAUv6Ew0inUng/e
# 6yP3KCgWxyzhmm4VLhET5nfiwUiwLms5WKEFkTroktaQhkJANdKWMfCCf+grPwsw
# rLWQRN/9KZT17ECxo8Zs7oPg8LU/3uvuRDdGhakzsInEqdCyh4PzP925r9V8Cuom
# jC2OKzMsrDmdGrslCUqQjgr70bVTZUddXm4pbQZm3gZ+rkHS/JKR90tYdnhpnbyF
# Ewc6v1NBYGBpgf7z2omTjfxOaQnnShND8n4816nduJgcGsTzMaeIrW/uDZKC2Iqf
# LXvHlke2iKA0HQY9jobqTxkS6fKjE5Dkr7oxFzNoGNgeSfMCqSKc95LKcAD2v2+b
# 9Wb0+VHXdWgrPVPqlayurgi+A5lpkoUpnwq0XVSjRh0ZgZ38DWzk6cF0W/GiwYM4
# 1/UvpaekuiuWDKRzYD9K4tZqtLDAjgi6dkixj4rlwiB3Minx2I+/AX6dpaAkq1l0
# 4us2XLU9mJNK
# SIG # End signature block
