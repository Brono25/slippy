#!/bin/dash


# ==============================================================================
# test02.sh
#
# Testing slippy Print
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







# check appress type 'np'
echo "------------- 'np'------------"
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





echo "------------- '/regex/p'------------"
(
seq 25 | slippy '/ /p'
seq 25 | slippy '/^2/p'
seq 25 | slippy '/\//p'
seq 25 | slippy '/ \ /p'
seq 25 | slippy '1,20d; /2/p' 

seq 25 | slippy -n '/ /p'
seq 25 | slippy -n  '/^2/p'
seq 25 | slippy -n  '/\//p'
seq 25 | slippy -n  '/ \ /p'
seq 25 | slippy -n '1,20d; /2/p'

) > "$output" 

(
seq 25 | 2041 slippy '/ /p'
seq 25 | 2041 slippy '/^2/p'
seq 25 | 2041 slippy '/\//p'
seq 25 | 2041 slippy '/ \ /p'
seq 25 | 2041 slippy '1,20d; /2/p' 

seq 25 | 2041 slippy -n '/ /p'
seq 25 | 2041 slippy -n  '/^2/p'
seq 25 | 2041 slippy -n  '/\//p'
seq 25 | 2041 slippy -n  '/ \ /p'
seq 25 | 2041 slippy -n '1,20d; /2/p'

) > "$expected_output" 

test_outcome "$output" "$expected_output"





echo "------------- n1,n2 p------------"
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







echo "------------- n, /regx/ p------------"
(
seq 25 | slippy  '1,/1/p'
seq 25 | slippy  '10,/1/p'
seq 25 | slippy  '1,/[0-9]/p'
seq 25 | slippy  '10,/1/d; 5,/1/p; 1,/^[0-9]$/p'
seq 25 | slippy  '1, /5/d; 2,/5/p'
seq 25 | slippy  '1, 10d; 2,/5/p'
seq 25 | slippy  '1, 10d; 2,/5/p'

seq 25 | slippy  -n '1,/1/p'
seq 25 | slippy  -n '10,/1/p'
seq 25 | slippy  -n '1,/[0-9]/p'
seq 25 | slippy  -n '10,/1/d; 5,/1/p; 1,/^[0-9]$/p'
seq 25 | slippy  -n '1, /5/d; 2,/5/p'
seq 25 | slippy  -n '1, 10d; 2,/5/p'
seq 25 | slippy  -n '1, 10d; 2,/5/p'

) > "$output" 

(
seq 25 | 2041 slippy  '1,/1/p'
seq 25 | 2041 slippy  '10,/1/p'
seq 25 | 2041 slippy  '1,/[0-9]/p'
seq 25 | 2041 slippy  '10,/1/d; 5,/1/p; 1,/^[0-9]$/p'
seq 25 | 2041 slippy  '1, /5/d; 2,/5/p'
seq 25 | 2041 slippy  '1, 10d; 2,/5/p'
seq 25 | 2041 slippy  '1, 10d; 2,/5/p'

seq 25 | 2041 slippy  -n '1,/1/p'
seq 25 | 2041 slippy  -n '10,/1/p'
seq 25 | 2041 slippy  -n '1,/[0-9]/p'
seq 25 | 2041 slippy  -n '10,/1/d; 5,/1/p; 1,/^[0-9]$/p'
seq 25 | 2041 slippy  -n '1, /5/d; 2,/5/p'
seq 25 | 2041 slippy  -n '1, 10d; 2,/5/p'
seq 25 | 2041 slippy  -n '1, 10d; 2,/5/p'

) > "$expected_output" 

test_outcome "$output" "$expected_output"





echo "------------- /regx/,n p------------"
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





echo "------------- /regx1/,/regx2/ p------------"
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




