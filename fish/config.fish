if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr -a vim nvim
    abbr -a sshaqua "ssh -CXJ dkaluta@bava.cs.huji.ac.il dkaluta@river"
    abbr -a portup "sudo port selfupdate && sudo port upgrade outdated"
    set python_version (port select --show python)

    source "$HOME/.cargo/env.fish"
end

# Added by Antigravity
fish_add_path /Users/dk/.antigravity/antigravity/bin

# Automatic tmux for interactive terminals. TMUX_AUTO_START=0 opts out.
if status is-interactive; and not set -q TMUX; and test -t 0; and test "$TMUX_AUTO_START" != 0; and type -q tmux
    tmux new-session -A -s main
end
