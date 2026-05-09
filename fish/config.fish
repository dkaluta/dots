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
