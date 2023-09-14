vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*/.ssh/*/config" },
    command = "set filetype=sshconfig",
})
