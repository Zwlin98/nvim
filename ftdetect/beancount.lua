vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.bean", "*.beancount" },
    command = "set filetype=beancount",
})
