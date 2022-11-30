$bits = Get-ProcessorBits
$packageName = 'salesforceinspector-chrome'
$extensionID = 'aodjmnfhjibkcdimpodiifdjnnncaafh'

if ($bits -eq 64) {
    Remove-Item "HKLM:\SOFTWARE\Wow6432node\Google\Chrome\Extensions\$extensionID" -Force -ErrorAction SilentlyContinue | out-null
   }else{
    Remove-Item "HKLM:\SOFTWARE\Google\Chrome\Extensions\$extensionID" -Force -ErrorAction SilentlyContinue | out-null
}