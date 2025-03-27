return {
    cmd = { "gopls" },
    root_markers = { "go.mod", ".git" },
    single_file_support = true,
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
        gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
            hints = {
                assignVariableTypes = false,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
    init_options = {
        usePlaceholders = true,
    },
}
