return {
    {
        "loctvl842/monokai-pro.nvim", lazy = false, priority = 1000,
        config = function() require("monokai-pro").setup() end,
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = false, theme = "auto",
                section_separators = "", component_separators = "|",
            },
            sections = {
                lualine_a = { "mode" }, lualine_b = { "branch", "diff",
                    { "diagnostics", symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" } } },
                lualine_c = { { "filename", symbols = { modified = "[+]", readonly = "[RO]", unnamed = "[No Name]", newfile = "[New]" } } },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" }, lualine_z = { "location" },
            },
        },
    },
}
