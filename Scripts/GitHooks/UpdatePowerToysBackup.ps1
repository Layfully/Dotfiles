$backupDir = "$env:USERPROFILE\Dotfiles\Config\PowerToys"
$latestBackupName = "latest_powertoys_backup.ptb"
$latestFile = Get-ChildItem -Path $backupDir -Filter "*.ptb" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestFile) {
  $latestFilePath = $latestFile.FullName

  # Construct the full path for the renamed file
  $renamedFilePath = Join-Path -Path $backupDir -ChildPath $latestBackupName

  # Rename the latest file
  Rename-Item -Path $latestFilePath -NewName $latestBackupName -Force

  # Remove other .ptb files
  Get-ChildItem -Path $backupDir -Filter "*.ptb" | Where-Object { $_.Name -ne $latestBackupName } | Remove-Item -Force

  Write-Host "PowerToys backup updated: $renamedFilePath"
}
else {
  Write-Host "No PowerToys backup files found."
}
