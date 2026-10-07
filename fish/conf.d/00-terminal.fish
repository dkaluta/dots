# Shared terminal defaults: plain text prompts and home-only tmux sockets.
switch (uname -s)
    case Linux
        set -gx TMUX_TMPDIR "$HOME/.cache/tmux/"(hostname -s)
    case '*'
        set -gx TMUX_TMPDIR "$HOME/.cache/tmux"
end
if not test -d "$TMUX_TMPDIR"
    command mkdir -p "$TMUX_TMPDIR"
    command chmod 700 "$TMUX_TMPDIR"
end
set -g hydro_symbol_prompt '>'
set -g hydro_symbol_git_dirty '*'
set -g hydro_symbol_git_ahead '+'
set -g hydro_symbol_git_behind '-'
