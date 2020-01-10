###########################################
# Bingo script by ben
# Mode typing: done
# Card quantity: unfinished
# File input: done
# Help switch: done
########################################### 

param(
	[parameter(position=1)]
	[string]$mode,
	[parameter(position=2)]
	[int]$quantity,
	[parameter(position=3)]
	[string]$inputfile,
	[parameter(position=0)]
	[switch]$help
)

if ($help) {
	echo "USAGE: .\bingo.ps1 -mode [1 or 2] -quantity [default 1] -inputfile [default none]"
	echo "Mode 1 for blackout, mode 2 for rows. Quantity and input file are optional."
	exit
}

if ($mode -eq "") {
	$mode = read-host -prompt "1) Blackout`r`n2) Rows`r`nMode (select number)"
}
else {
	echo "Using $mode mode."
}

if ($inputfile) {
	echo "Loading contents from $inputfile."
}
else {
	echo "No input file detected. Manual entry only..."
}

$reader = [system.io.file]::opentext((resolve-path "$inputfile").path)
$card=@{}
$removals = new-object system.collections.arraylist

function card-input {
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
						$line=$reader.readline()
						if ($line -eq $null) {break}
						$line | out-null
						if ($p -eq "N" -and $i -eq 3) {continue}
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
	echo "Enter values in any order, ignoring the free space."
	for ($i=0; $i -le 23; $i++) {
		$val = read-host -prompt "value $i"
		$card.add($i,$val)
	}
}

function bingo-blackout-calls {
	# accept calls for removing spaces
	while ($call -ne "exit") {
		$call = read-host -prompt "number called"
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
		$call = read-host -prompt "number called"
		removal-calls
		# once a row of the card is empty, kill the script (horizontal/vertical)
		foreach ($x in "B",1,"I",2,"N",3,"G",4,"O",5) {
			$checkpoint = echo $card.keys | select-string $x
			if ($checkpoint -eq $null) {
				echo "BINGO! $x row/column is done."
				$call="exit"
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

if ($mode -eq 1) {
	if ($inputfile) {
		card-input
	}
	else {
		bingo-blackout-card
	}
	bingo-blackout-calls
}
elseif ($mode -eq 2) {
	if ($inputfile) {
		card-input
	}
	else {
		bingo-rows-card
	}
	bingo-rows-calls
}
else {
	echo "Invalid mode selection."
}