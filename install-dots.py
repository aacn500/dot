#!/usr/bin/env python3

import os
import sys

dotdir = os.path.dirname(os.path.realpath(__file__))
home = os.environ["HOME"]

installs = {
        dotdir + "/.vimrc": home + "/.vimrc",
        dotdir + "/.gitconfig": home + "/.gitconfig",
        dotdir + "/.bashrc": home + "/.bashrc",
        dotdir + "/.bash_aliases": home + "/.bash_aliases"
}


def main():
    code = 0
    for key in installs:
        try:
            os.symlink(key, installs[key])
        except FileExistsError as e:
            sys.stderr.write(("{} could not be installed as {} already exists "
                             "on the file system.\n")
                             .format(key, installs[key]))
            code = 1
    return code

if __name__ == "__main__":
    code = main()
    if code > 0:
        sys.exit(code)
