-- Keep LSP startup ordered: dependencies, capabilities, then server activation.
local function format(bufnr, async)
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local selected
    for _, client in ipairs(clients) do
        if client:supports_method("textDocument/formatting", bufnr) then
            selected = selected or client
            if client.name == "null-ls" then selected = client; break end
        end
    end
    if selected then
        vim.lsp.buf.format({ bufnr = bufnr, async = async,
            filter = function(client) return client.id == selected.id end })
    end
end

return {
    {
        "MunifTanjim/prettier.nvim",
        dependencies = { "nvimtools/none-ls.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true })
            require("null-ls").setup({
                on_attach = function(client, bufnr)
                    if client:supports_method("textDocument/formatting", bufnr) then
                        vim.keymap.set("n", "<Leader>f", function() format(bufnr, false) end,
                            { buffer = bufnr, desc = "Format buffer" })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr, group = group,
                            callback = function() format(bufnr, false) end,
                            desc = "Format on save",
                        })
                    end
                    if client:supports_method("textDocument/rangeFormatting", bufnr) then
                        vim.keymap.set("x", "<Leader>f", function()
                            vim.lsp.buf.format({ bufnr = bufnr,
                                filter = function(c) return c.id == client.id end })
                        end, { buffer = bufnr, desc = "Format selection" })
                    end
                end,
            })
            require("prettier").setup({
                bin = "prettierd",
                filetypes = { "css", "graphql", "html", "javascript", "javascriptreact",
                    "json", "less", "markdown", "scss", "typescript", "typescriptreact", "yaml", "lua" },
                cli_options = { tab_width = 4, use_tabs = false, print_width = 80, end_of_line = "lf" },
            })
        end,
    },
    {
        "saghen/blink.cmp",
        dependencies = "rafamadriz/friendly-snippets",
        version = "*",
        opts = {
            keymap = { preset = "default" },
            sources = { default = { "lsp", "path", "snippets", "buffer" } },
            completion = {
                menu = { draw = { columns = { { "label", "label_description", gap = 1 }, { "kind" } } } },
            },
        },
        opts_extend = { "sources.default" },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "saghen/blink.cmp" },
        config = function()
            require("mason").setup({ ui = { icons = {
                package_installed = "[x]", package_pending = "[-]", package_uninstalled = "[ ]",
            } } })
            vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
            vim.lsp.config("lua_ls", { settings = { Lua = {
                runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
            } } })
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "vtsls" },
                -- The installed StyLua supports formatting, but not --lsp.
                automatic_enable = { exclude = { "stylua" } },
            })
            if vim.fn.executable("clangd") == 1 then vim.lsp.enable("clangd") end
            local severity = vim.diagnostic.severity
            vim.diagnostic.config({
                virtual_text = { prefix = ">", spacing = 2 },
                signs = { text = { [severity.ERROR] = "E", [severity.WARN] = "W",
                    [severity.INFO] = "I", [severity.HINT] = "H" } },
            })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("dotfiles_lsp_keys", { clear = true }),
                callback = function(event)
                    local opts = { buffer = event.buf, silent = true }
                    local function map(key, fn, desc)
                        vim.keymap.set("n", key, fn, vim.tbl_extend("force", opts, { desc = desc }))
                    end
                    map("gd", vim.lsp.buf.definition, "LSP definition")
                    map("gr", vim.lsp.buf.references, "LSP references")
                    map("K", vim.lsp.buf.hover, "LSP hover")
                    map("<Leader>rn", vim.lsp.buf.rename, "LSP rename")
                    map("<Leader>ca", vim.lsp.buf.code_action, "LSP code action")
                    map("<Leader>f", function() format(event.buf, false) end, "Format buffer")
                end,
            })
        end,
    },
}
