#!/usr/bin/env python3

import os
import sys

import subprocess as sp

INSTALL_FAIL = 1
POSTINSTALL_FAIL = 2

dotdir = os.path.dirname(os.path.realpath(__file__))
home = os.environ["HOME"]


class Dotfile:
    def __init__(self, src, dest, postinstall=[], dir=False):
        self.src = src
        self.dest = dest
        self.postinstall = postinstall
        self.dir = dir

        self.name = os.path.basename(self.src)


def default_firefox_profile():
    ff = home + "/.mozilla/firefox"
    default_profile_it = (x for x in os.listdir(ff) if x.endswith("default"))
    default_profile = next(default_profile_it, None)
    return os.path.join(ff, default_profile)


def request_overwrite(dotfile):
    # Couldn't create a symlink. Ask a user for permission to nuke the
    # existing dotfile, and then create the symlink.
    perm = input("Could not install {} because {} already exists.\n"
                 "Overwrite existing file? [Y/n] "
                 .format(dotfile.name, dotfile.dest))
    if perm in ["", "y", "Y", "yes"]:
        try:
            os.remove(dotfile.dest)
        except OSError:
            # os.remove raises OSError when path is a directory.
            # TODO empty and remove directory
            sys.stderr.write("{} is a directory. Please remove it manually.\n"
                             .format(dotfile.dest))
            return False

        os.symlink(dotfile.src, dotfile.dest)
        return True
    return False


def main():
    installs = [
        Dotfile(dotdir + "/.vimrc",        home + "/.vimrc", postinstall=[
            "curl -fLo {}/.vim/autoload/plug.vim --create-dirs "
            "https://raw.githubusercontent.com/junegunn/vim-plug/master"
            "/plug.vim".format(home),
            "vim +PlugInstall +qall"
        ]),
        Dotfile(dotdir + "/i3",            home + "/.config/i3", dir=True),
        Dotfile(dotdir + "/i3blocks",      home + "/.config/i3blocks", dir=True),
        Dotfile(dotdir + "/ftplugin",      home + "/.vim/ftplugin", dir=True),
        Dotfile(dotdir + "/xkb",           home + "/.config/xkb", dir=True),
        Dotfile(dotdir + "/.abcde.conf",   home + "/.abcde.conf"),
        Dotfile(dotdir + "/.bash_aliases", home + "/.bash_aliases"),
        Dotfile(dotdir + "/.bashrc",       home + "/.bashrc"),
        Dotfile(dotdir + "/.gitconfig",    home + "/.gitconfig"),
        Dotfile(dotdir + "/.xsession",     home + "/.xsession"),
        Dotfile(dotdir + "/beets.yaml",    home + "/.config/beets/config.yaml"),
        Dotfile(dotdir + "/userContent.css",
                default_firefox_profile() + "/chrome/userContent.css")
    ]

    code = 0
    for dotfile in installs:
        src = dotfile.src
        dest = dotfile.dest

        try:
            os.symlink(src, dest, target_is_directory=dotfile.dir)
        except FileExistsError:
            if not (os.path.islink(dest) and os.readlink(dest) == src):
                # we have not already set up this symlink
                try:
                    success = request_overwrite(dotfile)
                except:
                    sys.stderr.write("Failed to install {}\n"
                                     .format(dotfile.name))
                    code |= INSTALL_FAIL
                else:
                    if not success:
                        code |= INSTALL_FAIL
        except FileNotFoundError:
            os.makedirs(os.path.dirname(dest))
            os.symlink(src, dest, target_is_directory=dotfile.dir)
        else:
            for cmd in dotfile.postinstall:
                try:
                    sp.run(cmd.split(' '), check=True)
                except sp.CalledProcessError as cpe:
                    sys.stderr.write("Postinstall steps for {} failed: {}\n"
                                     .format(src, cpe))
                    code |= POSTINSTALL_FAIL
                    break

    return code


if __name__ == "__main__":
    code = main()
    sys.exit(code)
