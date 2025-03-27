vim.lsp.config("*", {
    root_markers = { ".git" },
})

local languages = {
    "lua",
    "go",
}

for _, language in ipairs(languages) do
    vim.lsp.enable(language)
end
