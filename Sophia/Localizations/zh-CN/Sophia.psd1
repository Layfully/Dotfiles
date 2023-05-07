ConvertFrom-StringData -StringData @'
UnsupportedOSBuild                        = \n脚本支持Windows 11 22H2+
UpdateWarning                             = \n您的Windows 11构建: {0}.{1}。支持的构建: 22621.1413和更高版本。运行Windows Update并再次尝试
UnsupportedLanguageMode                   = \nPowerShell会话在有限的语言模式下运行
LoggedInUserNotAdmin                      = \n登录的用户没有管理员的权利
UnsupportedPowerShell                     = \n你想通过PowerShell {0}.{1}运行脚本。在适当的PowerShell版本中运行该脚本
UnsupportedHost                           = \n该脚本不支持通过{0}运行
Win10TweakerWarning                       = \n可能你的操作系统是通过"Win 10 Tweaker"后门感染的
TweakerWarning                            = \nWindows的稳定性可能已被{0}所破坏。预防性地，重新安装整个操作系统
bin                                       = \nbin文件夹中没有文件。请重新下载该档案
RebootPending                             = \n计算机正在等待重新启动
UnsupportedRelease                        = \n找到新版本
CustomizationWarning                      = \n在运行Sophia Script之前，您是否已自定义{0}预设文件中的每个函数？
DefenderBroken                            = \nMicrosoft Defender 损坏或从操作系统中删除
UpdateDefender                            = \nMicrosoft Defender的定义已经过期。运行Windows Update并再次尝试
ControlledFolderAccessDisabled            = "受控文件夹访问"已禁用
ScheduledTasks                            = 计划任务
OneDriveUninstalling                      = 卸载OneDrive……
OneDriveInstalling                        = OneDrive正在安装……
OneDriveDownloading                       = 正在下载OneDrive…… ~33 MB
OneDriveWarning                           = 只有当预设被配置为删除OneDrive（或应用程序已经被删除）时，才会应用"{0}"功能，否则OneDrive中 "桌面 "和 "图片 "文件夹的备份功能就会中断
WindowsFeaturesTitle                      = Windows功能
OptionalFeaturesTitle                     = 可选功能
EnableHardwareVT                          = UEFI中开启虚拟化
UserShellFolderNotEmpty                   = 一些文件留在了"{0}"文件夹。请手动将它们移到一个新位置
RetrievingDrivesList                      = 取得驱动器列表……
DriveSelect                               = 选择将在其根目录中创建"{0}"文件夹的驱动器
CurrentUserFolderLocation                 = 当前"{0}"文件夹的位置:"{1}"
UserFolderRequest                         = 是否要更改"{0}"文件夹位置？
UserFolderSelect                          = 为"{0}"文件夹选择一个文件夹
UserDefaultFolder                         = 您想将"{0}"文件夹的位置更改为默认值吗？
ReservedStorageIsInUse                    = 保留存储空间正在使用时不支持此操作\n请在电脑重启后重新运行"{0}"功能
ShortcutPinning                           = "{0}"快捷方式将被固定到开始菜单……
SSDRequired                               = 要在您的设备上使用Windows Subsystem for Android™，您的电脑需要安装固态驱动器（SSD）
UninstallUWPForAll                        = 对于所有用户
UWPAppsTitle                              = UWP应用
HEVCDownloading                           = 下载"HEVC Video Extensions from Device Manufacturer"…… ~2,8 MB
GraphicsPerformanceTitle                  = 图形性能偏好
GraphicsPerformanceRequest                = 是否将所选应用程序的图形性能设置设为"高性能"？
ScheduledTaskPresented                    = "{0}"函数已经被创建为"{1}"
CleanupTaskNotificationTitle              = Windows清理
CleanupTaskNotificationEvent              = 运行任务以清理Windows未使用的文件和更新？
CleanupTaskDescription                    = 使用内置磁盘清理工具清理未使用的Windows文件和更新
CleanupNotificationTaskDescription        = 关于清理Windows未使用的文件和更新的弹出通知提醒
SoftwareDistributionTaskNotificationEvent = Windows更新缓存已成功删除
TempTaskNotificationEvent                 = 临时文件文件夹已成功清理
FolderTaskDescription                     = "{0}"文件夹清理
EventViewerCustomViewName                 = 进程创建
EventViewerCustomViewDescription          = 进程创建和命令行审核事件
RestartWarning                            = 确保重启电脑
ErrorsLine                                = 行
ErrorsMessage                             = 错误/警告
DialogBoxOpening                          = 显示对话窗口……
Disable                                   = 禁用
EXEFilesFilter                            = *.exe|*.exe|所有文件 (*.*)|*.*
FolderSelect                              = 选择一个文件夹
FilesWontBeMoved                          = 文件将不会被移动
Install                                   = 安装
NoData                                    = 无数据
NoInternetConnection                      = 无网络连接
RestartFunction                           = 请重新运行"{0}"函数
NoResponse                                = 无法建立{0}
Restore                                   = 恢复
Run                                       = 运行
Skipped                                   = 已跳过
GPOUpdate                                 = GPO更新……
TelegramGroupTitle                        = 加入我们的官方Telegram 群
TelegramChannelTitle                      = 加入我们的官方Telegram 频道
DiscordChannelTitle                       = 加入我们的官方Discord 频道
Uninstall                                 = 卸载
'@

