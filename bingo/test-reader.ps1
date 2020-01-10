$reader = [system.io.file]::opentext("C:\Users\bmosley\tinkering\git\projects\bingo\input.txt")
$card=@{}

echo "Enter the values consistently ascending or descending by column"
foreach ($p in "B","I","N","G","O") {
	for ($i=1; $i -le 5; $i++) {
        $line=$reader.readline()
        if ($line -eq $null) {break}
        $line | out-null
		if ($p -eq "N" -and $i -eq 3) {continue}
		$card.add("$p$i",$line)
	}
}

echo $card