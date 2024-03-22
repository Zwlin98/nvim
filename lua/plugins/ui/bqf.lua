return {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
    dependencies = {
        {
            "junegunn/fzf",
            build = function()
                vim.fn["fzf#install"]()
            end,
        },
    },
    config = function()
        local rikka = require("rikka")
        local trouble = require("trouble")
        local opts = {
            auto_resize_height = true,
            preview = {
                border = rikka.border,
                should_preview_cb = function(bufnr, qwinid)
                    local ret = true
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    local fsize = vim.fn.getfsize(bufname)
                    if fsize > 100 * 1024 then
                        -- skip file size greater than 100k
                        ret = false
                    elseif bufname:match("^fugitive://") then
                        -- skip fugitive buffer
                        ret = false
                    end
                    return ret
                end,
            },
            -- make `drop` and `tab drop` to become preferred
            func_map = {
                fzffilter = "?",
                pscrollup = "<C-u>",
                pscrolldown = "<C-d>",
            },
        }

        local function quickfixToggle()
            local found = false
            for _, winid in ipairs(vim.api.nvim_list_wins()) do
                local bufnr = vim.api.nvim_win_get_buf(winid)
                local filetype = vim.bo[bufnr].filetype
                if filetype == "qf" then
                    vim.api.nvim_win_close(winid, true)
                    found = true
                    break
                end
            end
            if trouble.is_open() then
                trouble.close()
                found = true
            end
            if not found then
                vim.cmd("copen")
            end
        end

        rikka.setKeymap("n", "<C-q>", quickfixToggle, { desc = "Quickfix Toggle" })

        require("bqf").setup(opts)
    end,
}
