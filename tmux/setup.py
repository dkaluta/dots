#!/usr/bin/env python3
"""Wire this checkout into the current home, preserving previous files."""
from pathlib import Path
import datetime
import os
import socket
import sys

home = Path.home().resolve()
repo = Path(__file__).resolve().parent.parent
if not repo.is_relative_to(home):
    raise SystemExit("The checkout must be inside your home directory")

def home_path(relative):
    path = home / relative
    if not path.resolve().is_relative_to(home):
        raise SystemExit("Path resolves outside home: " + str(path))
    return path

for relative in (".cache/tmux", ".cache/zsh", ".cache/ssh-tuning/tmp",
                 ".vim/tmp", ".vim/undo", ".vim/swap", ".vim/backup"):
    path = home_path(relative)
    path.mkdir(parents=True, mode=0o700, exist_ok=True)
    path.chmod(0o700)
if sys.platform.startswith("linux"):
    path = home_path(".cache/tmux/" + socket.gethostname().split(".")[0])
    path.mkdir(mode=0o700, exist_ok=True)
    path.chmod(0o700)

backup = home_path(".cache/dotfiles-backups/" + datetime.datetime.now().strftime("%Y%m%d-%H%M%S"))
for name, relative in ((".tmux.conf", "tmux/tmux.conf"),
                       (".config/tmux/tmux.conf", "tmux/tmux.conf"),
                       (".vimrc", "vim/vimrc"),
                       (".zshrc.custom", "zsh/zshrc")):
    target = repo / relative
    if not target.is_file():
        raise SystemExit("Missing configuration: " + str(target))
    link = home / name
    if not link.parent.resolve().is_relative_to(home):
        raise SystemExit("Link parent resolves outside home: " + str(link))
    link.parent.mkdir(parents=True, exist_ok=True)
    if link.resolve() == target.resolve():
        continue
    if link.exists() or link.is_symlink():
        backup.mkdir(parents=True, mode=0o700, exist_ok=True)
        (backup / name).parent.mkdir(parents=True, mode=0o700, exist_ok=True)
        os.replace(link, backup / name)
    link.symlink_to(os.path.relpath(target, link.parent))
    print("Linked", name, "to", target)
print("Terminal links and private state directories are ready.")
