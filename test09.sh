#!/bin/dash


# ==============================================================================
# test09.sh
#
# Testing semi-colons, commas and white space in slippy commands
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
a,b,c,d
e;f;g;h
i
j
k
;
l
m
n
,
o
eof

echo "-------------Semi-Colons and addresses------------"
(
seq 5 | slippy '/;.*;/p'
seq 5 | slippy '/;/,$ p'
seq 5 | slippy '1,/;/ d'
seq 5 | slippy '/;/ , /;/ s/a/1/'
seq 5 | slippy '/;.*;/ s/;/x/g'
seq 5 | slippy '/;.*;/ s/./;/g'
) > "$output" 

(
seq 5 | 2041 slippy '/;.*;/p'
seq 5 | 2041 slippy '/;/,$ p'
seq 5 | 2041 slippy '1,/;/ d'
seq 5 | 2041 slippy '/;/ , /;/ s/a/1/'
seq 5 | 2041 slippy '/;.*;/ s/;/x/g'
seq 5 | 2041 slippy '/;.*;/ s/./;/g'
) > "$expected_output" 

test_outcome "$output" "$expected_output"




echo "-------------Commas and addresses------------"
(
seq 5 | slippy '1,/,/ d'
seq 5 | slippy '/,.*,/p'
seq 5 | slippy '/,/,$ p'
seq 5 | slippy '/,.*/ , /.*/ s/a/1/'
seq 5 | slippy '/,.*,/ s/,/x/g'
seq 5 | slippy '/,.*;,/ s/./,,/g'
) > "$output" 

(
seq 5 | 2041 slippy '1,/,/ d'
seq 5 | 2041 slippy '/,.*,/p'
seq 5 | 2041 slippy '/,/,$ p'
seq 5 | 2041 slippy '/,.*/ , /.*/ s/a/1/'
seq 5 | 2041 slippy '/,.*,/ s/,/x/g'
seq 5 | 2041 slippy '/,.*;,/ s/./,,/g'

) > "$expected_output" 

test_outcome "$output" "$expected_output"


echo "-------------White Space seperated input ------------"
(
seq 5 | slippy '1,/  ,   / d'
seq 5 | slippy '  /,.*,/     p'
seq 5 | slippy '/,/    ,     $       p'
seq 5 | slippy '   /,.*/    , /.*/    s/a/1/     g    '
seq 5 | slippy '  /,.*,/     s/,/x/  g' 
seq 5 | slippy '/,.*;,/    s    /./,,/   g'
) > "$output" 

(
seq 5 | 2041 slippy '1,/  ,   / d'
seq 5 | 2041 slippy '  /,.*,/     p'
seq 5 | 2041 slippy '/,/    ,     $       p'
seq 5 | 2041 slippy '   /,.*/    , /.*/    s/a/1/     g    '
seq 5 | 2041 slippy '  /,.*,/     s/,/x/  g' 
seq 5 | 2041 slippy '/,.*;,/    s    /./,,/   g'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------Commas, Semi-Colons, white space with multiple commands------------"
(
seq 5 | slippy '    1,/,/     s/[246]/x/   ;  ;  ;  ; 2,/,/p ;      $,/;/     d ;  /;/   ,    $     p'

) > "$output" 

(
seq 5 | 2041 slippy '    1,/,/     s/[246]/x/   ;  ;  ;  ; 2,/,/p ;      $,/;/     d ;  /;/   ,    $     p'

) > "$expected_output" 

test_outcome "$output" "$expected_output"



cd ..
rm -rf tmp




