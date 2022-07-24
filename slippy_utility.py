#!/usr/bin/env python3


import sys




def printInvalidCommand():
    print(f'slippy: command line: invalid command', file=sys.stderr)
    sys.exit(1)

def printError():
    print(f'slippy: error', file=sys.stderr)
    sys.exit(1)

