#!/usr/bin/env python3



def printAddress(addr):

    if addr.is_address_found == False:
        print('No Address')

    if addr.single_num != None:
        print(r'single num:',addr.single_num)

    if addr.single_regexp != None:
        print(r'single regex:',addr.single_regexp)

    if addr.start_num != None:
        print(r'start num',addr.start_num)

    if addr.start_regexp != None:
        print(r'start regex',addr.start_regexp)

    if addr.end_num != None:
        print(r'end num',addr.end_num)

    if addr.end_regexp != None:
        print(r'end regex',addr.end_regexp)

    if addr.address_string != None:
        print(r'Full string:',addr.address_string)


def printCommand(cmd):

    print('operation:', cmd.operation)

    if cmd.operation == 's':
        print('delimeter:', cmd.delimiter)
        print('replace:', cmd.replace_regexp)
        print('replace:', cmd.substitute)
        print('flag:', cmd.flag)


