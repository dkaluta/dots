if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr -a vim nvim
    abbr -a sshaqua "ssh -CXJ dkaluta@bava.cs.huji.ac.il dkaluta@river"
    source "$HOME/.cargo/env.fish"
end
