vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.lua.txt",
    command = "set filetype=lua",
})
