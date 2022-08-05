#!/usr/bin/env python3

import slippy_debugging_tools as debug

import re
import slippy_utility as util


class Command:
    def __init__(self):
        self.operation = None  # q,p,d,s
        self.regex_flag = False
        self.begin_flag = False

        # address info
        self.is_address_found = False
        self.single_num = None
        self.single_regexp = None
        self.start_num = None
        self.start_regexp = None
        self.end_num = None
        self.end_regexp = None
        self.full_address = None
        # subs info
        self.s_pattern = None
        self.s_replace = None
        self.s_global_flag = 1


def isValidRegex(pattern, d=r'/'):
    """
    Checks if a regex pattern is valid.
    Slippy regex patterns cannot have un-escaped delimeters.
    """

    unescaped_del_pattern = str(r'[^\\]' + '\\' + d + '|^\\' + d)

    # Check for un-escaped delimeters
    if re.search(unescaped_del_pattern, pattern):
        util.printInvalidCommand()

    # Check regex is valid
    try:
        re.compile(pattern)
    except re.error:
        util.printInvalidCommand()

    return pattern


def isValidNumber(num):
    if num == 0:
        util.printInvalidCommand()
    return num


def getAddressInfo(cmd, cmd_info):
    """
    Retreive the address for a given slippy command
    """

    no_adrr = r'^[qpds]'
    single_num = r'(^(\d+)\s*)[qpds]'
    single_regx = r'(^/(.+)/\s*)[qpds]'
    regx_regx = r'(^/(.+)/\s*,\s*/(.+)/\s*)[pds]'
    regx_num = r'(^/(.+)/\s*,\s*(\d+)\s*)[pds]'
    num_regx = r'(^(\d+)\s*,\s*/(.+)/\s*)[pds]'
    num_num = r'(^(\d+)\s*,\s*(\d+)\s*)[pds]'

    if result := re.search(no_adrr, cmd):
        cmd_info.is_address_found = False

    elif result := re.search(regx_regx, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.start_regexp = isValidRegex(result.group(2))
        cmd_info.end_regexp = isValidRegex(result.group(3))
        cmd_info.is_address_found = True

    elif result := re.search(regx_num, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.start_regexp = isValidRegex(result.group(2))
        cmd_info.end_num = isValidNumber(int(result.group(3)))
        cmd_info.is_address_found = True

    elif result := re.search(num_regx, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.start_num = isValidNumber(int(result.group(2)))
        cmd_info.end_regexp = isValidRegex(result.group(3))
        cmd_info.is_address_found = True

    elif result := re.search(num_num, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.start_num = isValidNumber(int(result.group(2)))
        cmd_info.end_num = isValidNumber(int(result.group(3)))
        cmd_info.is_address_found = True

    elif result := re.search(single_num, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.single_num = isValidNumber(int(result.group(2)))
        cmd_info.is_address_found = True

    elif result := re.search(single_regx, cmd):
        cmd_info.full_address = result.group(1)
        cmd_info.single_regexp = isValidRegex(result.group(2))
        cmd_info.is_address_found = True

    else:
        util.printInvalidCommand()

    return cmd_info


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

        try:
            d = cmd[1]  # delimeter is first character after 's'
            cmd_info.delimiter = d
        except IndexError:
            util.printInvalidCommand()

        s_pattern = '^s' + d + r'(.+)' + d + r'(.*)' + d + r'(.*)$'

        if result := re.search(s_pattern, cmd):

            cmd_info.s_pattern = isValidRegex(result.group(1), d)
            cmd_info.s_replace = isValidRegex(result.group(2), d)

            if result.group(3).strip() == 'g':
                cmd_info.s_global_flag = 0

            elif result.group(3) == '':
                pass
            else:
                util.printInvalidCommand()

        else:
            util.printInvalidCommand()

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
    no_adrr = r'^(?:[qpd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    single_num = r'^\d+\s*(?:[qpd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    single_regx = r'^/.+/\s*(?:[qpd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    regx_regx = r'^/.+/\s*,\s*/.+/\s*(?:[pd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    regx_num = r'^/.+/\s*,\s*\d+\s*(?:[pd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    num_regx = r'^\d+\s*,\s*/.+/\s*(?:[pd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'
    num_num = r'^\d+\s*,\s*\d+\s*(?:[pd]|s(.).*\1.*\1\s*g?\s*)\s*(?:#.*)?\s*[;\n]*\s*$'

    commands = list()
    max_greedy = len(re.findall('[\n;]', cmd_list)) + 1
    nth_greedy = 1
    while cmd_list != '':

        cmd_list = cmd_list.strip('\n ;')
        parsed_sc = nthGreedyMatch(nth_greedy, cmd_list).strip('\n ;')
        parsed_nl = nthGreedyMatch(nth_greedy, cmd_list, '\n').strip('\n ;')



        if result := re.search(no_adrr, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(no_adrr, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(single_num, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(single_num, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(single_regx, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(single_regx, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(regx_regx, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(regx_regx, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(regx_num, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(regx_num, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(num_regx, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(num_regx, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(num_num, parsed_sc.strip()):
            cmd_list = cmd_list.replace(parsed_sc, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

        elif result := re.search(num_num, parsed_nl.strip()):
            cmd_list = cmd_list.replace(parsed_nl, '')
            trim_cmd = re.sub(r'\s*(?:#.*)?\s*[;\n]*\s*$', '', result.group())
            commands.append(trim_cmd)

            nth_greedy = RESET_NTH_GREEDY

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