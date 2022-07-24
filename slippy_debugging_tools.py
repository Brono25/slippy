#!/usr/bin/env python3





def printCommand(cmd):

    print('operation:', cmd.operation)
    print('replace:', cmd.s_replace)
    print('sub:', cmd.s_substitute)
    print('flag:', cmd.s_global_flag)
    print(r'single num:',cmd.single_num)
    print(r'single regex:',cmd.single_regexp)
    print(r'start num',cmd.start_num)
    print(r'start regex',cmd.start_regexp)
    print(r'end num',cmd.end_num)
    print(r'end regex',cmd.end_regexp)
    print(r'Full string:',cmd.full_address)


