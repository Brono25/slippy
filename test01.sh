#!/bin/dash


# ==============================================================================
# test01.sh
#
# Testing slippy Print 
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




echo "-------------INVALID INPUT------------"
(
seq 5 | slippy p p 		#error
seq 5 | slippy 'pp'		#invalid command
seq 5 | slippy '0p'		#invalid command
seq 5 | slippy '1/ /p'	#invalid command
seq 5 | slippy '1pp'	#invalid command
) 2> "$output" 

(
seq 5 | 2041 slippy p p 	#error
seq 5 | 2041 slippy 'pp'	#invalid command
seq 5 | 2041 slippy '0p'	#invalid command
seq 5 | 2041 slippy '1/ /p'	#invalid command
seq 5 | 2041 slippy '1pp'	#invalid command
) 2> "$expected_output" 


test_outcome "$output" "$expected_output"



# check address type 'np'
echo "-------------VALID 'np'------------"
(
seq 5 | slippy '   p  '
seq 5 | slippy '1p'
seq 5 | slippy '001p'
seq 5 | slippy '10p'
seq 5 | slippy '3 p'

seq 5 | slippy -n '   p  '
seq 5 | slippy -n '1p'
seq 5 | slippy -n '001p'
seq 5 | slippy -n '10p'
seq 5 | slippy -n '3 p'

) > "$output" 

(
seq 5 | 2041  slippy '   p  '
seq 5 | 2041  slippy '1p'
seq 5 | 2041  slippy '001p'
seq 5 | 2041  slippy '10p'
seq 5 | 2041  slippy '3 p'

seq 5 | 2041  slippy -n  '   p  '
seq 5 | 2041  slippy -n  '1p'
seq 5 | 2041  slippy -n  '001p'
seq 5 | 2041  slippy -n  '10p'
seq 5 | 2041  slippy -n  '3 p'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



# check address type 'np'
echo "-------------INVALID 'np'------------"
(
seq 5 | slippy '0p'

) 2> "$output" 

(
seq 5 | 2041  slippy '0p'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"





echo "-------------VALID '/regex/p'------------"
(
seq 5 | slippy '/ /p'
seq 5 | slippy '/^2/p'
seq 5 | slippy '/\//p'
seq 5 | slippy '/ \ /p'

seq 5 | slippy -n '/ /p'
seq 5 | slippy -n  '/^2/p'
seq 5 | slippy -n  '/\//p'
seq 5 | slippy -n  '/ \ /p'

) > "$output" 

(
seq 5 | 2041  slippy '/ /p'
seq 5 | 2041  slippy '/^2/p'
seq 5 | 2041  slippy '/\//p'
seq 5 | 2041  slippy '/ \ /p'

seq 5 | 2041  slippy -n   '/ /p'
seq 5 | 2041  slippy -n  '/^2/p'
seq 5 | 2041  slippy -n  '/\//p'
seq 5 | 2041  slippy -n  '/ \ /p'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID '/regex/p'------------"
(
seq 5 | slippy '//p'
seq 5 | slippy '/\/p'

seq 5 | slippy -n '//p'
seq 5 | slippy -n '/\/p'

) 2> "$output" 

(
seq 5 | 2041 slippy '//p'
seq 5 | 2041 slippy '/\/p'

seq 5 | 2041 slippy -n '//p'
seq 5 | 2041 slippy -n '/\/p'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID SINGLE NUM ADDRESS------------"
(
seq 5 | slippy '   p  '
seq 5 | slippy '  2p  '
seq 5 | slippy '/ 1 /,/ 2 /p'
seq 5 | slippy '1,/2 /p'
seq 5 | slippy  '1,/2 /p'
seq 5 | slippy  '1,2 p'
) > "$output" 

(
seq 5 | 2041 slippy '   p  '
seq 5 | 2041 slippy '  2p  '
seq 5 | 2041 slippy '/ 1 /,/ 2 /p'
seq 5 | 2041 slippy '1,/2 /p'
seq 5 | 2041 slippy  '1,/2 /p'
seq 5 | 2041 slippy  '1,2 p'
) > "$expected_output" 

test_outcome "$output" "$expected_output"









cd ..
rm -rf tmp




