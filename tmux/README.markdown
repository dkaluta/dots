Terminal configuration
======================

The shared configuration supports the installed tmux 3.5a on Linux and 3.7c on macOS.
Both hosts have tmux-256color terminfo. The Mac uses MacPorts /opt/local/bin/tmux.

Native link: ~/.tmux.conf -> ~/.config/tmux/tmux.conf
SSH link: ~/.tmux.conf -> ~/.dots/tmux/tmux.conf
Keep an existing file backed up before changing a link.

Run tmux new-session -A -s main to create or reattach a persistent session.
There is no automatic attachment from shell startup. Sessions survive client disconnection.
Fish and Zsh keep sockets under ~/.cache/tmux; Linux adds a host-name directory.
On a cluster with a shared home, sessions belong to the host where they were started.
Use the host name in the status bar and reconnect to that same host to reattach.

The prefix is Ctrl-B. Follow it with | or - to split, c for a window, r to reload,
[ for copy mode, or d to detach. In copy mode, v begins a selection and y copies.
On macOS y also sends the selection to pbcopy. SSH clipboard delivery uses OSC52
and depends on the client's support. Ctrl-B b passes the prefix to a nested tmux.

Neovim uses modern vim.lsp.config/enable through Mason and nvim-lspconfig.
Lua, Python and TypeScript servers are ensured; other installed servers remain enabled.
StyLua is excluded from automatic LSP activation because the installed binary lacks --lsp.
System clangd is enabled when available. Use gd, gr, K, Space-rn, Space-ca and Space-f.
The maintained none-ls bridge retains Prettier formatting and format on save.
Status lines, completion kinds and shell prompts use plain text, without Powerline glyphs.

Automatic startup is enabled for native and SSH interactive terminals.
New terminals create or attach to main. Existing panes and scripted commands do not nest.
Set TMUX_AUTO_START=0 before launching a shell for an occasional plain terminal.

Install links and private state directories after cloning or pulling:

    python3 tmux/setup.py

The helper backs up replaced home files and leaves unrelated files alone.
