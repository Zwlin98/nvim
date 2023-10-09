if vim.g.neovide then
    local rikka = require("rikka")
    local ts = require("telescope.builtin")

    vim.opt.guifont = "FiraCode Nerd Font Mono:h13"
    vim.g.neovide_hide_mouse_when_typing = true

    vim.g.neovide_input_macos_alt_is_meta = true
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_cursor_animate_in_insert_mode = false

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
