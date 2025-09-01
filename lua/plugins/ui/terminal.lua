return {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
        local rikka = require("rikka")

        require("toggleterm").setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.3
                end
            end,
            shade_terminals = false,
        })

        local Terminal = require("toggleterm.terminal").Terminal

        local normalTerminal = Terminal:new({
            cmd = vim.o.shell,
            dir = vim.fn.expand("%:p:h"),
            direction = "float",
            on_open = function(term)
                vim.cmd("startinsert!")
                rikka.setBufKeymap(0, "t", "<ESC>", [[<C-\><C-n>]], { desc = "Enter Normal Mode" })
                rikka.setBufKeymap(term.bufnr, "t", "<C-`>", "<cmd>close<CR>", { desc = "Close Terminal" })
            end,
        })
        rikka.setKeymap("n", "<C-`>", function()
            normalTerminal:toggle()
        end, { desc = "Toggle Terminal" })

        -- local aider = Terminal:new({
        --     cmd = "aider",
        --     hidden = true,
        --     env = {
        --         DISPLAY = ":0",
        --         AZURE_API_KEY = "123456",
        --         AZURE_API_VERSION = "2024-12-01-preview",
        --         AZURE_API_BASE = "https://closeai.zwlin.io",
        --         AIDER_MODEL = "azure/gpt-4.1",
        --         AIDER_WEAK_MODEL = "azure/gpt-4.1",
        --         AIDER_DARK_MODE = "true",
        --         AIDER_CODE_THEME = "nord",
        --         -- AIDER_MULTILINE = "true",
        --         AIDER_USER_INPUT_COLOR = rikka.color.blue,
        --         AIDER_TOOL_OUTPUT_COLOR = rikka.color.violet,
        --         AIDER_TOOL_ERROR_COLOR = rikka.color.red,
        --         AIDER_TOOL_WARNING_COLOR = rikka.color.orange,
        --         AIDER_ASSISTANT_OUTPUT_COLOR = rikka.color.lightWhite,
        --         AIDER_COMPLETION_MENU_COLOR = rikka.color.grayWhite,
        --         AIDER_COMPLETION_MENU_BG_COLOR = rikka.color.lightGray,
        --         AIDER_COMPLETION_MENU_CURRENT_COLOR = rikka.color.black,
        --         AIDER_COMPLETION_MENU_CURRENT_BG_COLOR = rikka.color.noVisualGray,
        --     },
        --     direction = "vertical",
        --     on_open = function(term)
        --         rikka.setBufKeymap(0, "t", "<ESC>", [[<C-\><C-n>]], { desc = "Enter Normal Mode" })
        --         rikka.setBufKeymap(0, "t", "<C-d>", "<cmd>close<CR>", { desc = "Close Terminal" })
        --     end,
        -- })
        --
        -- rikka.setKeymap("n", "<leader>a", function()
        --     aider:toggle()
        -- end, { desc = "Toggle Terminal" })
    end,
}
