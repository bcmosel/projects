# Run this only once!
# Each run will create a duplicate profile
# I'll be adding in some shit to detect that

# Grab the default "High Performance" guid, duplicate, and create new guid
$oguidRaw=(powercfg -l | select-string -casesensitive "High performance")
$oguid=$($oguidRaw -Split " ")[3]
$nguidRaw=(powercfg -duplicatescheme $oguid)
$nguid=$($nguidRaw -Split " ")[3]

# Redefine new guid alias and description, set as active
powercfg -changename $nguid BOOST_0 "Sets CPU boost to disabled. By default, profile otherwise mimics the Windows default 'High performance' mode."
powercfg -setactive $nguid

# Grab the guid for the subgroup and property, set to disabled
$subgroupRaw=(powercfg -q | select-string "Processor power management")
$subgroup=$($subgroupRaw -Split " ")[4]
$setguidRaw=(powercfg -q | select-string "Processor performance boost mode")
$setguid=$($setguidRaw -Split " ")[7]
powercfg -setacvalueindex $nguid $subgroup $setguid 0
powercfg -setdcvalueindex $nguid $subgroup $setguid 0
