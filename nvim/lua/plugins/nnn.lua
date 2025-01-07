return {
    {
        "luukvbaal/nnn.nvim",
        opts = {
            vim.cmd("nnoremap <C-A-o> <cmd>NnnExplorer %:p:h<CR>")
        },
    },
}
