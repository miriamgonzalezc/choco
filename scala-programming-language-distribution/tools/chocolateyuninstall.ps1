$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'scala-programming-language-distribution*'
  fileType      = 'msi'
  silentArgs   = '/S'
  validExitCodes= @(0)
}

$uninstalled = $false

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % { 
    $packageArgs['file'] = "$($_.UninstallString)"
    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
      $packageArgs['file'] = ''
    }

    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}

# Get it
$path = [System.Environment]::GetEnvironmentVariable('PATH','Machine')
# Remove unwanted elements
$path = ($path.Split(';') | Where-Object { $_ -ne 'C:\Program Files (x86)\scala\bin' }) -join ';'
# Set it
[System.Environment]::SetEnvironmentVariable('PATH',$path,'Machine')


Update-SessionEnvironment

