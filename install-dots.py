#!/usr/bin/env python3

import os
import sys

import subprocess as sp

dotdir = os.path.dirname(os.path.realpath(__file__))
home = os.environ["HOME"]


class Dotfile:
    def __init__(self, src, dest, postinstall=[], dir=False):
        self.src = src
        self.dest = dest
        self.postinstall = postinstall
        self.dir = dir


installs = [
    Dotfile(dotdir + "/.vimrc",        home + "/.vimrc", postinstall=[
        "curl -fLo {}/.vim/autoload/plug.vim --create-dirs "
        "https://raw.githubusercontent.com/junegunn/vim-plug/master"
        "/plug.vim".format(home),
        "vim +PlugInstall +qall"
    ]),
    Dotfile(dotdir + "/ftplugin",      home + "/.vim/ftplugin", dir=True),
    Dotfile(dotdir + "/.gitconfig",    home + "/.gitconfig"),
    Dotfile(dotdir + "/.bashrc",       home + "/.bashrc"),
    Dotfile(dotdir + "/.bash_aliases", home + "/.bash_aliases"),
    Dotfile(dotdir + "/.abcde.conf",   home + "/.abcde.conf")
]


def report_file_exists_err(dotfile):
    sys.stderr.write("{} could not be installed as {} already exists "
                     "on the file system.\n"
                     .format(dotfile.src, dotfile.dest))


def main():
    code = 0
    for dotfile in installs:
        src = dotfile.src
        dest = dotfile.dest

        try:
            os.symlink(src, dest, target_is_directory=dotfile.dir)
        except FileExistsError:
            # TODO prompt user whether to overwrite
            if not (os.path.islink(dest) and os.readlink(dest) == src):
                # we have not already set up this symlink
                report_file_exists_err(dotfile)
                code |= 1
            continue

        for cmd in dotfile.postinstall:
            try:
                sp.run(cmd.split(' '), check=True)
            except sp.CalledProcessError as cpe:
                sys.stderr.write("Postinstall steps for {} failed: {}\n"
                                 .format(src, cpe))
                code |= 2
                break

    return code


if __name__ == "__main__":
    code = main()
    sys.exit(code)
