#!/bin/dash


# ==============================================================================
# test05.sh
#
# Testing slippy multiple commands in files and input files
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




echo "-------------Multiple Commands in script ------------"
cat - <<eof > script1
1p
2d
3s/./x/

1,10p ; 3,/2/ s/[1]//g ;;;

;;; 9d

14q
eof

(
cat input | slippy -f script1
cat input | slippy -n -f script1
) > "$output" 

(
cat input | 2041 slippy -f script1
cat input | 2041 slippy -n -f script1
) > "$expected_output" 

test_outcome "$output" "$expected_output"




echo "-------------Multiple Commands in script with comments ------------"
cat - <<'eof' > script2

1,10p; #comment 1

#comment 2

5, $ s/[5]/x/g ;; #comment 3;; #comment 4

/./,/./p
/./,$ s/./y/
14q
#comment 5
eof

(
cat input | slippy -f script2
cat input | slippy -n -f script2
) > "$output" 

(
cat input | 2041 slippy -f script2
cat input | 2041 slippy -n -f script2
) > "$expected_output" 

test_outcome "$output" "$expected_output"




echo "-------------Large Number of Commands------------"
cat - <<'eof' > script3
/2$/,/8$/d;4,6p
/2/d;4q
4q;/2/d
sX[15]XzzzX
s?[15]?zzz?;5s/5/9/g;5s/1/2/
s/e//g
s/[15]/zzz/
s/z/x/
/.{2}/d
4d
/^.+5$/p
s?[15]?zzz?
/2/d
4p;/2/d
3,/2/d
1,25p; 2,24d
1,5p; 2,7d; 4,10d;/2$/,/8/d;55,6d
1,10p;3,4p
/2$/,/8$/d;55,6p
/2/d;4q
4q;/2/d
/./p
sX[15]XzzzX
/2/d
eof

(
cat input | slippy -f script3
cat input | slippy -n -f script3
) > "$output" 

(
cat input | 2041 slippy -f script3
cat input | 2041 slippy -n -f script3
) > "$expected_output" 

test_outcome "$output" "$expected_output"




echo "-------------Multiple Input Files------------"
seq 10 > file1
cat - <<eof > file2
line 1
line 2
line 3
eof
seq 101 99  1000 > file3

(
cat input | slippy -n 'p' file1 file2 file3
cat input | slippy  '3,5d' file1 file2 file3
cat input | slippy  '/2/,/5/ s/2./x/' file1 file2 file3

) > "$output" 

(
cat input | 2041 slippy -n 'p' file1 file2 file3
cat input | 2041 slippy  '3,5d' file1 file2 file3
cat input | 2041 slippy  '/2/,/5/ s/2./x/' file1 file2 file3
) > "$expected_output" 

test_outcome "$output" "$expected_output"



echo "-------------Multiple Input Files with $ addresses------------"

(
cat input | slippy -n '$p' file1 file2 file3
cat input | slippy  '3,$d' file1 file2 file3
cat input | slippy  '/2/,$ s/2./x/' file1 file2 file3
cat input | slippy  '$,$ p' file1 file2 file3
cat input | slippy  '$,$ d' file1 file2 file3
cat input | slippy  '$,1/ s/./x/' file1 file2 file3

) > "$output" 

(
cat input | 2041 slippy -n '$p' file1 file2 file3
cat input | 2041 slippy  '3,$d' file1 file2 file3
cat input | 2041 slippy  '/2/,$ s/2./x/' file1 file2 file3
cat input | 2041 slippy  '$,$ p' file1 file2 file3
cat input | 2041 slippy  '$,$ d' file1 file2 file3
cat input | 2041 slippy  '$,1/ s/./x/' file1 file2 file3
) > "$expected_output" 

test_outcome "$output" "$expected_output"













cd ..
rm -rf tmp




