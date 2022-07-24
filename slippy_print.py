#!/usr/bin/env python3



import sys
import re
import slippy_utility as util




#------------------------------------------
#                FUNCTIONS
#------------------------------------------


# if a 'q' command is found and more than one argument then error
def isCorrectNumArgs(input_cmd):

	if len(sys.argv) > 2:
		util.printError()



# If a pair or two pairs of '/' delimeters is found then true
def isDelimeterPresent(input_cmd):

	if found_delims := re.findall('/',input_cmd):
		if len(found_delims) == 2 or len(found_delims) == 4:
			return True
	return False
		

def getRegexBetweenDelimeters(input_cmd):

	cmd_list = input_cmd[:-1].split('/')

	




#------------------------------------------
#                  MAIN
#------------------------------------------


def performPrint(input_cmd):



	isCorrectNumArgs(input_cmd)
	regex = None
	address = None


	isDelimeterPresent(input_cmd)

	f = re.split(r'/', input_cmd[:-1])
	f = [x for x in f if x != '']
	#print(f)



	
	









