#!/bin/dash


# ==============================================================================
# test01.sh
#
# Testing slippy Quit functionality 
# ==============================================================================



PATH="$PATH:$(pwd)"


[ -d 'tmp' ] && rm -rf 'tmp'

output="$(mktemp)"
expected_output="$(mktemp)"
test_input="$(mktemp)"

trap 'rm -f $output $expected_output $test_input' EXIT INT


test_outcome()
{
	if ! diff "$1" "$2"
	then
    	echo "Failed test"
    	exit 1
    else
    	echo "Pass"
	fi
}

mkdir tmp
cd tmp




#slippy quit number address behaviour
echo "-------------Q-NUMBER ADDRESS ------------"
(
seq 5| slippy 'q'
seq 5| slippy ' q'
seq 5| slippy ' q '
seq 5| slippy '3q'
seq 5| slippy ' 3   q  '
seq 5| slippy '5q'
seq 5| slippy '10q'
yes  | slippy '10q' #inf input


) > "$output" 

(
seq 5|2041 slippy 'q'
seq 5|2041 slippy ' q'
seq 5|2041 slippy ' q '
seq 5|2041 slippy '3q'
seq 5|2041 slippy ' 3   q  '
seq 5|2041 slippy '5q'
seq 5|2041 slippy '10q'
yes  |2041 slippy '10q' #inf input
) > "$expected_output" 


test_outcome "$output" "$expected_output"




echo "-------------Q-DELIMETER ADDRESS ------------"
(

seq 5| slippy '/ /q'
seq 5| slippy '/^/q'
seq 5| slippy '/^ /q'
seq 5| slippy '/^$/q'
seq 5| slippy '/$/q'
seq 5| slippy '/$ /q'
seq 5| slippy '/2/    q' 
seq 5| slippy '    /2/    q' 
seq 5| slippy '/|/q' 

) > "$output" 

(
seq 5|2041 slippy '/ /q'
seq 5|2041 slippy '/^/q'
seq 5|2041 slippy '/^ /q'
seq 5|2041 slippy '/^$/q'
seq 5|2041 slippy '/$/q'
seq 5|2041 slippy '/$ /q'
seq 5|2041 slippy '/2/    q' 
seq 5|2041 slippy '    /2/    q' 
seq 5|2041 slippy '/|/q' 

) > "$expected_output" 


test_outcome "$output" "$expected_output"



echo "-------------MULTIPLE COMMANDS------------"
(
seq 25| slippy '1,5d; 3q;' 
seq 25| slippy '3q; 1,5d;' 
seq 25| slippy '3d;3q;4d;4q;5q' 
) > "$output" 

(
seq 25| 2041 slippy '1,5d; 3q;' 
seq 25| 2041 slippy '3q; 1,5d;' 
seq 25| 2041 slippy '3d;3q;4d;4q;5q' 
) > "$expected_output" 


test_outcome "$output" "$expected_output"







cd ..
rm -rf tmp




