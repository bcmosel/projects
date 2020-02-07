param(
	[parameter]
	[string]$machType
)

# confirm machType entry
if ($machType -eq "") {
	$machType = Read-Host -prompt "Personal or server?"
    $machType = $machType.ToLower()
}
else {
    $type = $type.ToLower()
    Write-Output "Using "$machType.toUpper"script."
}

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
elseif ($chocoCheck.StartsWith("Chocolatey")) {
    Write-Output "Choco already installed."
}
else {
    Write-Output "Logic mistake during chocolatey check"
}

if ($machType = "personal") {
    $personalType = Read-Host -prompt "Simple or advanced essentials? If you aren't sure, pick simple."
    $machType = $personalType.ToLower()
}

switch ($machType) {
    "server" {
        choco install -y 7zip steam steamcmd hwinfo.portable plex treesizefree chrome-remote-desktop-host googlechrome utorrent
    }
    "simple" {
        choco install -y 7zip steam discord googlechrome
    }
    "advanced" {
        choco install -y 7zip steam steamcmd vscode hijackthis hwinfo.portable treesizefree discord obs chrome-remote-desktop-host googlechrome utorrent
    }
}

# template for inline .msi installations:
# Start-Process msiexec.exe -Wait -ArgumentList '/I X:\path\to\msifile /quiet'
