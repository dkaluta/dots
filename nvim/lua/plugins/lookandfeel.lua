return {
	{ "lunacookies/vim-colors-xcode" },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                icons_enabled = true,
                theme = auto,
                always_show_tabline = true,
                section_separators = {
                    left = '\u{e0bc}',
                    right = '\u{e0ba}'
                },
                component_separators = {
                    left = '\u{e0bd}',
                    right = '\u{e0bb}'
                }
            }
        }
    },
}
