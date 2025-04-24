local uv = vim.loop
local rikka = require("rikka")

local defaultConfig = {
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

local function find_root(markers)
    local path = vim.api.nvim_buf_get_name(0)
    local found = vim.fs.find(markers, { upward = true, path = path })[1]
    if found then
        return vim.fs.dirname(found)
    else
        return uv.cwd()
    end
end

local function loadProjectConfig()
    local root = find_root(defaultConfig.root_markers)
    local config_path = root .. "/.gopls.lua"
    local stat = uv.fs_stat(config_path)
    if stat and stat.type == "file" then
        local ok, project_gopls = pcall(dofile, config_path)
        if ok and type(project_gopls) == "table" then
            defaultConfig.settings.gopls = vim.tbl_deep_extend("force", defaultConfig.settings.gopls, project_gopls)
            rikka.info("Loaded gopls config from " .. config_path, "gopls")
        end
    end
    return defaultConfig
end

return loadProjectConfig()
