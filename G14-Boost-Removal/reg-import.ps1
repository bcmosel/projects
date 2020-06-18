set-itemproperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7\" -Name Attributes -Type Dword -Value 2 -Force
powercfg -import "$pwd\BOOST_0"
