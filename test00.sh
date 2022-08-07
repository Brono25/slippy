#!/bin/dash


# ==============================================================================
# test00.sh
#
# Testing slippy Usage
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
seq 5 | slippy     		
seq 5 | slippy 1   		
seq 5 | slippy q q   	
seq 5 | slippy  d d    	
seq 5 | slippy  p p     
) 2> "$output" 

(
seq 5 | 2041 slippy  
seq 5 | 2041 slippy 1  
seq 5 | 2041 slippy q q 
seq 5 | 2041 slippy d d 
seq 5 | 2041 slippy p p 
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



#Checking invalid addresses 

echo "-------------INVALID 'n'------------"
(
seq 5 | slippy '0p'

) 2> "$output" 

(
seq 5 | 2041  slippy '0p'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID '/regex/'------------"
(
seq 25 | slippy '//p'
seq 25 | slippy '/\/p'

seq 25 | slippy -n '//p'
seq 25 | slippy -n '/\/p'


) 2> "$output" 

(
seq 25 | 2041 slippy '//p'
seq 25 | 2041 slippy '/\/p'

seq 25 | 2041 slippy -n '//p'
seq 25 | 2041 slippy -n '/\/p'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"




echo "-------------INVALID n1,n2 ------------"
(
seq 25 | slippy 'xp'
seq 25 | slippy '  x2p  '
seq 25 | slippy 'x1,x2p'
seq 25 | slippy '1,,2p'
seq 25 | slippy  '1,2,p'
seq 25 | slippy  ',1,2 p'

seq 25 | slippy -n 'xp'
seq 25 | slippy -n '  x2p  '
seq 25 | slippy -n 'x1,x2p'
seq 25 | slippy -n '1,,2p'
seq 25 | slippy -n '1,2,p'
seq 25 | slippy -n ',1,2 p'
) 2> "$output" 

(
seq 25 | 2041 slippy 'xp'
seq 25 | 2041 slippy '  x2p  '
seq 25 | 2041 slippy 'x1,x2p'
seq 25 | 2041 slippy '1,,2p'
seq 25 | 2041 slippy  '1,2,p'
seq 25 | 2041 slippy  ',1,2 p'

seq 25 | 2041 slippy -n 'xp'
seq 25 | 2041 slippy -n '  x2p  '
seq 25 | 2041 slippy -n 'x1,x2p'
seq 25 | 2041 slippy -n '1,,2p'
seq 25 | 2041 slippy -n '1,2,p'
seq 25 | 2041 slippy -n ',1,2 p'
) 2> "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID n, /regx/------------"
(
seq 25 | slippy  '2,///p'
seq 25 | slippy  '1,xp'
seq 25 | slippy  'x,/1/p'
seq 25 | slippy  '/x/,1,p'
) 2> "$output" 

(
seq 25 | 2041 slippy  '2,///p'
seq 25 | 2041 slippy  '1,xp'
seq 25 | 2041 slippy  'x,/1/p'
seq 25 | 2041 slippy  '/x/,1,p'
) 2> "$expected_output" 

test_outcome "$output" "$expected_output"





echo "-------------INVALID /regx/,n ------------"
(
seq 25 | slippy  '///,1p'
seq 25 | slippy  'x,1p'
seq 25 | slippy  'x,1p'
seq 25 | slippy  'x,1,p'

) 2> "$output" 

(
seq 25 | 2041 slippy  '///,1p'
seq 25 | 2041 slippy  'x,1p'
seq 25 | 2041 slippy  'x,1p'
seq 25 | 2041 slippy  'x,1,p'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"




echo "-------------INVALID /regx1/,/regx2/ ------------"
(
seq 25 | slippy  '///,2p'
seq 25 | slippy  '//,/ /p' 
seq 25 | slippy  '/1/,,/2/p'
seq 25 | slippy  ',/1/,/2/p'
) 2> "$output" 

(
seq 25 | 2041 slippy  '///,2p'
seq 25 | 2041 slippy  '//,/ /p' 
seq 25 | 2041 slippy  '/1/,,/2/p'
seq 25 | 2041 slippy  ',/1/,/2/p'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"







cd ..
rm -rf tmp




