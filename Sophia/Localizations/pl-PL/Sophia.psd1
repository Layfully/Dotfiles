ConvertFrom-StringData -StringData @'
UnsupportedOSBuild                        = \nSkrypt obsługuje system Windows 11 22H2+
UpdateWarning                             = \nTwoja wersja systemu Windows 11: {0}.{1}. Obsługiwane kompilacje: 22621.1413 i nowsze. Uruchom aktualizację systemu Windows i spróbuj ponownie.
UnsupportedLanguageMode                   = \nSesja PowerShell działa w trybie ograniczonego języka
LoggedInUserNotAdmin                      = \nZalogowany użytkownik nie posiada uprawnień administratora
UnsupportedPowerShell                     = \nPróbujesz uruchomić skrypt przy użyciu PowerShell {0}.{1}. Uruchom skrypt używając odpowiedniej wersji PowerShell
UnsupportedHost                           = \nSkrypt nie może być uruchamiany w {0}
Win10TweakerWarning                       = \nPrawdopodobnie twój system operacyjny został zainfekowany przez backdoora pochodzącego z Win 10 Tweaker
TweakerWarning                            = \nStabilność systemu Windows mogła zostać naruszona przez użycie {0}. Na wszelki wypadek przeinstaluj system Windows
bin                                       = \nW folderze bin nie ma żadnych plików. Proszę pobrać archiwum ponownie
RebootPending                             = \nKomputer oczekuje na ponowne uruchomienie
UnsupportedRelease                        = \nZnaleziono nową wersję
CustomizationWarning                      = \nCzy dostosowałeś funkcje w predefiniowanym pliku {0} przed uruchomieniem Sophia Script?
DefenderBroken                            = \nMicrosoft Defender jest uszkodzony lub usunięty z systemu operacyjnego
UpdateDefender                            = \nDefinicje programu Microsoft Defender są nieaktualne. Uruchom aktualizację systemu Windows i spróbuj ponownie.
ControlledFolderAccessDisabled            = Kontrolowany dostęp do folderów został wyłączony
ScheduledTasks                            = Zaplanowane zadania
OneDriveUninstalling                      = Odinstalowywanie OneDrive...
OneDriveInstalling                        = Instalowanie OneDrive...
OneDriveDownloading                       = Pobieranie OneDrive... ~33 MB
OneDriveWarning                           = Funkcja "{0}" zostanie zastosowana tylko wtedy, gdy ustawienie wstępne są skonfigurowane do usunięcia OneDrive (lub aplikacja została już usunięta), w przeciwnym razie funkcja tworzenia kopii zapasowych folderów "Pulpit" i "Obrazy" w usłudze OneDrive ulegnie awarii
WindowsFeaturesTitle                      = Funkcje Windows
OptionalFeaturesTitle                     = Funkcje opcjonalne
EnableHardwareVT                          = Włącz wirtualizację w UEFI
UserShellFolderNotEmpty                   = Niektóre pliki pozostały w folderze "{0}". Przenieś je ręcznie w nowe miejsce
RetrievingDrivesList                      = Pobieranie listy dysków...
DriveSelect                               = Wybierz dysk w katalogu głównym, w którym zostanie utworzony folder "{0}".
CurrentUserFolderLocation                 = Lokalizacja folderu "{0}": "{1}"
UserFolderRequest                         = Czy chcesz zmienić lokalizację folderu "{0}"?
UserFolderSelect                          = Wybierz folder dla folderu "{0}".
UserDefaultFolder                         = Czy chcesz zmienić lokalizację folderu "{0}" na wartość domyślną?
ReservedStorageIsInUse                    = Ta operacja nie jest obsługiwana, gdy używana jest zarezerwowana pamięć\nProszę ponownie uruchomić funkcję "{0}" po ponownym uruchomieniu komputera
ShortcutPinning                           = Skrót "{0}" jest przypinany do Start...
SSDRequired                               = By korzystać z podsystemu Windows dla systemu Android™ urządzenie musi być wyposażone w dysk SSD
UninstallUWPForAll                        = Dla wszystkich użytkowników
UWPAppsTitle                              = Aplikacje UWP
HEVCDownloading                           = Pobieranie rozszerzeń wideo HEVC od producenta urządzenia... ~2,8 MB
GraphicsPerformanceTitle                  = Preferencje dotyczące wydajności grafiki
GraphicsPerformanceRequest                = Czy chcesz ustawić wydajność grafiki wybranej aplikacji na "Wysoka wydajność"?
ScheduledTaskPresented                    = Funkcja "{0}" została już utworzona jako "{1}"
CleanupTaskNotificationTitle              = Oczyszczanie system Windows
CleanupTaskNotificationEvent              = Uruchomić zadanie w celu usunięcia nieużywanych plików i aktualizacji systemu Windows?
CleanupTaskDescription                    = Czyszczenie nieużywanych plików i aktualizacji systemu Windows za pomocą wbudowanej aplikacji do czyszczenia dysku
CleanupNotificationTaskDescription        = Powiadomienie przypominające o czyszczeniu nieużywanych plików i aktualizacji systemu Windows
SoftwareDistributionTaskNotificationEvent = Pomyślnie usunięto pamięć podręczną aktualizacji systemu Windows
TempTaskNotificationEvent                 = Folder plików tymczasowych został pomyślnie wyczyszczony
FolderTaskDescription                     = Czyszczenie folderu {0}
EventViewerCustomViewName                 = Tworzenie procesu
EventViewerCustomViewDescription          = Tworzenie procesu i zdarzeń audytu
RestartWarning                            = Pamiętaj o ponownym uruchomieniu komputera
ErrorsLine                                = Linia
ErrorsMessage                             = Błędy/Ostrzeżenia
DialogBoxOpening                          = Wyświetlanie okna dialogowego...
Disable                                   = Wyłączyć
EXEFilesFilter                            = *.exe|*.exe|Wszystkie pliki (*.*)|*.*
FolderSelect                              = Wybierz folder
FilesWontBeMoved                          = Pliki nie zostaną przeniesione
Install                                   = Zainstalluj
NoData                                    = Nic do wyświetlenia
NoInternetConnection                      = Brak połączenia z internetem
RestartFunction                           = Uruchom ponownie funkcję "{0}".
NoResponse                                = Nie można nawiązać połączenia z {0}
Restore                                   = Przywróć
Run                                       = Uruchom
Skipped                                   = Pominięto
GPOUpdate                                 = Aktualizowanie GPO...
TelegramGroupTitle                        = Dołącz do naszej oficjalnej grupy na Telegramie
TelegramChannelTitle                      = Dołącz do naszego oficjalnego kanału Telegram
DiscordChannelTitle                       = Dołącz do naszego oficjalnego kanału na Discordzie
Uninstall                                 = Odinstaluj
'@

