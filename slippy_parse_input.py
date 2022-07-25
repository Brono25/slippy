#!/usr/bin/env python3

import slippy_debugging_tools as debug

import  re
import slippy_utility as util


class Command:
    def __init__(self):

        self.operation        = None #q,p,d,s
        self.regex_flag       = False
        self.begin_flag       = False
        
        #address info
        self.is_address_found = False
        self.single_num       = None
        self.single_regexp    = None
        self.start_num        = None
        self.start_regexp     = None
        self.end_num          = None
        self.end_regexp       = None
        self.full_address     = None
        #subs info
        self.s_pattern        = None
        self.s_replace        = None
        self.s_global_flag    = 1




def getAddressInfo(cmd, cmd_info):
    """ 
    Retreive the address for a given slippy command
    """

    no_adrr     = r'^[qpds]'
    single_num  = r'(^(\d+)\s*)[qpds]'
    single_regx = r'(^/(.+)/\s*)[qpds]'
    regx_regx   = r'(^/(.+)/\s*,\s*/(.+)/\s*)[qpds]'
    regx_num    = r'(^/(.+)/\s*,\s*(\d+)\s*)[qpds]'
    num_regx    = r'(^(\d+)\s*,\s*/(.+)/\s*)[qpds]'
    num_num     = r'(^(\d+)\s*,\s*(\d+)\s*)[qpds]'


    if result := re.search(no_adrr, cmd):
        cmd_info.is_address_found  = False

    elif result := re.search(regx_regx, cmd):
        cmd_info.full_address     = result.group(1)
        cmd_info.start_regexp     = result.group(2)
        cmd_info.end_regexp       = result.group(3)
        cmd_info.is_address_found = True

    elif result := re.search(regx_num, cmd):
        cmd_info.full_address     = result.group(1)
        cmd_info.start_regexp     = result.group(2)
        cmd_info.end_num          = int(result.group(3))
        cmd_info.is_address_found = True

    elif result := re.search(num_regx, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.start_num    = int(result.group(2))
        cmd_info.end_regexp   = result.group(3)
        cmd_info.is_address_found  = True

    elif result := re.search(num_num, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.start_num    = int(result.group(2))
        cmd_info.end_num      = int(result.group(3))
        cmd_info.is_address_found  = True
        
    elif result := re.search(single_num, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.single_num   = int(result.group(2))
        cmd_info.is_address_found  = True

    elif result := re.search(single_regx, cmd):
        cmd_info.full_address  = result.group(1)
        cmd_info.single_regexp = result.group(2)
        cmd_info.is_address_found  = True

    else:
        util.printInvalidCommand()


    return cmd_info




def getCommandInfo(cmd, cmd_info):


    if result := re.search(r'^q', cmd):
        cmd_info.operation = result.group()
        
    elif result := re.search(r'^p', cmd):
        cmd_info.operation = result.group()

    elif result := re.search(r'^d', cmd):
        cmd_info.operation = result.group()

    elif result := re.search(r'^s', cmd):
        cmd_info.operation = result.group()

    #parse substitute operation
    if cmd_info.operation == 's':

        try:
            d = cmd[1] #delimeter is first character after 's'
            cmd_info.delimiter = d
        except IndexError:
            util.printInvalidCommand()

        s_pattern = '^s' + d + r'(.+)' + d + r'(.*)' + d + r'(.*)$'

        if result := re.search(s_pattern, cmd):

            cmd_info.s_pattern = result.group(1)
            cmd_info.s_replace = result.group(2)

            if result.group(3).strip() == 'g':
                cmd_info.s_global_flag = 0

            elif result.group(3) == '':
                pass
            else:
                util.printInvalidCommand()

        else:
            util.printInvalidCommand()

    return cmd_info
 




def parseInput(input_cmd):


    input_cmd  = input_cmd.strip()

    cmd_info = Command()

    cmd_info = getAddressInfo(input_cmd, cmd_info)

    #Strip address from command 
    cmd_stripped = input_cmd
    if cmd_info.full_address != None:
        cmd_stripped = re.sub(re.escape(cmd_info.full_address), '', cmd_stripped)

    cmd_info = getCommandInfo(cmd_stripped, cmd_info)

    return cmd_info










