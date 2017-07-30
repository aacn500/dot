#!/usr/bin/env python3

import os
import sys

import subprocess as sp

dotdir = os.path.dirname(os.path.realpath(__file__))
home = os.environ["HOME"]


installs = {
    # dotdir + "/.vimrc": home + "/.vimrc",
    # TODO add post-install param, "vim +PlugInstall +qall"
    dotdir + "/.vimrc": {
        "to": home + "/.vimrc",
        "postinstall": [
            "curl -fLo {}/.vim/autoload/plug.vim --create-dirs "
            "https://raw.githubusercontent.com/junegunn/vim-plug/master"
            "/plug.vim".format(home),
            "vim +PlugInstall +qall"
        ]
    },
    dotdir + "/ftplugin": home + "/.vim/ftplugin",
    dotdir + "/.gitconfig": home + "/.gitconfig",
    dotdir + "/.bashrc": home + "/.bashrc",
    dotdir + "/.bash_aliases": home + "/.bash_aliases"
}


def report_file_exists_err(conf_file, dest):
    sys.stderr.write(("{} could not be installed as {} already exists "
                     "on the file system.\n")
                     .format(conf_file, dest))


def main():
    code = 0
    for src in installs:
        dest = installs[src]
        try:
            os.symlink(src, dest)
        except TypeError:
            # dest is not a string. Assume dict.
            try:
                os.symlink(src, dest["to"])
            except FileExistsError:
                # TODO prompt user whether to overwrite
                if not (os.path.islink(dest["to"]) and os.readlink(dest["to"]) == src):
                    # we have not already set up this symlink
                    report_file_exists_err(src, dest["to"])
                    code |= 1
                continue

            for cmd in dest["postinstall"]:
                try:
                    sp.run(cmd.split(' '), check=True)
                except CalledProcessError as cpe:
                    sys.stderr.write("Postinstall steps for {} failed: {}"
                                     .format(src, cpe))
                    code |= 2
                    break

            continue

        except FileExistsError:
            # TODO prompt user whether to overwrite
            if not (os.path.islink(dest) and os.readlink(dest) == src):
                # we have not already set up this symlink
                report_file_exists_err(src, dest)
                code |= 1
            continue

    return code


if __name__ == "__main__":
    code = main()
    if code > 0:
        sys.exit(code)
