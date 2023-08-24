#!/usr/bin/python3
'''
Permissively Rebuild All The Things (PRATT)
Copyright (C) 2023, Mo Zhou <lumin@debian.org>
License: GPL-3
SPDX-License-Identifier: GPL-3.0-only

References:
1. https://github.com/Debian/ratt
'''
import sys
import os
import json
import argparse
import debian
import rich
console = rich.get_console()


class ControlFile(object):
    def __init__(self, path: str):
        pass

if __name__ == '__main__':
    ag = argparse.ArgumentParser()
    ag.add_argument('-c', '--control', type=str, required=True,
                    help='path to the reverse build control file')
    ag.add_argument('-w', '--workdir', type=str, default='/tmp',
                    help='path to the temporary work directory')
    ag.add_argument('-a', '--auto', action='store_true',
                    help='automatically execute pipeline')
    ag.add_argument('-s', '--schedule', action='store_true',
                    help='schedule reverse build tasks in control file')
    ag.add_argument('-b', '--build', action='store_true',
                    help='trigger retry for unfinished builds')
    ag.add_argument('-r', '--rebuild', action='store_true',
                    help='trigger retry for failed/unfinished builds')
    ag.add_argument('-p', '--print', action='store_true',
                    help='pretty print control file')
    ag.add_argument('builder_args', nargs=argparse.REMAINDER)
    ag = ag.parse_args()
    console.print(ag)