# SIG # Begin signature block
# MIIblQYJKoZIhvcNAQcCoIIbhjCCG4ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUCEkTK/42KlbDYyO+9yk4jDX+
# uSegghYNMIIDAjCCAeqgAwIBAgIQMB5osrsQ7LJHPnFCQcFydjANBgkqhkiG9w0B
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
# CSqGSIb3DQEJBDEWBBQ9uElsgOEg2xKoIEqz0Gdq+EjF8jANBgkqhkiG9w0BAQEF
# AASCAQB3rT/vMaLrAVkHIi7oWEan3WpGgs7gh3Lq7CeYsf8EH4RbicHufUBLPlOj
# tNpBHWo9G0kRm+ky7o2A/xS9AAljSCI0lpXT2Ez0EC05U8f8ongPhsG3eRiN1bh7
# nqcnmWtaSNSARqV5wDyPCPvBB71duaJT8E1xNQk7SIcv+kLKsmsyoMHgEmGhJ7h1
# OqF9/OGvnKmewjGnsO5JwzNnjSBCtnMlFNT0IMGybM4UGNY+LJHnqYo9ozEdr3UU
# oYug6y83/l3yKbUuPeyMXorYHmxHfl9rh+A+M/sFfYiRMC8w8X/qb76aePfhv3Xs
# SB5N5bnmbmhh7XF38P5WVfmCK4FFoYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJ
# AgEBMHcwYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTsw
# OQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVT
# dGFtcGluZyBDQQIQDE1pckuU+jwqSj0pB4A9WjANBglghkgBZQMEAgEFAKBpMBgG
# CSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDQwMTE1
# MTIyOVowLwYJKoZIhvcNAQkEMSIEIBFgS2AIq9lTEB1ZYIPeNSbYnQLyObZ/e7zN
# IwTmLdtWMA0GCSqGSIb3DQEBAQUABIICADxKosdRELa4XmkrrSgaKmAAxj5u3oYM
# +bgMSgP8tSUqFDAhQmMjs3wrfg0iRM/4Y2R4TM8HwFCwxeC9Z64eokJDnU9yZUqq
# 1ab9/ix37NrKSUpxd8GNAQ93AVgFPMh5Kl709wgxA3mez7ozF7wuutHXO3hz8974
# zazeHgDhWyWqwcXuGbSiJYAdHeW2LQbuK/wo8O5OzOWO2kNghYtLM7Cpy8Nd88CZ
# Kb/dLcSPYPZFPGM3ZR6KZYHV1DbWRZNCxI5j4lP38sMW2ZMR6QDhZrYtomOezWa7
# DhcBHls1dKoBwv2ksCaqTXuFiH3+cBZs++TrTSIimGeaLXYryNivBIN87ENTqN2w
# bsBtwzhYx+mcd/rP0aR/rwe+mfgZUiwe3QK+HYViVDgrB10QZaJEMikcPGaiu4vV
# 2tkjSerGCyIKhBlHWATSN/aRAqj2bQvetss8RPVRWMeW2LK6dZ+S6HeVCU08xidv
# 5P7Ze+NEPOnRD9q5MKxx/Dh2fdbIQf4OnKD3PGu5cReRkfnoqUyfivlQJ7B/BDbF
# 2QijYdzfIWY5yjyZHpaPEZEAUQMjGTo0zhL7C4VmlYfMEsVIy9vY9groYymjxI7a
# 4v/IpuaP++bFRcloWL/TAQOZzmmNMAm04XRZsGjGMTqSzFbBG4c11+AGmVExZSJo
# v3/LWXjsOuJP
# SIG # End signature block
