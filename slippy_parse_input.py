#!/usr/bin/env python3

import slippy_debugging_tools as debug

import re
import slippy_utility as util


class Command:
    def __init__(self):
        self.operation        = None  # q,p,d,s
        self.end_flag         = False #used during processing
        self.begin_flag       = False #to keep track of line matching

        # address info
        self.is_address_found = False
        self.single_num       = None
        self.single_regex    = None
        self.start_num        = None
        self.start_regex     = None
        self.end_num          = None
        self.end_regex       = None
        self.full_address     = None
        # subs info
        self.s_pattern        = None
        self.s_replace        = None
        self.s_global_flag    = 1


def isValidRegex(pattern, d=r'/'):
    """
    Checks if a regex pattern is valid.
    Slippy regex patterns cannot have un-escaped delimeters.
    """

    d = re.escape(d)
    unescaped_del_pattern = rf'[^\\]{d}|^{d}'

    try:
        # Check for un-escaped delimeters
        if re.search(unescaped_del_pattern, pattern):
            util.printInvalidCommand()
        # Check regex is valid
        re.compile(re.escape(pattern))
    except re.error:
        util.printInvalidCommand()

    if re.search(r'^\\$', pattern):
        util.printInvalidCommand()

    return pattern


def isValidNumber(num):

    if num != r'$' and int(num) == 0:
        util.printInvalidCommand()

    if num != r'$':
        num = int(num)

    return num


