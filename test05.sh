#!/bin/dash


# ==============================================================================
# test05.sh
#
# Testing slippy addresses with '$' character
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

eof


echo "-------------INVALID INPUT------------"
(
seq 5 | slippy '$$p'		
seq 5 | slippy '$$,$$d'	
seq 5 | slippy '$$,2d'	
seq 5 | slippy '1,$$s/a/b/'	
seq 5 | slippy '/$$/,$$q'	
seq 5 | slippy '$$,/$$/p'	

) 2> "$output" 

(		
seq 5 | 2041 slippy '$$p'		
seq 5 | 2041 slippy '$$,$$d'	
seq 5 | 2041 slippy '$$,2d'	
seq 5 | 2041 slippy '1,$$s/a/b/'	
seq 5 | 2041 slippy '/$$/,$$q'	
seq 5 | 2041 slippy '$$,/$$/p'	
) 2> "$expected_output" 


test_outcome "$output" "$expected_output"


echo "-------------VALID '$[qpds]'------------"
(
cat input | slippy '$q'
cat input | slippy '$p'
cat input | slippy '$d'
cat input | slippy '$s/1/x/'
cat input | slippy '$p ; $d ; $q ; $s/./x/'
cat input | slippy '$d ; $p ; $q ; $s/./x/'
cat input | slippy '$q ; $p ; $d ; $s/./x/'
cat input | slippy '$s/./x/ ; $p ; $d ; $q'

cat input | slippy -n '$q'
cat input | slippy -n '$p'
cat input | slippy -n '$d'
cat input | slippy -n '$s/1/x/'

) > "$output" 

(
cat input | 2041 slippy '$q'
cat input | 2041 slippy '$p'
cat input | 2041 slippy '$d'
cat input | 2041 slippy '$s/1/x/'
cat input | 2041 slippy '$p ; $d ; $q ; $s/./x/'
cat input | 2041 slippy '$d ; $p ; $q ; $s/./x/'
cat input | 2041 slippy '$q ; $p ; $d ; $s/./x/'
cat input | 2041 slippy '$s/./x/ ; $p ; $d ; $q'

cat input | 2041 slippy -n '$q'
cat input | 2041 slippy -n '$p'
cat input | 2041 slippy -n '$d'
cat input | 2041 slippy -n '$s/1/x/'


) > "$expected_output" 

test_outcome "$output" "$expected_output"





echo "-------------VALID 'n,$[qpds]'------------"
(
cat input | slippy '3,$p'
cat input | slippy '3,$d'
cat input | slippy '3,$s/1/x/'
cat input | slippy '100,$s/1/x/; 1,$p; 3,$d'
cat input | slippy '3,$d; $q; $p'



) > "$output" 

(
cat input | 2041 slippy '3,$p'
cat input | 2041 slippy '3,$d'
cat input | 2041 slippy '3,$s/1/x/'
cat input | 2041 slippy '100,$s/1/x/; 1,$p; 3,$d'
cat input | 2041 slippy '3,$d; $q; $p'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID '$,n[qpds]'------------"
(
cat input | slippy '$,1p'
cat input | slippy '$,1d'
cat input | slippy '$,1s/./x/g'
cat input | slippy '$,1p;$,1d;$,1s/./x/g'
) > "$output" 

(
cat input | 2041 slippy '$,1p'
cat input | 2041 slippy '$,1d'
cat input | 2041 slippy '$,1s/./x/g'
cat input | 2041 slippy '$,1p;$,1d;$,1s/./x/g'
) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID '$,$[qpds]'------------"
(
cat input | slippy '$,$p'
cat input | slippy '$,$d'
cat input | slippy '$,$s/./x/'
cat input | slippy '$,$p;$,$d;$,$s/./x/'

) > "$output" 

(
cat input | 2041 slippy '$,$p'
cat input | 2041 slippy '$,$d'
cat input | 2041 slippy '$,$s/./x/'
cat input | 2041 slippy '$,$p;$,$d;$,$s/./x/'
) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------VALID MULTI-COMMANDS------------"
(
cat input | slippy '$,$d; $,$p; $,$s|.|x|g ;; $d; $,$s:x.:xy:'
cat input | slippy '1,5d; 3,$p; 1,$s|.|x|g ;; 2d; 1,$s:x.:xy:'
cat input | slippy '2,3p ;;  1,$d; p ; 1,$s/[12]/y/' 


) > "$output" 

(
cat input | 2041 slippy '$,$d; $,$p; $,$s|.|x|g ;; $d; $,$s:x.:xy:'
cat input | 2041 slippy '1,5d; 3,$p; 1,$s|.|x|g ;; 2d; 1,$s:x.:xy:'
cat input | 2041 slippy '2,3p ;;  1,$d; p ; 1,$s/[12]/y/' 

) > "$expected_output" 

test_outcome "$output" "$expected_output"
















cd ..
rm -rf tmp




