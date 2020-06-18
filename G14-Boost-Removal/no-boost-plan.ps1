# Now it is safe to run multiple times
# Additional runs will just switch to the new plan

# Registry update for PPBM option in power plan
set-itemproperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7\" -Name Attributes -Type Dword -Value 2 -Force

# Check for BOOST_0 plan
$checkRaw=(powercfg -l | select-string "BOOST_0")
if (!$checkRaw) {
    # Grab the default "High Performance" guid, duplicate, and create new guid
    $oguidRaw=(powercfg -l | select-string -casesensitive "High performance")
    $oguid=$($oguidRaw -Split " ")[3]
    $nguidRaw=(powercfg -duplicatescheme $oguid)
    $nguid=$($nguidRaw -Split " ")[3]

    # Redefine new guid alias and description, set as active
    powercfg -changename $nguid BOOST_0 "Sets CPU boost to disabled. By default, profile otherwise mimics the Windows default 'High performance' mode."
    write-output "Power plan created. Switching..."
}
else {
    $nguid=$($checkRaw -Split " ")[3]
    write-output "Power plan already detected. Switching..."
}
# Set as active
powercfg -setactive $nguid

# Grab the guid for the subgroup and property, set to disabled
$subgroupRaw=(powercfg -q | select-string "Processor power management")
$subgroup=$($subgroupRaw -Split " ")[4]
$setguidRaw=(powercfg -q | select-string "Processor performance boost mode")
$setguid=$($setguidRaw -Split " ")[7]
powercfg -setacvalueindex $nguid $subgroup $setguid 0
powercfg -setdcvalueindex $nguid $subgroup $setguid 0
