$filename = "Name"
$destPath = "C:\Destination"
$srcPath = "C:\Source"
# date directory name
$dateBuild = Get-Date -UFormat "%Y_%m_%d"
# child directory name
$dateSub = Get-Date -UFormat "%H"
# destination with date directory
$destPathBuild = $destPath+$dateBuild+"\"
# negative value of number of days to keep
$age = (Get-Date).AddDays(-7)

# check that directory with date exists
if (-Not (Test-Path $destPathBuild))
{
    New-Item "$destPathBuild" -type Directory
}

# check that child hour directory within date directory exists
if (-Not (Test-Path ${destPathBuild}${dateSub}))
{
    New-Item "${destPathBuild}${dateSub}" -type Directory
}

# file extensions to select from source, followed by copies
foreach ($i in "db","fwl","db.old","fwl.old")
{
    Copy-Item "${srcPath}${filename}.${i}" ${destPathBuild}${dateSub} -Recurse -Force
}

# delete files older than the age set within the destination
Get-ChildItem -Path $destPath -Recurse |
    Where-Object {($_.LastwriteTime -lt  $age ) -and (! $_.PSIsContainer)} |
    Remove-Item -Force -Recurse
