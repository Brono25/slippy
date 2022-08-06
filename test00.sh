#!/bin/dash


# ==============================================================================
# test00.sh
#
# Testing slippy Quit functionality and Slippy usage
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




#testing using wrong arguments for slippy
echo "-------------SLIPPY USAGE------------"
seq 5 > "$test_input"

(
seq 5 | slippy     		#usage
echo $? 1>&2
seq 5 | slippy 1   		#invalid command
echo $? 1>&2
seq 5 | slippy q q   	#error
echo $? 1>&2
seq 5 | slippy  d d    	#error
echo $? 1>&2
seq 5 | slippy  p p     #error
echo $? 1>&2
# seq 5 | slippy  s s 	#invalid command
# echo $? 1>&2
) 2> "$output" 

(
seq 5 | 2041 slippy  
echo $? 1>&2
seq 5 | 2041 slippy 1  
echo $? 1>&2
seq 5 | 2041 slippy q q 
echo $? 1>&2
seq 5 | 2041 slippy d d 
echo $? 1>&2
seq 5 | 2041 slippy p p 
echo $? 1>&2
# seq 5 | 2041 slippy s s 
# echo $? 1>&2
) 2> "$expected_output" 

test_outcome "$output" "$expected_output"

echo "-------------SLIPPY INVALID OPTION------------"
(
seq 0 |slippy -q 'p'
seq 0 |slippy -nq 'p'
seq 0 |slippy -n -n 'p'
) 2> "$output" 

(
seq 0 |2041 slippy -q 'p'
seq 0 |2041 slippy -nq 'p'
seq 0 |2041 slippy -n -n 'p'
) 2> "$expected_output" 


test_outcome "$output" "$expected_output"



#slippy quit number address behaviour
echo "-------------Q-NUMBER ADDRESS VALID------------"
(
seq 5| slippy 'q'
seq 5| slippy ' q'
seq 5| slippy ' q '
seq 5| slippy '3q'
seq 5| slippy ' 3   q  '
seq 5| slippy '5q'
seq 5| slippy '10q'
# seq 5| slippy ''
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
# seq 5|2041 slippy ''
yes  |2041 slippy '10q' #inf input
) > "$expected_output" 


test_outcome "$output" "$expected_output"


#testing invalid arguments while using slippy quit
echo "-------------Q-ADDRESS INVALID------------"
(
seq 5| slippy 'sq'		#invalid command
echo $? 1>&2
seq 5| slippy '2/q'		#invalid command
echo $? 1>&2
seq 5| slippy '2.q'		#invalid command
echo $? 1>&2
seq 5| slippy '//q'		#invalid command
echo $? 1>&2
seq 5| slippy '///q'	#invalid command
echo $? 1>&2
seq 5| slippy '////q'	#invalid command
echo $? 1>&2
seq 5| slippy '0q'		#invalid command
echo $? 1>&2
seq 5|slippy '|q'
echo $? 1>&2
seq 5|slippy '/\/q'
echo $? 1>&2
) 2> "$output" 

(
seq 5|2041 slippy 'sq'		#invalid command
echo $? 1>&2
seq 5|2041 slippy '2/q'		#invalid command
echo $? 1>&2
seq 5|2041 slippy '2.q'		#invalid command
echo $? 1>&2
seq 5|2041 slippy '//q'		#invalid command
echo $? 1>&2
seq 5|2041 slippy '///q'	#invalid command
echo $? 1>&2
seq 5|2041 slippy '////q'	#invalid command
echo $? 1>&2
seq 5|2041 slippy '0q'		#invalid command
echo $? 1>&2
seq 5|2041 slippy '|q'		#invalid command
echo $? 1>&2
seq 5|2041 slippy '/\/q'	#invalid command
echo $? 1>&2

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"


echo "-------------Q-DELIMETER ADDRESS VALID------------"
(
# seq 5| slippy '\/1/q'
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
# seq 5|2041 slippy '\/1/q'
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



cd ..
rm -rf tmp




