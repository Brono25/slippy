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
seq 25 | slippy '   d  '
seq 25 | slippy '1d'
seq 25 | slippy '001d'
seq 25 | slippy '10d'
seq 25 | slippy '3 d'

seq 25 | slippy -n '   d  '
seq 25 | slippy -n '1d'
seq 25 | slippy -n '001d'
seq 25 | slippy -n '10d'
seq 25 | slippy -n '3 d'

) > "$output" 

(
seq 25 | 2041  slippy '   d  '
seq 25 | 2041  slippy '1d'
seq 25 | 2041  slippy '001d'
seq 25 | 2041  slippy '10d'
seq 25 | 2041  slippy '3 d'

seq 25 | 2041  slippy -n  '   d  '
seq 25 | 2041  slippy -n  '1d'
seq 25 | 2041  slippy -n  '001d'
seq 25 | 2041  slippy -n  '10d'
seq 25 | 2041  slippy -n  '3 d'

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
seq 25 | slippy '/ /d'
seq 25 | slippy '/^2/d'
seq 25 | slippy '/\//d'
seq 25 | slippy '/ \ /d'
seq 25 | slippy '1,20d; /2/d' #regex on deleted line

seq 25 | slippy -n '/ /d'
seq 25 | slippy -n  '/^2/d'
seq 25 | slippy -n  '/\//d'
seq 25 | slippy -n  '/ \ /d'
seq 25 | slippy -n '1,20d; /2/d'

) > "$output" 

