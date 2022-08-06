#!/bin/dash


# ==============================================================================
# test02.sh
#
# Testing slippy Delete
# ==============================================================================



PATH="$PATH:$(pwd)"


[ -p 'tmp' ] && rm -rf 'tmp'

output="$(mktemp)"
expected_output="$(mktemp)"
test_input="$(mktemp)"

trap 'rm -f $output $expected_output $test_input tmp' EXIT INT


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
seq 25 | slippy p p 		#error
seq 25 | slippy 'pp'		#invalip command
seq 25 | slippy '0p'		#invalip command
seq 25 | slippy '1/ /p'	#invalip command
seq 25 | slippy '1pp'	#invalip command
) 2> "$output" 

(
seq 25 | 2041 slippy p p 	#error
seq 25 | 2041 slippy 'pp'	#invalip command
seq 25 | 2041 slippy '0p'	#invalip command
seq 25 | 2041 slippy '1/ /p'	#invalip command
seq 25 | 2041 slippy '1pp'	#invalip command
) 2> "$expected_output" 


test_outcome "$output" "$expected_output"



# check appress type 'np'
echo "-------------VALID 'np'------------"
(
seq 25 | slippy '   p  '
seq 25 | slippy '1p'
seq 25 | slippy '001p'
seq 25 | slippy '10p'
seq 25 | slippy '3 p'

seq 25 | slippy -n '   p  '
seq 25 | slippy -n '1p'
seq 25 | slippy -n '001p'
seq 25 | slippy -n '10p'
seq 25 | slippy -n '3 p'

) > "$output" 

(
seq 25 | 2041  slippy '   p  '
seq 25 | 2041  slippy '1p'
seq 25 | 2041  slippy '001p'
seq 25 | 2041  slippy '10p'
seq 25 | 2041  slippy '3 p'

seq 25 | 2041  slippy -n  '   p  '
seq 25 | 2041  slippy -n  '1p'
seq 25 | 2041  slippy -n  '001p'
seq 25 | 2041  slippy -n  '10p'
seq 25 | 2041  slippy -n  '3 p'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



# check appress type 'np'
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
seq 25 | slippy '/ /p'
seq 25 | slippy '/^2/p'
seq 25 | slippy '/\//p'
seq 25 | slippy '/ \ /p'
seq 25 | slippy '1,20d; /2/p' #regex on deleted line

seq 25 | slippy -n '/ /p'
seq 25 | slippy -n  '/^2/p'
seq 25 | slippy -n  '/\//p'
seq 25 | slippy -n  '/ \ /p'
seq 25 | slippy -n '1,20d; /2/p'

) > "$output" 

