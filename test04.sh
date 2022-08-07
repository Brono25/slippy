#!/bin/dash


# ==============================================================================
# test04.sh
#
# Testing slippy Substitute
# ==============================================================================



PATH="$PATH:$(pwd)"


[ -d 'tmp' ] && rm -rf 'tmp'

output="$(mktemp)"
expected_output="$(mktemp)"
test_input="$(mktemp)"

trap 'rm -f $output $expected_output $test_input ' EXIT INT


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


cat - <<eof > input
1
2
3
4
5

11
12
13
14
15

21
22
23
24
25
eof


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
cat input | slippy 's/1/x/g'
cat input | slippy 's/1/x/'
cat input | slippy '1,10d; s/.1/x/'
cat input | slippy '1,10d; s/.1/x/g'

) > "$output" 

(
cat input | 2041 slippy 's/1/x/g'
cat input | 2041 slippy 's/1/x/'
cat input | 2041 slippy '1,10d; s/.1/x/'
cat input | 2041 slippy '1,10d; s/.1/x/g'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID 'n s/a/b/'------------"
(
cat input | slippy '11s/1/x/g'
cat input | slippy '11d; 11s/./x/g'
cat input | slippy '1,10d; 5s/./x/g'
cat input | slippy -n '1,10d; 5s/./x/g'

) > "$output" 

(
cat input | 2041 slippy '11s/1/x/g'
cat input | 2041 slippy '11d; 11s/./x/g'
cat input | 2041 slippy '1,10d; 5s/./x/g'
cat input | 2041 slippy -n '1,10d; 5s/./x/g'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID '/regex/ s/a/b'------------"
(
cat input | slippy '/./s/1/x/g'
cat input | slippy '/2/s/1/x/g'
cat input | slippy '1,10d;/./s/1/x/g'
) > "$output" 

(
cat input | 2041 slippy '/./s/1/x/g'
cat input | 2041 slippy '/2/s/1/x/g'
cat input | 2041 slippy '1,10d;/./s/1/x/g'
) > "$expected_output" 

test_outcome "$output" "$expected_output"




echo "-------------VALID n1,n2 s/a/b/------------"
(
cat input | slippy '1,10s/1/x/g'
cat input | slippy ' 10,1 s/1/x/g'
cat input | slippy '1,1s/1/x/g'
cat input | slippy '1,10s/1//g; 2,5s/[0-9]/x/g'
cat input | slippy '2,5s/1//g; 1,10s/[0-9]/x/g'
cat input | slippy ' 10,1 s/1/x/g ; 1,10 s/2/y/g;'
cat input | slippy ' 10,1 s/1/x/g ; 2,9 s/2/y/g;'
cat input | slippy ' 2,9 s/1/x/g ; 10,1 s/2/y/g;'
cat input | slippy ' 10,1 s/1/x/g ; 10,1 s/2/y/g;'
cat input | slippy ' 2,9 s/1/x/g ; 2,9 s/2/y/g;'
) > "$output" 

(
cat input | 2041 slippy '1,10s/1/x/g'
cat input | 2041 slippy ' 10,1 s/1/x/g'
cat input | 2041 slippy '1,1s/1/x/g'
cat input | 2041 slippy '1,10s/1//g; 2,5s/[0-9]/x/g'
cat input | 2041 slippy '2,5s/1//g; 1,10s/[0-9]/x/g'
cat input | 2041 slippy ' 10,1 s/1/x/g ; 1,10 s/2/y/g;'
cat input | 2041 slippy ' 10,1 s/1/x/g ; 2,9 s/2/y/g;'
cat input | 2041 slippy ' 2,9 s/1/x/g ; 10,1 s/2/y/g;'
cat input | 2041 slippy ' 10,1 s/1/x/g ; 10,1 s/2/y/g;'
cat input | 2041 slippy ' 2,9 s/1/x/g ; 2,9 s/2/y/g;'
) > "$expected_output" 

test_outcome "$output" "$expected_output"


echo "-------------VALID n, /regx/ s/a/b/------------"
(
cat input | slippy  '1,/1/s/1/x/g'
cat input | slippy  '10,/1/s/1/x/g'
cat input | slippy  '1,/[0-9]/s/1/x/g'
cat input | slippy  '10,/1/s/1//g; 5,/1/s/1/y/g; 1,/^[0-9]$/s/1/x/g'
cat input | slippy  '1, 10d; 2,/5/s/1/x/g'


) > "$output" 

(
cat input | 2041 slippy  '1,/1/s/1/x/g'
cat input | 2041 slippy  '10,/1/s/1/x/g'
cat input | 2041 slippy  '1,/[0-9]/s/1/x/g'
cat input | 2041 slippy  '10,/1/s/1//g; 5,/1/s/1/y/g; 1,/^[0-9]$/s/1/x/g'
cat input | 2041 slippy  '1, 10d; 2,/5/s/1/x/g'

) > "$expected_output" 

test_outcome "$output" "$expected_output"






echo "-------------VALID /regx/,n s/a/b/------------"
(
cat input | slippy  '/1/,2s/1/x/g'
cat input | slippy  '/[0-9]/,1s/1/x/g' 
cat input | slippy  '/1/,100s/1/x/g'
cat input | slippy  '/1/,10d; /2/, 10s/1/x/g; /3/,10s/1/x/g'
cat input | slippy  '1,10d; /2/, 10s/1/x/g;'
) > "$output" 

(
cat input | 2041 slippy  '/1/,2s/1/x/g'
cat input | 2041 slippy  '/[0-9]/,1s/1/x/g' 
cat input | 2041 slippy  '/1/,100s/1/x/g'
cat input | 2041 slippy  '/1/,10d; /2/, 10s/1/x/g; /3/,10s/1/x/g'
cat input | 2041 slippy  '1,10d; /2/, 10s/1/x/g;'
) > "$expected_output" 

test_outcome "$output" "$expected_output"






echo "-------------VALID /regx1/,/regx2/ s/a/b/------------"
(
cat input | slippy '/1/,/1/s/1/x/g'
cat input | slippy '/1/,/2/s/1/x/g'
cat input | slippy '/./,/2/s/1/x/g'
cat input | slippy '1,10d;/2/,/2/s/1/x/g'
cat input | slippy '/1/,/1/s/1/x/g ; /1/,/1/s/1//g'
cat input | slippy '1,10d;/./,/./s/1//g'
) > "$output" 

(
cat input | 2041 slippy '/1/,/1/s/1/x/g'
cat input | 2041 slippy '/1/,/2/s/1/x/g'
cat input | 2041 slippy '/./,/2/s/1/x/g'
cat input | 2041 slippy '1,10d;/2/,/2/s/1/x/g'
cat input | 2041 slippy '/1/,/1/s/1/x/g ; /1/,/1/s/1//g'
cat input | 2041 slippy '1,10d;/./,/./s/1//g'

) > "$expected_output" 

test_outcome "$output" "$expected_output"

















cd ..
rm -rf tmp




