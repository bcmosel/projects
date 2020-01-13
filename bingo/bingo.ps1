###########################################
# Bingo script by ben
########################################### 

param(
	[parameter(position=1)]
	[string]$mode,
	[parameter(position=2)]
	[string]$inputfile,
	[parameter]
	[switch]$help
)
# Help output
if ($help) {
	echo "USAGE: .\bingo.ps1 -mode [1 or 2] -inputfile [default none]"
	echo "Mode 1 for blackout, mode 2 for rows. Input file optional."
	exit
}
# Mode selection if not provided
if ($mode -eq "") {
	$mode = read-host -prompt "1) Blackout`r`n2) Rows`r`nMode (select number)"
}
else {
	echo "Using mode $mode."
}
# Input file if not provided
if ($inputfile -eq "") {
	$inputfile = read-host -prompt "Filename (Leave blank if none)"
}
# Input file reminder
if ($inputfile) {
	echo "Loading contents from $inputfile."
	$reader = [system.io.file]::opentext((resolve-path "$inputfile").path)
}
else {
	echo "No input file detected. Manual entry only..."
}
# Necessary variable declarations
$card=@{}
$removals = new-object system.collections.arraylist

# Function definitions
function card-input {
	# file input reception
	$i=0
	foreach ($line in get-content $inputfile) {
		if ($line -match $regex) {
			if ($mode -eq 1) {
				$card.add($i,$line)
				$i++
			}
			elseif ($mode -eq 2) {
				foreach ($p in "B","I","N","G","O") {
					for ($i=1; $i -le 5; $i++) {
						if ($p -eq "N" -and $i -eq 3) {continue}
						$line=$reader.readline()
						if ($line -eq $null) {break}
						$line | out-null
						$card.add("$p$i",$line)
					}
				}
			}
		}
	}
}
function removal-calls {
	# check for spaces with the value, add to to-remove list
	foreach ($k in $card.keys) {
		if ($($card.item($k)) -eq $call) {
			$removals.add($k) | out-null
		}
	}
	# removals list, remove from card and then empty removals list
	foreach ($r in $removals) {
		$card.remove($r)
		$removals = new-object system.collections.arraylist
	}
}
function bingo-blackout-card {
	# accept all spaces, unsorted
	$blackoutq = read-host -prompt "Number of values to fill (don't count free spaces)"
	echo "Enter values in any order, ignoring the free space."
	for ($i=1; $i -le $blackoutq; $i++) {
		$val = read-host -prompt "value $i"
		$card.add($i,$val)
	}
}
function bingo-blackout-calls {
	# accept calls for removing spaces
	while ($call -ne "exit") {
		$call = read-host -prompt "Number called"
		removal-calls
		# once the card is empty, kill the script
		if ($card.count -eq 0) {
			echo "BINGO! Blackout is done."
			$call="exit"
		}
	}
}
function bingo-rows-card {
	# accept all spaces as sorted by number/letter
	echo "Enter the values consistently ascending or descending by column"
	foreach ($p in "B","I","N","G","O") {
		for ($i=1; $i -le 5; $i++) {
			if ($p -eq "N" -and $i -eq 3) {continue}
			$val = read-host -prompt "value $p$i"
			$card.add("$p$i",$val)
		}
	}
}
function bingo-rows-calls {
	# accept calls for removing spaces
	while ($call -ne "exit") {
		$keylist = new-object system.collections.arraylist
		$call = read-host -prompt "Number called"
		removal-calls
		# once a row of the card is empty, kill the script (horizontal/vertical)
		foreach ($x in "B",1,"I",2,"N",3,"G",4,"O",5) {
			$checkpoint = echo $card.keys | select-string $x
			if ($checkpoint -eq $null) {
				switch -regex ($x) {
					'B|I|N|G|O' {echo "BINGO! $x column is done."}
					1 {echo "BINGO! 1st row is done."}
					2 {echo "BINGO! 2nd row is done."}
					3 {echo "BINGO! 3rd row is done."}
					'4|5' {echo "BINGO! ${x}th row is done."}
				}
				$call=exit
			}
		}
		# once a row of the card is empty, kill the script (diagonal)
		if ($(echo $card.keys | select-string "B1") -eq $null -and
				$(echo $card.keys | select-string "I2") -eq $null -and
				$(echo $card.keys | select-string "G4") -eq $null -and
				$(echo $card.keys | select-string "O5") -eq $null) {
					echo "BINGO! B1-O5 diagonal is done."
					$call="exit"
		}
		elseif ($(echo $card.keys | select-string "B5") -eq $null -and
				$(echo $card.keys | select-string "I4") -eq $null -and
				$(echo $card.keys | select-string "G2") -eq $null -and
				$(echo $card.keys | select-string "O1") -eq $null) {
					echo "BINGO! B5-O1 diagonal is done."
					$call="exit"
		}
	}
}

# Function order logic
switch ($mode){
	1 {if ($inputfile){card-input}else{bingo-blackout-card}bingo-blackout-calls}
	2 {if ($inputfile){card-input}else{bingo-rows-card}bingo-rows-calls}
	default {echo "Invalid mode selection."}
}