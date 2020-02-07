Write-Output "Running Choco check..."

# check and install choco pkg mgr
$chocoCheck = 'choco version'
if ($chocoCheck.StartsWith("choco :")) {
    $policyCheck = Get-ExecutionPolicy
    if ($policyCheck -eq "Unrestricted") {
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
    else {
        "Execution policy is restricted."
        exit 1
    }
}
else {
    Write-Output "Choco already installed."
}

$i = "i"
$counter = 0
$lib = @{}
while ($i -ne "0") {
    $i = Read-Host -prompt "Enter number of each desired application, followed by enter. When done, enter 0. For list, enter 99"
    if ($i -eq "99") {
        Write-Output "1) 7zip
2) steam
3) steam cmd
4) discord
5) chrome
6) chrome remote desktop
7) plex server
8) utorrent
9) obs
10) hwinfo
11) hijackthis
12) spybot s&d"
    }
    elseif ($i -ne "0") {
        switch ($i) {
            1 {$n = "7zip"}
            2 {$n = "steam"}
            3 {$n = "steamcmd"}
            4 {$n = "discord"}
            5 {$n = "googlechrome"}
            6 {$n = "chrome-remote-desktop-host"}
            7 {$n = "plex"}
            8 {$n = "utorrent"}
            9 {$n = "obs"}
            10 {$n = "hwinfo"}
            11 {$n = "hijackthis"}
            12 {$n = "spybot"}
        }
        $lib[$counter] = $n
        $counter++
    }
}

$command = "choco install -y"

foreach ($k in 0..$counter) {
    $package = $($lib[$k])
    $command = $command + " $package"
}

Invoke-Expression $command

# template for inline .msi installations:
# Start-Process msiexec.exe -Wait -ArgumentList '/I X:\path\to\msifile /quiet'
