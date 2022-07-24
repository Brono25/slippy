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



# If a pair of '/' delimeters is found then true
def isDelimeterPresent(input_cmd):

	if found_delims := re.findall('/',input_cmd):
		if len(found_delims) == 2:
			return True
	return False
		

def getRegexBetweenDelimeters(input_cmd):

	cmd_list = input_cmd[:-1].split('/')

	#check for invalid strings outside of delimeters
	#only empty strings or white space is allowed
	if re.search(r'\S+', cmd_list[0]): 
		util.printInvalidCommand()

	if re.search(r'\S+', cmd_list[2]): 
		util.printInvalidCommand()

	regex = cmd_list[1]

	if regex == '':
		util.printInvalidCommand()


	return regex


def getNumberedAddress(input_cmd):

	num_address = input_cmd.strip()[:-1]

	#no address behaves as address = 1
	if num_address == '':
		num_address = 1

	try:
		num_address = int(num_address)
		if num_address == 0:
			util.printInvalidCommand()
		return num_address

	except ValueError:
		util.printInvalidCommand()



#------------------------------------------
#                  MAIN
#------------------------------------------


def performQuit(input_cmd):



	isCorrectNumArgs(input_cmd)
	regex = None
	address = None

	if isDelimeterPresent(input_cmd):
		regex = getRegexBetweenDelimeters(input_cmd)
	else:
		address = getNumberedAddress(input_cmd)


	
	line_num = 1
	for line in sys.stdin:

		print(line, end='')

		if address != None:
			if line_num == address:
				sys.exit(0)

		if regex != None:
			if  re.search(regex, line):
				sys.exit(0)


		line_num += 1
		










