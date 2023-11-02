if vim.g.neovide then
    local rikka = require("rikka")
    local ts = require("telescope.builtin")

    vim.opt.guifont = "FiraCode Nerd Font Mono:h14"
    vim.g.neovide_hide_mouse_when_typing = true

    vim.g.neovide_input_macos_alt_is_meta = true
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_animate_command_line = false

    local alpha = function()
        return string.format("%x", math.floor(255 * (vim.g.transparency or 0.8)))
    end

    vim.g.neovide_transparency = 0.0
    vim.g.transparency = 0.95
    vim.g.neovide_background_color = "#2E3440" .. alpha()

    -- fix CMD+C and CMD + V
    vim.g.neovide_input_use_logo = 1

    rikka.setKeymap("n", "<D-s>", ":w<CR>") -- Save
    rikka.setKeymap("v", "<D-c>", '"+y') -- Copy
    rikka.setKeymap("n", "<D-v>", '"+P') -- Paste normal mode
    rikka.setKeymap("v", "<D-v>", '"+P') -- Paste visual mode
    rikka.setKeymap("c", "<D-v>", "<C-R>+") -- Paste command mode
    rikka.setKeymap("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

    -- Allow clipboard copy paste in neovim
    rikka.setKeymap("", "<D-v>", "+p<CR>")
    rikka.setKeymap("!", "<D-v>", "<C-R>+")
    rikka.setKeymap("t", "<D-v>", "<C-R>+")
    rikka.setKeymap("v", "<D-v>", "<C-R>+")

    -- tmp solution for no opt
    rikka.setKeymap("n", "<D-e>", ts.find_files, { desc = "Telescope Find Files" })
    rikka.setKeymap("n", "<D-p>", ts.builtin, { desc = "Telescope Builtin" })
    rikka.setKeymap("n", "<D-`>", ts.lsp_document_symbols, { desc = "Telescope Document Symbols" })
    rikka.setKeymap("n", "<D-f>", ts.live_grep, { desc = "Telescope Live Grep" })
end
