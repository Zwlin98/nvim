local Server = {}

function Server.checkOK()
    return true
end

---@diagnostic disable-next-line: unused-local
function Server.setup(opts)
    local rt = require("rust-tools")

    rt.setup({
        server = {
            on_attach = function(_, bufnr)
                -- Hover actions
                vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
                -- Code action groups
                vim.keymap.set("n", "ga", rt.code_action_group.code_action_group, { buffer = bufnr })
            end,
        },
    })
end

return Server
