if vim.g.neovide then
    local rikka = require("rikka")
    local ts = require("telescope.builtin")
    local defaultOptions = { noremap = true, silent = true }

    vim.opt.guifont = "FiraCode Nerd Font:h13"
    vim.g.neovide_hide_mouse_when_typing = true

    vim.g.neovide_input_macos_alt_is_meta = true
    vim.g.neovide_cursor_vfx_mode = "railgun"
    -- fix CMD+C and CMD + V
    vim.g.neovide_input_use_logo = 1
    vim.keymap.set("n", "<D-s>", ":w<CR>")      -- Save
    vim.keymap.set("v", "<D-c>", '"+y')         -- Copy
    vim.keymap.set("n", "<D-v>", '"+P')         -- Paste normal mode
    vim.keymap.set("v", "<D-v>", '"+P')         -- Paste visual mode
    vim.keymap.set("c", "<D-v>", "<C-R>+")      -- Paste command mode
    vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

    -- Allow clipboard copy paste in neovim
    vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })


    -- tmp solution for no opt
    rikka.setKeymap("n", "<D-e>", ts.find_files, defaultOptions)
    rikka.setKeymap("n", "<D-p>", ts.builtin, defaultOptions)
    rikka.setKeymap("n", "<D-`>", ts.lsp_document_symbols, defaultOptions)
end
