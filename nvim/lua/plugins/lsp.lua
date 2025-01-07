return {
	{
		"neovim/nvim-lspconfig",
		init = function()
			local lspconfig = require("lspconfig")
			lspconfig.pyright.setup({})
			lspconfig.jdtls.setup({})
			lspconfig.sourcekit.setup({
                capabilities = {
                    workspace = {
                        didChangeWatchedFiles = {
                            dynamicRegistration = true,
                        },
                    },
                },
            })
			lspconfig.vtsls.setup({})
		end,
	},
	{

		"MunifTanjim/prettier.nvim",
        dependencies = {
            "jose-elias-alvarez/null-ls.nvim",
            "nvim-lua/plenary.nvim",
        },
		init = function()
            local null_ls = require("null-ls")
            local prettier = require("prettier")
            local group = vim.api.nvim_create_augroup("lsp_format_on_save",
                {clear = false})
            local event = "BufWritePre"
            local async = event == "BufWritePost"

            null_ls.setup({
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.keymap.set("n", "<Leader>f", function()
                            vim.lsp.buf.format({
                                bufnr = vim.api.nvim_get_current_buf() })
                        end, {buffer = bufnr, desc = "[lsp] format"})

                        -- format on save
                        vim.api.nvim_clear_autocmds({
                            buffer = bufnr,
                            group = group
                        })
                        vim.api.nvim_create_autocmd(event, {
                            buffer = bufnr,
                            group = group,
                            callback = function()
                                vim.lsp.buf.format({
                                    bufnr = bufnr,
                                    async = async
                                })
                            end,
                            desc = "[lsp] format on save",
                        })
                    end

                    if client.supports_method(
                        "textDocument/rangeFormatting") then
                        vim.keymap.set("x", "<Leader>f", function()
                            vim.lsp.buf.format({
                                bufnr = vim.api.nvim_get_current_buf()
                            })
                        end, {buffer = bufnr, desc = "[lsp] format" })
                    end
                end,
            })
            prettier.setup({
                bin = 'prettierd',
                filetypes = {
                    "css",
                    "graphql",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "json",
                    "less",
                    "markdown",
                    "scss",
                    "typescript",
                    "typescriptreact",
                    "yaml",
                    "lua"
                },
                cli_options = {
                    tab_width = 4,
                    use_tabs = false,
                    print_width = 80,
                    end_of_line = "lf"
                }
            })
		end,
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = { preset = "default" },

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"williamboman/mason.nvim",
		dependencies = {"williamboman/mason-lspconfig.nvim",},
		init = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
		end,
	},
}
