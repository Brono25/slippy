#!/usr/bin/env python3

import slippy_debugging_tools as debug

import  re
import slippy_utility as util


class Command:
    def __init__(self):
        self.operation  = None
        self.delimiter  = '/'
        self.replace    = None
        self.substitute = None
        self.flag       = None



class Address:
    def __init__(self):
        self.is_address_found = False
        self.single_num       = None
        self.single_regexp    = None
        self.start_num        = None
        self.start_regexp     = None
        self.end_num          = None
        self.end_regexp       = None
        self.address_string   = None
        self.regex_found      = False



def getAddress(slippy_cmd):
    """ 
    Retreive the address for a given slippy command
    """

    cmd  = slippy_cmd.strip()
    addr_info = Address()

    no_adrr     = r'^[qpds]'
    single_num  = r'(^(\d+)\s*)[qpds]'
    single_regx = r'(^/(.+)/\s*)[qpds]'
    regx_regx   = r'(^/(.+)/\s*,\s*/(.+)/\s*)[qpds]'
    regx_num    = r'(^/(.+)/\s*,\s*(\d+)\s*)[qpds]'
    num_regx    = r'(^(\d+)\s*,\s*/(.+)/\s*)[qpds]'
    num_num     = r'(^(\d+)\s*,\s*(\d+)\s*)[qpds]'


    if result := re.search(no_adrr, cmd):
        addr_info.is_address_found  = False

    elif result := re.search(regx_regx, cmd):
        addr_info.address_string = result.group(1)
        addr_info.start_regexp   = result.group(2)
        addr_info.end_regexp     = result.group(3)
        addr_info.is_address_found  = True

    elif result := re.search(regx_num, cmd):
        addr_info.address_string = result.group(1)
        addr_info.start_regexp   = result.group(2)
        addr_info.end_num        = int(result.group(3))
        addr_info.is_address_found  = True

    elif result := re.search(num_regx, cmd):
        addr_info.address_string = result.group(1)
        addr_info.start_num      = int(result.group(2))
        addr_info.end_regexp     = result.group(3)
        addr_info.is_address_found  = True

    elif result := re.search(num_num, cmd):
        addr_info.address_string = result.group(1)
        addr_info.start_num      = int(result.group(2))
        addr_info.end_num        = int(result.group(3))
        addr_info.is_address_found  = True
        
    elif result := re.search(single_num, cmd):
        addr_info.address_string = result.group(1)
        addr_info.single_num     = int(result.group(2))
        addr_info.is_address_found  = True

    elif result := re.search(single_regx, cmd):
        addr_info.address_string = result.group(1)
        addr_info.single_regexp  = result.group(2)
        addr_info.is_address_found  = True

    else:
        util.printInvalidCommand()

    return addr_info




def getCommand(input_cmd, addr_string):


    cmd_isolated = input_cmd.strip()

    #if address is present strip it from the input command
    if addr_string != None:
        cmd_isolated = re.sub(re.escape(addr_string), '', cmd_isolated)


    cmd_info = Command()

    if result := re.search(r'^q', cmd_isolated):
        cmd_info.operation = result.group()
        
    elif result := re.search(r'^p', cmd_isolated):
        cmd_info.operation = result.group()

    elif result := re.search(r'^d', cmd_isolated):
        cmd_info.operation = result.group()

    elif result := re.search(r'^s', cmd_isolated):
        cmd_info.operation = result.group()

    #parse substitute operation
    if cmd_info.operation == 's':

        d = cmd_isolated[1] #delimeter is first character after 's'
        cmd_info.delimiter = d

        s_regex = '^s' + d + r'(.*)' + d + r'(.*)' + d + r'(.*)$'

        if result := re.search(s_regex, cmd_isolated):

            cmd_info.replace = result.group(1)
            cmd_info.substitute = result.group(2)

            if result.group(3) == 'g':
                cmd_info.flag = result.group(3)

            elif result.group(3) == '':
                pass
            else:
                util.printInvalidCommand()

        else:
            util.printInvalidCommand()





    return cmd_info
    












