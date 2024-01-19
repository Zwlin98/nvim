return {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
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
                filter = "<C-q>",
                pscrollup = "<C-u>",
                pscrolldown = "<C-d>",
            },
        }

        require("bqf").setup(opts)
    end,
}
