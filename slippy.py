#!/usr/bin/env python3



import sys
import slippy_utility as util
import slippy_quit as sq


input_cmd = sys.argv[1]


mode = util.determineMode(sys.argv[1])

if mode == 'mode_quit':
	sq.performQuit(input_cmd)