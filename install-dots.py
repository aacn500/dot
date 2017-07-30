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
    for key in installs:
        try:
            os.symlink(key, installs[key])
        except TypeError as te:
            # installs[key] is not a string. Assume dict.
            try:
                os.symlink(key, installs[key]["to"])
            except FileExistsError as fee:
                # TODO prompt user whether to overwrite
                report_file_exists_err(key, installs[key]["to"])
                code |= 1
                continue

            for cmd in installs[key]["postinstall"]:
                try:
                    sp.run(cmd.split(' '), check=True)
                except CalledProcessError as cpe:
                    sys.stderr.write("Postinstall steps for {} failed: {}"
                                     .format(key, cpe))
                    code |= 2
                    break

            continue

        except FileExistsError as fee:
            # TODO prompt user whether to overwrite
            report_file_exists_err(key, installs[key])
            code |= 1
            continue

    return code


if __name__ == "__main__":
    code = main()
    if code > 0:
        sys.exit(code)