(
seq 25 | 2041  slippy '/ /d'
seq 25 | 2041  slippy '/^2/d'
seq 25 | 2041  slippy '/\//d'
seq 25 | 2041  slippy '/ \ /d'
seq 25 | 2041  slippy '1,20d; /2/d'

seq 25 | 2041  slippy -n   '/ /d'
seq 25 | 2041  slippy -n  '/^2/d'
seq 25 | 2041  slippy -n  '/\//d'
seq 25 | 2041  slippy -n  '/ \ /d'
seq 25 | 2041  slippy -n '1,20d; /2/d'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID '/regex/d'------------"
(
seq 25 | slippy '//d'
seq 25 | slippy '/\/d'

seq 25 | slippy -n '//d'
seq 25 | slippy -n '/\/d'


) 2> "$output" 

(
seq 25 | 2041 slippy '//d'
seq 25 | 2041 slippy '/\/d'

seq 25 | 2041 slippy -n '//d'
seq 25 | 2041 slippy -n '/\/d'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID n1,n2 d------------"
(
seq 25 | slippy 'xd'
seq 25 | slippy '  x2d  '
seq 25 | slippy 'x1,x2d'
seq 25 | slippy '1,,2d'
seq 25 | slippy  '1,2,d'
seq 25 | slippy  ',1,2 d'
) 2> "$output" 

(
seq 25 | 2041 slippy 'xd'
seq 25 | 2041 slippy '  x2d  '
seq 25 | 2041 slippy 'x1,x2d'
seq 25 | 2041 slippy '1,,2d'
seq 25 | 2041 slippy  '1,2,d'
seq 25 | 2041 slippy  ',1,2 d'
) 2> "$expected_output" 

test_outcome "$output" "$expected_output"





echo "-------------VALID n1,n2 d------------"
(
seq 25 | slippy '1,10d'
seq 25 | slippy ' 10,1d '
seq 25 | slippy '1,1d'
) > "$output" 

(
seq 25 | 2041 slippy '1,10d'
seq 25 | 2041 slippy ' 10,1d '
seq 25 | 2041 slippy '1,1d'
) > "$expected_output" 

test_outcome "$output" "$expected_output"


echo "-------------OVERLAPPING RANGES n1,n2 [pd]------------"
(
seq 25 | slippy '1,5d; 2,10d'
seq 25 | slippy -n '1,5d; 2,10p'
seq 25 | slippy -n '1,5p; 2,10d'
seq 25 | slippy -n '1,5p; 2,10p'
seq 25 | slippy  '1,10d; 10,12d'
seq 25 | slippy  '1,25d; 1,25d'
seq 25 | slippy  '1,25d; 1,25p'
seq 25 | slippy  '1,25p; 1,25d'
seq 25 | slippy  '1,25p; 1,25p'
seq 25 | slippy  '1,25d; 2,24d'
seq 25 | slippy  '1,25d; 2,24p'
seq 25 | slippy  '1,25p; 2,24d'
seq 25 | slippy  '1,25p; 2,24p'
seq 25 | slippy  '1,5p; 2,7p; 4,10p'
seq 25 | slippy  '1,5d; 2,7d; 4,10d'
seq 25 | slippy  '1,5d; 2,7p; 4,10p'
seq 25 | slippy  '1,5p; 2,7d; 4,10p'
seq 25 | slippy  '1,5p; 2,7p; 4,10d'
seq 25 | slippy  '1,5d; 2,7d; 4,10p'
seq 25 | slippy  '1,5p; 2,7d; 4,10d'

) > "$output" 

(
seq 25 | 2041 slippy '1,5d; 2,10d'
seq 25 | 2041 slippy -n '1,5d; 2,10p'
seq 25 | 2041 slippy -n '1,5p; 2,10d'
seq 25 | 2041 slippy -n '1,5p; 2,10p'
seq 25 | 2041 slippy  '1,10d; 10,12d'
seq 25 | 2041 slippy  '1,25d; 1,25d'
seq 25 | 2041 slippy  '1,25d; 1,25p'
seq 25 | 2041 slippy  '1,25p; 1,25d'
seq 25 | 2041 slippy  '1,25p; 1,25p'
seq 25 | 2041 slippy  '1,25d; 2,24d'
seq 25 | 2041 slippy  '1,25d; 2,24p'
seq 25 | 2041 slippy  '1,25p; 2,24d'
seq 25 | 2041 slippy  '1,25p; 2,24p'
seq 25 | 2041 slippy  '1,5p; 2,7p; 4,10p'
seq 25 | 2041 slippy  '1,5d; 2,7d; 4,10d'
seq 25 | 2041 slippy  '1,5d; 2,7p; 4,10p'
seq 25 | 2041 slippy  '1,5p; 2,7d; 4,10p'
seq 25 | 2041 slippy  '1,5p; 2,7p; 4,10d'
seq 25 | 2041 slippy  '1,5d; 2,7d; 4,10p'
seq 25 | 2041 slippy  '1,5p; 2,7d; 4,10d'

) > "$expected_output" 
test_outcome "$output" "$expected_output"


echo "-------------INVALID n, /regx/d------------"
(
seq 25 | slippy  '2,///d'
seq 25 | slippy  '1,xd'
seq 25 | slippy  'x,/1/d'
seq 25 | slippy  '/x/,1,d'
) 2> "$output" 

(
seq 25 | 2041 slippy  '2,///d'
seq 25 | 2041 slippy  '1,xd'
seq 25 | 2041 slippy  'x,/1/d'
seq 25 | 2041 slippy  '/x/,1,d'
) 2> "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID n, /regx/ d------------"
(
seq 25 | slippy  '1,/1/d'
seq 25 | slippy  '10,/1/d'
seq 25 | slippy  '1,/[0-9]/d'
seq 25 | slippy  '10,/1/d; 5,/1/d; 1,/^[0-9]$/d'
seq 25 | slippy  '1, /5/d; 2,/5/d'
seq 25 | slippy  '1, 10d; 2,/5/d'

) > "$output" 

(
seq 25 | 2041 slippy  '1,/1/d'
seq 25 | 2041 slippy  '10,/1/d'
seq 25 | 2041 slippy  '1,/[0-9]/d'
seq 25 | 2041 slippy  '10,/1/d; 5,/1/d; 1,/^[0-9]$/d'
seq 25 | 2041 slippy  '1, /5/d; 2,/5/d'
seq 25 | 2041 slippy  '1, 10d; 2,/5/d'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------INVALID /regx/,n d------------"
(
seq 25 | slippy  '///,1d'
seq 25 | slippy  'x,1d'
seq 25 | slippy  'x,1d'
seq 25 | slippy  'x,1,d'
) 2> "$output" 

(
seq 25 | 2041 slippy  '///,1d'
seq 25 | 2041 slippy  'x,1d'
seq 25 | 2041 slippy  'x,1d'
seq 25 | 2041 slippy  'x,1,d'
) 2> "$expected_output" 

test_outcome "$output" "$expected_output"


echo "-------------VALID /regx/,n d------------"
(
seq 25 | slippy  '/1/,2d'
seq 25 | slippy  '/[0-9]/,1d' 
seq 25 | slippy  '/1/,100d'
seq 25 | slippy  '/1/,10d; /2/, 10d; /3/,10d'
seq 25 | slippy  '1,10d; /2/, 10d;'
) > "$output" 

(
seq 25 | 2041 slippy  '/1/,2d'
seq 25 | 2041 slippy  '/[0-9]/,1d' 
seq 25 | 2041 slippy  '/1/,100d'
seq 25 | 2041 slippy  '/1/,10d; /2/, 10d; /3/,10d'
seq 25 | 2041 slippy  '1,10d; /2/, 10d;'
) > "$expected_output" 

test_outcome "$output" "$expected_output"





echo "-------------INVALID /regx1/,/regx2/ d------------"
(
seq 25 | slippy  '///,2d'
seq 25 | slippy  '//,/ /d' 
seq 25 | slippy  '/1/,,/2/d'
seq 25 | slippy  ',/1/,/2/d'
) 2> "$output" 

(
seq 25 | 2041 slippy  '///,2d'
seq 25 | 2041 slippy  '//,/ /d' 
seq 25 | 2041 slippy  '/1/,,/2/d'
seq 25 | 2041 slippy  ',/1/,/2/d'

) 2> "$expected_output" 

test_outcome "$output" "$expected_output"


echo "-------------VALID /regx1/,/regx2/ d------------"
(
seq 25 | slippy '/1/,/1/d'
seq 25 | slippy '/1/,/2/d'
seq 25 | slippy '/./,/2/d'
seq 25 | slippy '1,10d;/2/,/2/d'
seq 25 | slippy '/1/,/1/d ; /1/,/1/d'
) > "$output" 

(
seq 25 | 2041 slippy '/1/,/1/d'
seq 25 | 2041 slippy '/1/,/2/d'
seq 25 | 2041 slippy '/./,/2/d'
seq 25 | 2041 slippy '1,10d;/2/,/2/d'
seq 25 | 2041 slippy '/1/,/1/d ; /1/,/1/d'

) > "$expected_output" 

test_outcome "$output" "$expected_output"

















cd ..
rm -rf tmp




