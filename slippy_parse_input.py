#!/usr/bin/env python3


import  re



class Address:
    def __init__(self, is_address_found, single_num, single_regexp, start_num, start_regexp, end_num, end_regexp):
        self.is_address_found = is_address_found
        self.single_num = single_num 
        self.single_regexp = single_regexp        
        self.start_num = start_num
        self.start_regexp = start_regexp
        self.end_num = end_num
        self.end_regexp = end_regexp



def printAddress(addr):

    if addr.is_address_found == False:
        print('No Address')

    if addr.single_num != None:
        print(addr.single_num, end='  ')

    if addr.single_regexp != None:
        print(addr.single_regexp, end='  ')

    if addr.start_num != None:
        print(addr.start_num, end='  ')

    if addr.start_regexp != None:
        print(addr.start_regexp, end='  ')

    if addr.end_num != None:
        print(addr.end_num, end='  ')

    if addr.end_regexp != None:
        print(addr.end_regexp, end='  ')

    print('')



def getAddress(slippy_cmd):

    cmd  = slippy_cmd.strip()
    addr = Address(None, None, None, None, None, None, None)

    no_adrr     = r'^[qpds]'
    single_num  = r'^(\d+)\s*[qpds]'
    single_regx = r'^/(.+)/\s*[qpds]'
    regx_regx   = r'^/(.+)/\s*,\s*/(.+)/\s*[qpds]'
    regx_num    = r'^/(.+)/\s*,\s*(\d+)\s*[qpds]'
    num_regx    = r'^(\d+)\s*,\s*/(.+)/\s*[qpds]'
    num_num     = r'^(\d+)\s*,\s*(\d+)\s*[qpds]'



    if result := re.search(no_adrr, cmd):
        addr.is_address_found  = False

    elif result := re.search(regx_regx, cmd):
        addr.start_regexp = result.group(1)
        addr.end_regexp   = result.group(2)
        addr.is_address_found  = True

    elif result := re.search(regx_num, cmd):
        addr.start_regexp = result.group(1)
        addr.end_num      = int(result.group(2))
        addr.is_address_found  = True

    elif result := re.search(num_regx, cmd):
        addr.start_num  = result.group(1)
        addr.end_regexp = result.group(2)
        addr.is_address_found  = True

    elif result := re.search(num_num, cmd):
        addr.start_num = result.group(1)
        addr.end_num   = int(result.group(2))
        addr.is_address_found  = True
        
    elif result := re.search(single_num, cmd):
        addr.single_num = int(result.group(1))
        addr.is_address_found  = True

    elif result := re.search(single_regx, cmd):
        addr.single_regexp = result.group(1)
        addr.is_address_found  = True

    else:
        printInvalidCommand()




    printAddress(addr)



