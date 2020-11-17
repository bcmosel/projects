# Check if ran as administrator
$adminCheck=[bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if (!$adminCheck) {
    "Please run as administrator. Exiting..."
    exit 1
}
# Establish D2 install path
# Auto-detect path is on to-do list
$d2Path = read-host -prompt "Full path to D2 (leave blank for 'C:\Program Files (x86)\Diablo II')"
if (!$d2path) {
    $d2path = "C:\Program Files (x86)\Diablo II"
}
$pathResponse = read-host "Is the path `"$d2path`" correct? (Y/N)"
switch ($pathResponse) {
    "y" {write-output "Happy path"; Break}
    default {write-output "Aborting"}
}

<#
general layout

#establish diablo path
##prompt for "is correct"
#scan checksum files
##list identified discrepencies
##continue/abort confirmation
#grab files

process:
#foreach $object read $name and $checksum
##check $d2path+$name for $checksumLocal
##if $checksum and $checksumLocal match, do nothing
##elseif $checksum and $checksumLocal do not match:
###grab $name and place in $d2path+$name
#>