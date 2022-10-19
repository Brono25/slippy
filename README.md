<h1>Slippy</h1>  <h3>COMP2041 Project</h3>

Create a program in python with the basic functionality of the GNU sed command line tool.
It features the same syntax except with 'sed' replaced by 'slippy'.

### Usage
```
slippy [-i] [-n] [-f <script-file> | <slippy-command>] [<files>...]
```
___
### Completed functionality:

substitute/delete/print/quit
```
seq 5| slippy 's/2/x/'
seq 5| slippy -n '2p'
seq 5| slippy '2d' 
seq 5| slippy '2q' 
```

Adresses
```
seq 5| slippy '2,3 s/./x/'
seq 5| slippy '2,/^4/ s/./x/'
seq 5| slippy '/^2/,4 s/./x/'
seq 5| slippy '/^2/,/^4/ s/./x/'
seq 5| slippy '/^2/,$ s/./x/'
```

Arbitrary delimiters
```
seq 5| slippy 's?2?x?'
```

Multiple commands
```
seq 5| slippy 's/2/x/ ; 3d ; 5p'
```

Commands from file
```
echo 4q   >  commands.slippy
seq 1 5 | slippy -f commands.slippy
```

Comments
```
seq 5 | slippy '2d #deletes line 2; 3p #prints line 3' 
```
