###########################################
# Bingo script by ben - golang version
# under construction
########################################### 

package main
import (
	"bufio"
	"fmt"
	"os"
)

# accept arguments for mode, inputfile, and help
mode := os.Args[0:]
inputfile := os.Args[1:]
help := os.Args

fmt.println(mode)
fmt.println(inputfile)
fmt.println(help)

# Help output
if help != nil {
	fmt.println("USAGE: bingo.go -mode [1 or 2] -inputfile [default none]")
	fmt.println("Mode 1 for blackout, mode 2 for rows. Input file optional.")
	os.exit(1)
}

# Mode selection if not provided
if mode == nil {
	# accept userinput for mode
} else {
	fmt.println("Using mode %d", mode)
}

# Input file if not provided
if inputfile != nil {
	fmt.println("Loading contents from %d", inputfile)
	# read the actual file contents
}

# Necessary variable declarations
# declare card as a dictionary?
# declare removals as a list?

# Function definitions
### card input function
func cardinput() {

}

### card removals function
func removalcalls() {

}

### blackout manual card creation
func blackoutcard() {

}

### blackout card calls
func blackoutcalls() {

}

### rows manual card creation
func rowscard() {

}

### rows card calls
func rowscalls() {

}

# Function order logic (switch for modes)