def getAddressInfo(cmd, cmd_info):
    """
    Retreive the address for a given slippy command
    """
    n = r'(?:\d+|\$)'
    no_adrr = r'^[qpds]'
    single_num = rf'(^({n})\s*)[qpds]'
    single_regx = r'(^/(.+)/\s*)[qpds]'
    regx_regx = r'(^/(.+)/\s*,\s*/(.+)/\s*)[pds]'
    regx_num = rf'(^/(.+)/\s*,\s*({n})\s*)[pds]'
    num_regx = rf'(^({n})\s*,\s*/(.+)/\s*)[pds]'
    num_num = rf'(^({n})\s*,\s*({n})\s*)[pds]'



    if result := re.search(no_adrr, cmd):
        cmd_info.is_address_found = False

    elif result := re.search(regx_regx, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.start_regex = isValidRegex(result.group(2))
        cmd_info.end_regex = isValidRegex(result.group(3))
        cmd_info.is_address_found = True

    elif result := re.search(regx_num, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.start_regex = isValidRegex(result.group(2))
        cmd_info.end_num = isValidNumber(int(result.group(3)))
        cmd_info.is_address_found = True

    elif result := re.search(num_regx, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.start_num = isValidNumber(result.group(2))
        cmd_info.end_regex = isValidRegex(result.group(3))
        cmd_info.is_address_found = True

    elif result := re.search(num_num, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.start_num = isValidNumber(result.group(2))
        cmd_info.end_num = isValidNumber(result.group(3))
        cmd_info.is_address_found = True
        if cmd_info.end_num != r'$' and cmd_info.start_num != r'$':

            if cmd_info.end_num < cmd_info.start_num:
                cmd_info.end_num = cmd_info.start_num


    elif result := re.search(single_num, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.single_num = isValidNumber(result.group(2))
        cmd_info.is_address_found = True


    elif result := re.search(single_regx, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.single_regex = isValidRegex(result.group(2))
        cmd_info.is_address_found = True

    else:
        util.printInvalidCommand()

    return cmd_info




def parsePatternReplace(sub_input):

    d = sub_input[1]
    sub_input = sub_input[2:]

    delim_count = 1

    #find pattern
    patt = ''
    repl = ''
    flag = ''
    escape_found = False



    for c in sub_input:

        if c == '\\':

            escape_found = True

            if delim_count == 1:
                patt += c
            if delim_count == 2:
                repl += c
            if delim_count == 3:
                flag += c
            continue

        if not escape_found and c == d:
            delim_count += 1

        escape_found = False
        if delim_count == 1:
                patt += c
        if delim_count == 2:
                repl += c
        if delim_count == 3:
            flag += c

        if delim_count >= 4:

            util.printInvalidCommand()

    patt = patt.strip()
    repl = repl[1:].replace(fr'\{d}', d)
    flag = flag[1:]

    print(repl, patt)

    if flag and flag != 'g':
        util.printInvalidCommand()

    if flag == 'g':
        flag = 1
    else:
        flag = 0

    return patt, repl, flag



def getCommandInfo(cmd, cmd_info):

    if result := re.search(r'^q\s*$', cmd):
        cmd_info.operation = result.group()

    elif result := re.search(r'^p\s*$', cmd):
        cmd_info.operation = result.group()

    elif result := re.search(r'^d\s*$', cmd):
        cmd_info.operation = result.group()

    elif result := re.search(r'^s', cmd):
        cmd_info.operation = result.group()

    else:
        util.printInvalidCommand()

    # parse substitute operation
    if cmd_info.operation == 's':

        patt, repl, flag = parsePatternReplace(cmd)
        cmd_info.s_pattern = patt
        cmd_info.s_replace = repl
        cmd_info.s_global_flag = flag

    return cmd_info


def nthGreedyMatch(n, string, sep=';'):
    """
    Returns a subset of string from the start to the the 'nth' seperator ';'.
    Duplicates in a row are counted as one
    i.e nthGreedyMatch(3, '; a ;; b ;;; c ;;;; d') = '; a ;; b ;;; c'
    """
    sep_count = 0
    match = ''

    for i, char in enumerate(string):
        match += char
        if char == sep:
            semi_colon = True
            if string[i + 1] == sep:
                continue
            else:
                sep_count += 1
        if sep_count == n:
            return match
    return string


# Parses commands by looking at a section of the input command string up until a seperator ';' is found.
# The section is then compared with valid input commands and if none are found the input command
# string is then searched up until the second ';' and then repeated. If the end of the command string
# is reached with no valid commands found then it is an invalid command.
# If a valid command is found then the valid command is stripped from the input command string
# and the process starts again.

def parseCommands(cmd_list):
    """
    Takes in a list of commands seperated by ';' and seperates them into a list.
    If one command is invalid the program errors.
    """



    RESET_NTH_GREEDY = 1

    # valid command patterns
    n = r'(?:\d+|\$)' # number address can be int or $
    no_adrr = r'^(?:[qpd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    single_num = rf'^{n}\s*(?:[qpd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    single_regx = r'^/.+/\s*(?:[qpd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    regx_regx = r'^/.+/\s*,\s*/.+/\s*(?:[pd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    regx_num = rf'^/.+/\s*,\s*{n}\s*(?:[pd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    num_regx = rf'^{n}\s*,\s*/.+/\s*(?:[pd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    num_num = rf'^{n}\s*,\s*{n}\s*(?:[pd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    comment_line = r'^\s*(?:#[^;\n]*)?\s*$'

    commands = list()
    max_greedy = len(re.findall('[\n;]', cmd_list)) + 1
    nth_greedy = 1
    while cmd_list != '':

        cmd_list = cmd_list.strip('\n ;')
        parsed_sc = nthGreedyMatch(nth_greedy, cmd_list).strip('\n ;')
        parsed_nl = nthGreedyMatch(nth_greedy, cmd_list, '\n').strip('\n ;')


        if result := re.search(no_adrr, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(no_adrr, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(single_num, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(single_num, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(single_regx, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(single_regx, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(regx_regx, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(regx_regx, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(regx_num, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(regx_num, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(num_regx, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(num_regx, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(num_num, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(num_num, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '', 1)
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY
        #ignore lines of just comments
        elif re.search(comment_line, parsed_sc.strip()) or re.search(comment_line,parsed_nl.strip()):
            cmd_list = ''
            pass

        else:
            nth_greedy += 1

        if nth_greedy > max_greedy:
            util.printInvalidCommand()

    return commands


def parseInput(slippy_input):

    #raw input from argv
    slippy_input = slippy_input.strip()

    #list of parsed commands from raw input
    cmd_list = parseCommands(slippy_input)

    #parse all the information about each command and store here
    executable_cmds = list()

    for cmd in cmd_list:

        cmd_info = Command()
        cmd_info = getAddressInfo(cmd, cmd_info)

        # Strip address from command before parsing command info
        cmd_stripped = cmd
        if cmd_info.full_address != None:
            cmd_stripped = re.sub(re.escape(cmd_info.full_address), '', cmd_stripped, 1)


        cmd_info = getCommandInfo(cmd_stripped, cmd_info)

        executable_cmds.append(cmd_info)


    return executable_cmds