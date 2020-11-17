<#
to do list:
md5sums not correct locally, possible issue with 'generation' value
need logic for grabbing the file if matching
#>
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
$objRange = 0..$($objRaw.items.count-1) # production value
#$objRange = 1 # dev value
# Scan checksums
$objRange | foreach-object {
    $objPath = $objRaw.items[$_].id -replace $objRaw.items[$_].bucket,"ProjectD2" -replace $objRaw.items[$_].generation,""
    $objHash = $objRaw.items[$_].md5hash
    $objName = $objRaw.items[$_].name
    $localName = "${d2path}"+"\${objPath}" -replace ".$"
    # If the file exists, check for match and download if needed
    if (test-path $localName) {
        $localHash = $(get-filehash $localName -algorithm md5).hash
        if ($objHash -eq $localHash) {
            write-output "Match! Skipping $objName"
        }

        else {
            # Does not currently download anything, problem with md5 matching
            write-output "Downloading updated $objName ($objHash)"
            write-output "$localHash (mismatch)"
        }
    }
    else { 
        write-output "${objName} not found, downloading ($objHash)"
    }
}