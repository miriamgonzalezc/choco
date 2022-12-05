$LicensedCommandsRegistered = Get-Command "Invoke-ValidateChocolateyLicense" -EA SilentlyContinue
if (!$LicensedCommandsRegistered) {
  Write-Warning "Package Requires Commercial License - Installation cannot continue as Package Internalizer use require endpoints to be licensed with Chocolatey Licensed Extension v3.0.0+ (chocolatey.extension). Please see error below for details and correction instructions."
  throw "This package requires a commercial edition of Chocolatey as it was built/internalized with commercial features. Please install the license and install/upgrade to Chocolatey Licensed Extension v3.0.0+ as per https://docs.chocolatey.org/en-us/licensed-extension/setup."
}

Invoke-ValidateChocolateyLicense -RequiredLicenseTypes @('Business','ManagedServiceProvider')

$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= $env:ChocolateyPackageName
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\files\sfdx-windows-386.exe"
$url64      = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\files\sfdx-windows-amd64.exe"

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe' 
  url           = $url
  url64bit      = $url64
  softwareName  = 'sfdx*'
  checksum      = 'C29BC7251B7ECBB02657CDC33B1EFC373C7AFFF018A05039F036008F14EDA12B'
  checksumType  = 'sha256'
  checksum64    = '9C33344AED91F6CC2CF97A64A69D99CBAD9EBBF4A28920B8160CDFCE83772326'
  checksumType64= 'sha256'
  silentArgs   = '/S'
  validExitCodes= @(0)
}

$packageArgs["UseOriginalLocation"] = $true
Install-ChocolateyPackageCmdlet @packageArgs

#Set Path variable Salesforce-Cli
echo "Add C:\Program Files\sfdx\bin to PATH variable"
$path = [Environment]::GetEnvironmentVariable('PATH', 'Machine')
$path += ";C:\Program Files\sfdx\bin"
[Environment]::SetEnvironmentVariable('PATH', $path, 'Machine')

$appPath = "$env:ProgramFiles\sfdx"
$statementsToRun = "/C `"$appPath\bin\sfdx.exe`" update"
$cmdExitCodes = @(0)

Start-ChocolateyProcessAsAdmin $statementsToRun cmd -validExitCodes $cmdExitCodes

Update-SessionEnvironment