# SIG # Begin signature block
# MIIblQYJKoZIhvcNAQcCoIIbhjCCG4ICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUFk+A4gmbcddPnnfOZsNGhFjL
# YcagghYNMIIDAjCCAeqgAwIBAgIQMB5osrsQ7LJHPnFCQcFydjANBgkqhkiG9w0B
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
# CSqGSIb3DQEJBDEWBBQnnkUmb/ddSsznDF855Wsl0CrsxTANBgkqhkiG9w0BAQEF
# AASCAQCjc12JH3u1H43c+/p3uQqW1rgAsrmMxphInOgZzUt8sMkrBaZZaR1Xae3/
# cVPpVo/U02bpHsXthdfDmfpUOge4Eanm0IB9pLWXladgv0nLdsATLbXZLAWVHxga
# YJJnXAfrkAg0SD3IK1sCMk0AEi7uXy3e9SpfSW3vrJIwwqZ/L2O3X4+NWg6cMtkH
# HnA+WJIFguztpsBUh2kLCLqaqTTfHjvCypu/WuQ2k8mVp3FLs6gLsuATMyzYLoCG
# PSoXL3IqMzZ3uXRw7I/gi3O8O/XaDGFMTi5XCbluCK+QFsIuptgIbn3yp4ba3w5T
# RkBBidn/ivSPVvdKRUDirgxuBWfgoYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJ
# AgEBMHcwYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTsw
# OQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVT
# dGFtcGluZyBDQQIQDE1pckuU+jwqSj0pB4A9WjANBglghkgBZQMEAgEFAKBpMBgG
# CSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDQwMTE1
# MTIyOVowLwYJKoZIhvcNAQkEMSIEIDuMpdL3czCJfXd+fko0pe4TpdxK9XFZ5BR8
# TIvcuIKKMA0GCSqGSIb3DQEBAQUABIICAFOAMP/PImcxucwBhJfObAI5RTL3qM9X
# oNtIyl/mN0la3U4Pd3srkwckWPwK9ViRUJhWX+7sJ1/dOXnbKh2d7tvex6M9YQn2
# lURlPov9uRQBJixEHZ2goKdU2L+k/NVDswhCpoZRCAgdmB5AEp7ZLnZBnZHXS42A
# 71myr6lIdBkguQflKs5sUf3wy3ilXk9Yt4xPaWj7rWc4Mt8X78RQ2Wfy974jmZXs
# 0P2MgIy5aBMLo7MSVtqN9Me+HCaMGoskyEWv/fu4xN3sPlhoSzns2nTSvIIs+4qz
# cbUeWPG6yE/3IcmIAaunmae94O2A1pZsL2CBUjsb9XsgBM/NSZqtiJbWE9/p8wY7
# xRYK1nET0YY3MrkTThudehwJSvezQLhSYCTSro+BqaFuGucK9HgcQdjBM4/4xm89
# TAy2WHCcRMJflwoSpN7iuv7rLtxC9N2llsTPn3dMyCCTzItnQmzYeHMtlFcrF1nG
# rZJ074OLYr/ia1LN6CeI27s0KgZ+/KRHlJJclXvO7fQQY+HZK+vyt6GLPL8rvXYS
# Gy9gaEYDdj/sCkN2fQcr6R4OddXEeS8ktNwgUZsowqNGdsbjHH/++fST3IzNbJ9D
# WYiwMlP7RvR1C3DGrtz8EQS7ZEez68dMy2iJtBEemTWJuG69m+D2gtssBwB5R+F4
# 7cta3UJQt/ZB
# SIG # End signature block
