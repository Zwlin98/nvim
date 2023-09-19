local rikka = require("rikka")

local defaultOptions = { noremap = true, silent = true }

rikka.setKeymap("v", "<", "<gv", defaultOptions)
rikka.setKeymap("v", ">", ">gv", defaultOptions)

rikka.setKeymap("n", "<M-h>", ":nohlsearch<CR>", defaultOptions)
rikka.setKeymap("v", "<M-h>", ":nohlsearch<CR>", defaultOptions)

rikka.setKeymap('n', '[q', vim.diagnostic.goto_prev)
rikka.setKeymap('n', ']q', vim.diagnostic.goto_next)

rikka.setKeymap("n", "<M-c>", ":close<CR>", defaultOptions)

rikka.setKeymap("n", "<space>e", ":Neotree toggle<CR>", defaultOptions)

local ts = require("telescope")
local tsbuiltin = require("telescope.builtin")

rikka.setKeymap("n", "<M-p>", tsbuiltin.builtin, defaultOptions)
rikka.setKeymap("n", "<M-`>", tsbuiltin.lsp_document_symbols, defaultOptions)

-- fuzzy finding
rikka.setKeymap("n", "<M-s>", tsbuiltin.current_buffer_fuzzy_find, defaultOptions)
rikka.setKeymap("v", "<M-s>", function() tsbuiltin.current_buffer_fuzzy_find({ default_text = rikka.getVisualSelection() }) end, defaultOptions)
-- grep
local lga = require("telescope-live-grep-args.shortcuts")

rikka.setKeymap("n", "<M-g>", lga.grep_word_under_cursor, defaultOptions)
rikka.setKeymap("v", "<M-g>", lga.grep_visual_selection, defaultOptions)

rikka.setKeymap("n", "<M-f>", ts.extensions.live_grep_args.live_grep_args, defaultOptions)

-- file search (explorer)
rikka.setKeymap("n", "<M-e>", tsbuiltin.find_files, defaultOptions)
-- buffers (recent)
rikka.setKeymap("n", "<M-r>", tsbuiltin.buffers, defaultOptions)
-- jumplist (z as jump)
rikka.setKeymap("n", "<M-z>", tsbuiltin.jumplist, defaultOptions)
rikka.setKeymap({ "n", "i" }, "<M-y>", ts.extensions.yank_history.yank_history, defaultOptions)

local trouble = require("trouble")
rikka.setKeymap("n", "gq", function() trouble.open("document_diagnostics") end, defaultOptions)
rikka.setKeymap("n", "gR", function() trouble.open("lsp_references") end)

-- outline
rikka.setKeymap("n", "<M-o>", ":AerialToggle<CR>", defaultOptions)