(
seq 25 | 2041  slippy '/ /p'
seq 25 | 2041  slippy '/^2/p'
seq 25 | 2041  slippy '/\//p'
seq 25 | 2041  slippy '/ \ /p'
seq 25 | 2041  slippy '1,20d; /2/p'

seq 25 | 2041  slippy -n   '/ /p'
seq 25 | 2041  slippy -n  '/^2/p'
seq 25 | 2041  slippy -n  '/\//p'
seq 25 | 2041  slippy -n  '/ \ /p'
seq 25 | 2041  slippy -n '1,20d; /2/p'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID '/regex/p'------------"
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



echo "-------------INVALID n1,n2 p------------"
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



echo "-------------VALID n1,n2 p------------"
(
seq 25 | slippy '1,10p'
seq 25 | slippy ' 10,1p '
seq 25 | slippy '1,1p'
seq 25 | slippy '1,10p;3,4p'

seq 25 | slippy -n '1,10p'
seq 25 | slippy -n ' 10,1p '
seq 25 | slippy -n '1,1p'
seq 25 | slippy -n '1,10p;3,4p'

) > "$output" 

(
seq 25 | 2041 slippy '1,10p'
seq 25 | 2041 slippy ' 10,1p '
seq 25 | 2041 slippy '1,1p'
seq 25 | 2041 slippy '1,10p;3,4p'

seq 25 | 2041 slippy -n '1,10p'
seq 25 | 2041 slippy -n ' 10,1p '
seq 25 | 2041 slippy -n '1,1p'
seq 25 | 2041 slippy -n '1,10p;3,4p'
) > "$expected_output" 

test_outcome "$output" "$expected_output"




echo "-------------INVALID n, /regx/p------------"
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



echo "-------------VALID n, /regx/ p------------"
(
seq 25 | slippy  '1,/1/p'
seq 25 | slippy  '10,/1/p'
seq 25 | slippy  '1,/[0-9]/p'
seq 25 | slippy  '10,/1/d; 5,/1/p; 1,/^[0-9]$/p'
seq 25 | slippy  '1, /5/d; 2,/5/p'
seq 25 | slippy  '1, 10d; 2,/5/p'

seq 25 | slippy  -n '1,/1/p'
seq 25 | slippy  -n '10,/1/p'
seq 25 | slippy  -n '1,/[0-9]/p'
seq 25 | slippy  -n '10,/1/d; 5,/1/p; 1,/^[0-9]$/p'
seq 25 | slippy  -n '1, /5/d; 2,/5/p'
seq 25 | slippy  -n '1, 10d; 2,/5/p'

) > "$output" 

(
seq 25 | 2041 slippy  '1,/1/p'
seq 25 | 2041 slippy  '10,/1/p'
seq 25 | 2041 slippy  '1,/[0-9]/p'
seq 25 | 2041 slippy  '10,/1/d; 5,/1/p; 1,/^[0-9]$/p'
seq 25 | 2041 slippy  '1, /5/d; 2,/5/p'
seq 25 | 2041 slippy  '1, 10d; 2,/5/p'

seq 25 | 2041 slippy  -n '1,/1/p'
seq 25 | 2041 slippy  -n '10,/1/p'
seq 25 | 2041 slippy  -n '1,/[0-9]/p'
seq 25 | 2041 slippy  -n '10,/1/d; 5,/1/p; 1,/^[0-9]$/p'
seq 25 | 2041 slippy  -n '1, /5/d; 2,/5/p'
seq 25 | 2041 slippy  -n '1, 10d; 2,/5/p'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID /regx/,n p------------"
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


echo "-------------VALID /regx/,n p------------"
(
seq 25 | slippy  '/1/,2p'
seq 25 | slippy  '/[0-9]/,1p' 
seq 25 | slippy  '/1/,100p'
seq 25 | slippy  '1,10d; /2/, 10p; /3/,10p'
seq 25 | slippy  '1,10d; /2/, 10p;'

seq 25 | slippy  -n '/1/,2p'
seq 25 | slippy  -n '/[0-9]/,1p' 
seq 25 | slippy  -n '/1/,100p'
seq 25 | slippy  -n '1,10d; /2/, 10p; /3/,10p'
seq 25 | slippy  -n '1,10d; /2/, 10p;'
) > "$output" 

(
seq 25 | 2041 slippy  '/1/,2p'
seq 25 | 2041 slippy  '/[0-9]/,1p' 
seq 25 | 2041 slippy  '/1/,100p'
seq 25 | 2041 slippy  '1,10d; /2/, 10p; /3/,10p'
seq 25 | 2041 slippy  '1,10d; /2/, 10p;'

seq 25 | 2041 slippy  -n '/1/,2p'
seq 25 | 2041 slippy  -n '/[0-9]/,1p' 
seq 25 | 2041 slippy  -n '/1/,100p'
seq 25 | 2041 slippy  -n '1,10d; /2/, 10p; /3/,10p'
seq 25 | 2041 slippy  -n '1,10d; /2/, 10p;'
) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID /regx1/,/regx2/ p------------"
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


echo "-------------VALID /regx1/,/regx2/ p------------"
(
seq 25 | slippy '/1/,/1/p'
seq 25 | slippy '/1/,/2/p'
seq 25 | slippy '/./,/2/p'
seq 25 | slippy '1,10d;/2/,/2/p'
seq 25 | slippy '/1/,/1/p ; /1/,/1/p'

seq 25 | slippy -n '/1/,/1/p'
seq 25 | slippy -n '/1/,/2/p'
seq 25 | slippy -n '/./,/2/p'
seq 25 | slippy -n '1,10d;/2/,/2/p'
seq 25 | slippy -n '/1/,/1/p ; /1/,/1/p'
) > "$output" 

(
seq 25 | 2041 slippy '/1/,/1/p'
seq 25 | 2041 slippy '/1/,/2/p'
seq 25 | 2041 slippy '/./,/2/p'
seq 25 | 2041 slippy '1,10d;/2/,/2/p'
seq 25 | 2041 slippy '/1/,/1/p ; /1/,/1/p'

seq 25 | 2041 slippy -n '/1/,/1/p'
seq 25 | 2041 slippy -n '/1/,/2/p'
seq 25 | 2041 slippy -n '/./,/2/p'
seq 25 | 2041 slippy -n '1,10d;/2/,/2/p'
seq 25 | 2041 slippy -n '/1/,/1/p ; /1/,/1/p'

) > "$expected_output" 

test_outcome "$output" "$expected_output"

















cd ..
rm -rf tmp




