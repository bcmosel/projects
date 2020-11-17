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
# Confirmation prompt
$pathResponse = read-host "Is the path `"$d2path`" correct? (Y/N)"
switch ($pathResponse) {
    "y" {write-output "Continuing"; break}
    default {write-output "Aborting"; exit 0}
}
# Grab list from bucket
$bucket = "https://storage.googleapis.com/storage/v1/b/pd2-client-files/o"
$bucketObj = invoke-webrequest -uri $bucket -method "GET" -usebasicparsing
$objRaw = convertfrom-json $bucketObj.content
#$objRange = 0..$($objRaw.items.count-1)
# Commented out full range, test variable below
$objRange = 1
# Scan checksums
$objRange | foreach-object {
    # Path $objPath needs delimiters to remove prefix/suffix
    $objPath = $objRaw.items[$_].id
    $objGen = $objRaw.items[$_].generation
    $objHash = $objRaw.items[$_].md5hash
    $objName = $objRaw.items[$_].name
    # Path $objPath will need to be inserted below
    $localName = "${d2path}"+"\ProjectD2\${objName}\$objGen"
    $localHash = $(get-filehash $localName -algorithm md5).hash
    if ($objHash -eq $localHash) {
        write-output "Match! Skipping to next file..."
        write-output "bucket: $objHash (local: $localHash)"
        write-output "filename: $objName (local: $localName)"
    }
    else {
        write-output "Unmatched! Downloading updated file..."
        write-output "bucket: $objHash (local: $localHash)"
        write-output "filename: $objName (local: $localName)"
    }
}

<#
to do list:
md5sums not correct locally, possible issue with 'generation' value
need logic for grabbing the file if matching
delimiters on the path of the 'id' value to cut out prefix/suffix (pd2 misnomer and generation id)
#>