# Check if ran as administrator
$adminCheck=[bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if (!$adminCheck) {
    "Please run as administrator. Exiting..."
    exit 1
}

# Check and install choco package manager
Write-Output "Running Choco check..."
$chocoCheck = 'choco version'
if ($chocoCheck -contains "choco :")) {
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

# Choco package grabber
$input="placeholder"
 while ($input -ne "") {
    $input = read-host -prompt "Enter a keyword for the package you would like to search for, or just press enter when done`r`nPackage keyword"
    if ($input -ne "") {
        $initSearch=choco search $input
        if ($initSearch -notcontains "0 packages found.") {
            foreach ($line in ($initSearch | select -skip 1)) {
                write-output $line.Split(" ")[0]
            }
            $selection = read-host -prompt "Please enter a package name from the list, or 'n' to search again"
            if (($(choco info $selection) -notcontains "0 packages found.") -and $selection -ne "n") {
                choco install -y $selection
            }
            elseif ($selection -eq "n") {
                write-output "User declined selection. Going back..."
            }
            else {
                write-output "===== PACKAGE NOT FOUND. Please try again and double check your entry. ====="
            }
        }
        else {
            write-output "===== No packages found with keyword '${input}' ====="
        }
    }
}
