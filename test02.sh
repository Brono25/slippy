#!/bin/dash


# ==============================================================================
# test02.sh
#
# Testing slippy Delete
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
seq 5 | slippy d d 		#error
seq 5 | slippy 'dd'		#invalid command
seq 5 | slippy '0d'		#invalid command
seq 5 | slippy '1/ /d'	#invalid command
seq 5 | slippy '1dd'	#invalid command
) 2> "$output" 

(
seq 5 | 2041 slippy d d 	#error
seq 5 | 2041 slippy 'dd'	#invalid command
seq 5 | 2041 slippy '0d'	#invalid command
seq 5 | 2041 slippy '1/ /d'	#invalid command
seq 5 | 2041 slippy '1dd'	#invalid command
) 2> "$expected_output" 


test_outcome "$output" "$expected_output"



# check address type 'np'
echo "-------------VALID 'nd'------------"
(
cat input | slippy '   d  '
cat input | slippy '1d'
cat input | slippy '001d'
cat input | slippy '10d'
cat input | slippy '3 d'

cat input | slippy -n '   d  '
cat input | slippy -n '1d'
cat input | slippy -n '001d'
cat input | slippy -n '10d'
cat input | slippy -n '3 d'

) > "$output" 

(
cat input | 2041  slippy '   d  '
cat input | 2041  slippy '1d'
cat input | 2041  slippy '001d'
cat input | 2041  slippy '10d'
cat input | 2041  slippy '3 d'

cat input | 2041  slippy -n  '   d  '
cat input | 2041  slippy -n  '1d'
cat input | 2041  slippy -n  '001d'
cat input | 2041  slippy -n  '10d'
cat input | 2041  slippy -n  '3 d'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



# check address type 'np'
echo "-------------INVALID 'nd'------------"
(
seq 5 | slippy '0d'

) 2> "$output" 

(
seq 5 | 2041  slippy '0d'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID '/regex/d'------------"
(
cat input | slippy '/ /d'
cat input | slippy '/^2/d'
cat input | slippy '/\//d'
cat input | slippy '/ \ /d'
cat input | slippy '1,20d; /2/d' #regex on deleted line

cat input | slippy -n '/ /d'
cat input | slippy -n  '/^2/d'
cat input | slippy -n  '/\//d'
cat input | slippy -n  '/ \ /d'
cat input | slippy -n '1,20d; /2/d'

) > "$output" 

(
cat input | 2041  slippy '/ /d'
cat input | 2041  slippy '/^2/d'
cat input | 2041  slippy '/\//d'
cat input | 2041  slippy '/ \ /d'
cat input | 2041  slippy '1,20d; /2/d'

cat input | 2041  slippy -n   '/ /d'
cat input | 2041  slippy -n  '/^2/d'
cat input | 2041  slippy -n  '/\//d'
cat input | 2041  slippy -n  '/ \ /d'
cat input | 2041  slippy -n '1,20d; /2/d'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID '/regex/d'------------"
(
cat input | slippy '//d'
cat input | slippy '/\/d'

cat input | slippy -n '//d'
cat input | slippy -n '/\/d'


) 2> "$output" 

(
cat input | 2041 slippy '//d'
cat input | 2041 slippy '/\/d'

cat input | 2041 slippy -n '//d'
cat input | 2041 slippy -n '/\/d'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID n1,n2 d------------"
(
cat input | slippy 'xd'
cat input | slippy '  x2d  '
cat input | slippy 'x1,x2d'
cat input | slippy '1,,2d'
cat input | slippy  '1,2,d'
cat input | slippy  ',1,2 d'
) 2> "$output" 

(
cat input | 2041 slippy 'xd'
cat input | 2041 slippy '  x2d  '
cat input | 2041 slippy 'x1,x2d'
cat input | 2041 slippy '1,,2d'
cat input | 2041 slippy  '1,2,d'
cat input | 2041 slippy  ',1,2 d'
) 2> "$expected_output" 

test_outcome "$output" "$expected_output"





echo "-------------VALID n1,n2 d------------"
(
cat input | slippy '1,10d'
cat input | slippy ' 10,1d '
cat input | slippy '1,1d'
) > "$output" 

(
cat input | 2041 slippy '1,10d'
cat input | 2041 slippy ' 10,1d '
cat input | 2041 slippy '1,1d'
) > "$expected_output" 

test_outcome "$output" "$expected_output"


echo "-------------OVERLAPPING RANGES n1,n2 [pd]------------"
(
cat input | slippy '1,5d; 2,10d'
cat input | slippy -n '1,5d; 2,10p'
cat input | slippy -n '1,5p; 2,10d'
cat input | slippy -n '1,5p; 2,10p'
cat input | slippy  '1,10d; 10,12d'
cat input | slippy  '1,25d; 1,25d'
cat input | slippy  '1,25d; 1,25p'
cat input | slippy  '1,25p; 1,25d'
cat input | slippy  '1,25p; 1,25p'
cat input | slippy  '1,25d; 2,24d'
cat input | slippy  '1,25d; 2,24p'
cat input | slippy  '1,25p; 2,24d'
cat input | slippy  '1,25p; 2,24p'
cat input | slippy  '1,5p; 2,7p; 4,10p'
cat input | slippy  '1,5d; 2,7d; 4,10d'
cat input | slippy  '1,5d; 2,7p; 4,10p'
cat input | slippy  '1,5p; 2,7d; 4,10p'
cat input | slippy  '1,5p; 2,7p; 4,10d'
cat input | slippy  '1,5d; 2,7d; 4,10p'
cat input | slippy  '1,5p; 2,7d; 4,10d'

) > "$output" 

(
cat input | 2041 slippy '1,5d; 2,10d'
cat input | 2041 slippy -n '1,5d; 2,10p'
cat input | 2041 slippy -n '1,5p; 2,10d'
cat input | 2041 slippy -n '1,5p; 2,10p'
cat input | 2041 slippy  '1,10d; 10,12d'
cat input | 2041 slippy  '1,25d; 1,25d'
cat input | 2041 slippy  '1,25d; 1,25p'
cat input | 2041 slippy  '1,25p; 1,25d'
cat input | 2041 slippy  '1,25p; 1,25p'
cat input | 2041 slippy  '1,25d; 2,24d'
cat input | 2041 slippy  '1,25d; 2,24p'
cat input | 2041 slippy  '1,25p; 2,24d'
cat input | 2041 slippy  '1,25p; 2,24p'
cat input | 2041 slippy  '1,5p; 2,7p; 4,10p'
cat input | 2041 slippy  '1,5d; 2,7d; 4,10d'
cat input | 2041 slippy  '1,5d; 2,7p; 4,10p'
cat input | 2041 slippy  '1,5p; 2,7d; 4,10p'
cat input | 2041 slippy  '1,5p; 2,7p; 4,10d'
cat input | 2041 slippy  '1,5d; 2,7d; 4,10p'
cat input | 2041 slippy  '1,5p; 2,7d; 4,10d'

) > "$expected_output" 
test_outcome "$output" "$expected_output"


echo "-------------INVALID n, /regx/d------------"
(
cat input | slippy  '2,///d'
cat input | slippy  '1,xd'
cat input | slippy  'x,/1/d'
cat input | slippy  '/x/,1,d'
) 2> "$output" 

(
cat input | 2041 slippy  '2,///d'
cat input | 2041 slippy  '1,xd'
cat input | 2041 slippy  'x,/1/d'
cat input | 2041 slippy  '/x/,1,d'
) 2> "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID n, /regx/ d------------"
(
cat input | slippy  '1,/1/d'
cat input | slippy  '10,/1/d'
cat input | slippy  '1,/[0-9]/d'
cat input | slippy  '10,/1/d; 5,/1/d; 1,/^[0-9]$/d'
cat input | slippy  '1, /5/d; 2,/5/d'
cat input | slippy  '1, 10d; 2,/5/d'
cat input | slippy  '1, 10d; 2,/./d'

) > "$output" 

(
cat input | 2041 slippy  '1,/1/d'
cat input | 2041 slippy  '10,/1/d'
cat input | 2041 slippy  '1,/[0-9]/d'
cat input | 2041 slippy  '10,/1/d; 5,/1/d; 1,/^[0-9]$/d'
cat input | 2041 slippy  '1, /5/d; 2,/5/d'
cat input | 2041 slippy  '1, 10d; 2,/5/d'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID /regx/,n d------------"
(
cat input | slippy  '///,1d'
cat input | slippy  'x,1d'
cat input | slippy  'x,1d'
cat input | slippy  'x,1,d'
) 2> "$output" 

(
cat input | 2041 slippy  '///,1d'
cat input | 2041 slippy  'x,1d'
cat input | 2041 slippy  'x,1d'
cat input | 2041 slippy  'x,1,d'
) 2> "$expected_output" 

test_outcome "$output" "$expected_output"


echo "-------------VALID /regx/,n d------------"
(
cat input | slippy  '/1/,2d'
cat input | slippy  '/[0-9]/,1d' 
cat input | slippy  '/1/,100d'
cat input | slippy  '/1/,10d; /2/, 10d; /3/,10d'
cat input | slippy  '1,10d; /2/, 10d;'
) > "$output" 

(
cat input | 2041 slippy  '/1/,2d'
cat input | 2041 slippy  '/[0-9]/,1d' 
cat input | 2041 slippy  '/1/,100d'
cat input | 2041 slippy  '/1/,10d; /2/, 10d; /3/,10d'
cat input | 2041 slippy  '1,10d; /2/, 10d;'
) > "$expected_output" 

test_outcome "$output" "$expected_output"





echo "-------------INVALID /regx1/,/regx2/ d------------"
(
cat input | slippy  '///,2d'
cat input | slippy  '//,/ /d' 
cat input | slippy  '/1/,,/2/d'
cat input | slippy  ',/1/,/2/d'
) 2> "$output" 

(
cat input | 2041 slippy  '///,2d'
cat input | 2041 slippy  '//,/ /d' 
cat input | 2041 slippy  '/1/,,/2/d'
cat input | 2041 slippy  ',/1/,/2/d'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"


echo "-------------VALID /regx1/,/regx2/ d------------"
(
cat input | slippy '/1/,/1/d'
cat input | slippy '/1/,/2/d'
cat input | slippy '/./,/2/d'
cat input | slippy '1,10d;/2/,/2/d'
cat input | slippy '/1/,/1/d ; /1/,/1/d'
) > "$output" 

(
cat input | 2041 slippy '/1/,/1/d'
cat input | 2041 slippy '/1/,/2/d'
cat input | 2041 slippy '/./,/2/d'
cat input | 2041 slippy '1,10d;/2/,/2/d'
cat input | 2041 slippy '/1/,/1/d ; /1/,/1/d'

) > "$expected_output" 

test_outcome "$output" "$expected_output"

















cd ..
rm -rf tmp




