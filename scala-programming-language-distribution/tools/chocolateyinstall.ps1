$LicensedCommandsRegistered = Get-Command "Invoke-ValidateChocolateyLicense" -EA SilentlyContinue
if (!$LicensedCommandsRegistered) {
  Write-Warning "Package Requires Commercial License - Installation cannot continue as Package Internalizer use require endpoints to be licensed with Chocolatey Licensed Extension v3.0.0+ (chocolatey.extension). Please see error below for details and correction instructions."
  throw "This package requires a commercial edition of Chocolatey as it was built/internalized with commercial features. Please install the license and install/upgrade to Chocolatey Licensed Extension v3.0.0+ as per https://docs.chocolatey.org/en-us/licensed-extension/setup."
}

Invoke-ValidateChocolateyLicense -RequiredLicenseTypes @('Business','ManagedServiceProvider')

$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\files\scala-2.11.12.msi"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'msi' 
  url64bit      = $url64
  softwareName  = 'scala-programming-language-distribution*'
  silentArgs   = '/quiet /qn /norestart /log "c:\windows\temp\scala.log'
  validExitCodes= @(0)
}

Install-ChocolateyPackageCmdlet @packageArgs 

$path = [Environment]::GetEnvironmentVariable('PATH', 'Machine')
$path += ";C:\Program Files (x86)\scala\bin"
[Environment]::SetEnvironmentVariable('PATH', $path, 'Machine')

Update-SessionEnvironment