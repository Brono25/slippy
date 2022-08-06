#!/bin/dash


# ==============================================================================
# test03.sh
#
# Testing slippy Substitute
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
seq 5 | slippy 's'		
seq 5 | slippy 's/'		
seq 5 | slippy 's//x/'	
seq 5 | slippy 's/a/b/t'
seq 5 | slippy 's/ / /b/g'
seq 5 | slippy 'sx x xbxg'
) 2> "$output" 

(		
seq 5 | 2041 slippy 's'		
seq 5 | 2041 slippy 's/'		
seq 5 | 2041 slippy 's//x/'	
seq 5 | 2041 slippy 's/a/b/t'
seq 5 | 2041 slippy 's/ / /b/t'
seq 5 | 2041 slippy 'sx x xbxg'
) 2> "$expected_output" 


test_outcome "$output" "$expected_output"


echo "-------------VALID 's/a/b/'------------"
(
seq 25 | slippy 's/1/x/g'
seq 25 | slippy 's/1/x/'
seq 25 | slippy '1,10d; s/.1/x/'
seq 25 | slippy '1,10d; s/.1/x/g'

) > "$output" 

(
seq 25 | 2041 slippy 's/1/x/g'
seq 25 | 2041 slippy 's/1/x/'
seq 25 | 2041 slippy '1,10d; s/.1/x/'
seq 25 | 2041 slippy '1,10d; s/.1/x/g'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID 'n s/a/b/'------------"
(
seq 25 | slippy '11s/1/x/g'
seq 25 | slippy '11d; 11s/./x/g'
seq 25 | slippy '1,10d; 5s/./x/g'
seq 25 | slippy -n '1,10d; 5s/./x/g'

) > "$output" 

(
seq 25 | 2041 slippy '11s/1/x/g'
seq 25 | 2041 slippy '11d; 11s/./x/g'
seq 25 | 2041 slippy '1,10d; 5s/./x/g'
seq 25 | 2041 slippy -n '1,10d; 5s/./x/g'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID '/regex/ s/a/b'------------"
(
seq 25 | slippy '/./s/1/x/g'
seq 25 | slippy '/2/s/1/x/g'
seq 25 | slippy '1,10d;/./s/1/x/g'
) > "$output" 

(
seq 25 | 2041 slippy '/./s/1/x/g'
seq 25 | 2041 slippy '/2/s/1/x/g'
seq 25 | 2041 slippy '1,10d;/./s/1/x/g'
) > "$expected_output" 

test_outcome "$output" "$expected_output"




echo "-------------VALID n1,n2 s/a/b/------------"
(
seq 25 | slippy '1,10s/1/x/g'
seq 25 | slippy ' 10,1 s/1/x/g'
seq 25 | slippy '1,1s/1/x/g'
seq 25 | slippy '1,10s/1//g; 2,5s/[0-9]/x/g'
seq 25 | slippy '2,5s/1//g; 1,10s/[0-9]/x/g'
) > "$output" 

(
seq 25 | 2041 slippy '1,10s/1/x/g'
seq 25 | 2041 slippy ' 10,1 s/1/x/g'
seq 25 | 2041 slippy '1,1s/1/x/g'
seq 25 | 2041 slippy '1,10s/1//g; 2,5s/[0-9]/x/g'
seq 25 | 2041 slippy '2,5s/1//g; 2,20s/[0-9]/x/g'
) > "$expected_output" 

test_outcome "$output" "$expected_output"





# echo "-------------VALID n, /regx/ d------------"
# (
# seq 25 | slippy  '1,/1/d'
# seq 25 | slippy  '10,/1/d'
# seq 25 | slippy  '1,/[0-9]/d'
# seq 25 | slippy  '10,/1/d; 5,/1/d; 1,/^[0-9]$/d'
# seq 25 | slippy  '1, /5/d; 2,/5/d'
# seq 25 | slippy  '1, 10d; 2,/5/d'

# ) > "$output" 

# (
# seq 25 | 2041 slippy  '1,/1/d'
# seq 25 | 2041 slippy  '10,/1/d'
# seq 25 | 2041 slippy  '1,/[0-9]/d'
# seq 25 | 2041 slippy  '10,/1/d; 5,/1/d; 1,/^[0-9]$/d'
# seq 25 | 2041 slippy  '1, /5/d; 2,/5/d'
# seq 25 | 2041 slippy  '1, 10d; 2,/5/d'

# ) > "$expected_output" 

# test_outcome "$output" "$expected_output"






# echo "-------------VALID /regx/,n d------------"
# (
# seq 25 | slippy  '/1/,2d'
# seq 25 | slippy  '/[0-9]/,1d' 
# seq 25 | slippy  '/1/,100d'
# seq 25 | slippy  '/1/,10d; /2/, 10d; /3/,10d'
# seq 25 | slippy  '1,10d; /2/, 10d;'
# ) > "$output" 

# (
# seq 25 | 2041 slippy  '/1/,2d'
# seq 25 | 2041 slippy  '/[0-9]/,1d' 
# seq 25 | 2041 slippy  '/1/,100d'
# seq 25 | 2041 slippy  '/1/,10d; /2/, 10d; /3/,10d'
# seq 25 | 2041 slippy  '1,10d; /2/, 10d;'
# ) > "$expected_output" 

# test_outcome "$output" "$expected_output"






# echo "-------------VALID /regx1/,/regx2/ d------------"
# (
# seq 25 | slippy '/1/,/1/d'
# seq 25 | slippy '/1/,/2/d'
# seq 25 | slippy '/./,/2/d'
# seq 25 | slippy '1,10d;/2/,/2/d'
# seq 25 | slippy '/1/,/1/d ; /1/,/1/d'
# ) > "$output" 

# (
# seq 25 | 2041 slippy '/1/,/1/d'
# seq 25 | 2041 slippy '/1/,/2/d'
# seq 25 | 2041 slippy '/./,/2/d'
# seq 25 | 2041 slippy '1,10d;/2/,/2/d'
# seq 25 | 2041 slippy '/1/,/1/d ; /1/,/1/d'

# ) > "$expected_output" 

# test_outcome "$output" "$expected_output"

















cd ..
rm -rf tmp




