#!/bin/dash


# ==============================================================================
# test08.sh
#
#Test slippy -i option
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


cat - <<eof |tee input1 input1_2041
a
b
c
d
eof

seq 5 |tee input2 input2_2041


echo "-------------Insert File ------------"

(
2041 slippy -i 's/a/x/' input1
2041 slippy -i '2,3p' input1
2041 slippy -i '4d' input1
2041 slippy -i '$q' input1
cat input1
) > "$output" 

(
2041 slippy -i 's/a/x/' input1_2041
2041 slippy -i '2,3p' input1_2041
2041 slippy -i '4d' input1_2041
2041 slippy -i '$q' input1_2041
cat input1_2041

) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------Insert Multiple Files ------------"

(
2041 slippy -i 's/a/x/' input1 input2
2041 slippy -i '4,8p' input1 input2
2041 slippy -i '7d' input1 input2
2041 slippy -i '$q' input1 input2
cat input1 input2
) > "$output" 

(
2041 slippy -i 's/a/x/' input1_2041 input2_2041
2041 slippy -i '4,8p' input1_2041 input2_2041
2041 slippy -i '7d' input1_2041 input2_2041
2041 slippy -i '$q' input1_2041 input2_2041
cat input1_2041 input2_2041

) > "$expected_output" 

test_outcome "$output" "$expected_output"


echo "-------------Insert Multiple Files using Command Script------------"

cat - <<eof |tee input1 input1_2041
a
b
c
d
eof

seq 5 |tee input2 input2_2041


cat - <<eof > cmds
p
1,2d
s/[23]/x/g
s/[a-z]/[A-Z]/
eof
(
slippy -f cmds -i input1 input2
cat input1 input2
) > "$output" 

(
2041 slippy -f cmds  -i input1_2041 input2_2041
cat input1_2041 input2_2041

) > "$expected_output" 

test_outcome "$output" "$expected_output"




cd ..
rm -rf tmp




