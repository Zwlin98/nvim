local rikka = require("rikka")
local api = vim.api

local function showFloat(title, text)
    if not Snacks then
        rikka.error("Snacks not found")
        return
    end

    ---@class snacks.win.Config: vim.api.keyset.win_config
    local windowConfig = {
        show = false,
        fixbuf = true,
        text = text,
        style = "float",
        border = "rounded",
        relative = "cursor",
        row = 1,
        width = 0.35,
        height = 0.4,
        backdrop = false,
        enter = true,
        wo = {
            wrap = true,
        },
        keys = {
            q = "close",
        }, -- 按 q 关闭
    }

    local win = Snacks.win(windowConfig)
    win:set_title(title)
    win:show()

    return win
end

local function magicHover(content, sysPrompt, title)
    if not content or content == "" then
        return
    end

    if not sysPrompt or sysPrompt == "" then
        return
    end

    if not title then
        title = "Magic Hover"
    end

    local win = showFloat(title, "Thinking...")

    if not win then
        return
    end

    local lines = { "" }

    local Job = require("plenary.job")

    Job:new({
        command = "curl",
        args = {
            "-sS",
            "-N", -- 必需，按 chunk 输出结果
            "-H",
            "Content-Type: application/json",
            "-H",
            "Authorization: Bearer 123456",
            "-d",
            vim.fn.json_encode({
                model = "gpt-4.1",
                stream = true,
                messages = {
                    { role = "system", content = sysPrompt },
                    { role = "user", content = content },
                },
            }),
            "https://closeai.zwlin.io",
        },
        on_stdout = function(_, line)
            if line and line:match("^data:") then
                vim.schedule(function()
                    if not win:win_valid() then
                        return
                    end
                    local data = line:match("^data:%s*(.*)$")
                    if data ~= "[DONE]" and #data > 0 then
                        local ok, chunk = pcall(vim.json.decode, data)
                        if ok and chunk and chunk.choices and chunk.choices[1] then
                            local delta = chunk.choices[1].delta.content or ""

                            local start = 1
                            while true do
                                local s, e = string.find(delta, "\n", start, true)
                                if s then
                                    -- 这一段到换行结束，要分新行
                                    local piece = delta:sub(start, s - 1)
                                    lines[#lines] = (lines[#lines] or "") .. piece
                                    table.insert(lines, "") -- 新起一行
                                    start = e + 1
                                else
                                    -- 没有更多\n，把剩下的追加到最后一行即可
                                    local piece = delta:sub(start)
                                    lines[#lines] = (lines[#lines] or "") .. piece
                                    break
                                end
                            end

                            -- 每次新文本到达都刷新浮窗内容
                            api.nvim_buf_set_lines(win.buf, 0, -1, false, lines)
                            api.nvim_win_set_cursor(win.win, { #lines, 0 })
                        end
                    end
                end)
            end
        end,
        on_exit = function()
            vim.schedule(function()
                api.nvim_set_option_value("filetype", "markdown", { buf = win.buf })
            end)
        end,
    }):start()
end

local quickExplain = function(content)
    local sysPrompt = "你是一个编程专家，用户会给你一些文本(代码段/单词等)，你需要根据情况解释文本的的含义概念用法等，并按照 markdown 格式输出"
    content = content or rikka.getCurrentWord()
    magicHover(content, sysPrompt, "Quick Explain")
end

rikka.setKeymap("n", "<leader>s", quickExplain, { desc = "Explain" })
rikka.setKeymap("v", "<leader>s", function()
    local content = rikka.getVisualSelection()
    quickExplain(content)
end, { desc = "Explaining Visual Selection" })

rikka.setKeymap("v", "<leader>r", function()
    local sysPrompt = "你是一个编程专家，用户会给你部分代码段，你需要Review这部分代码，主要关注潜在的语法/拼写/逻辑错误等，并按照 markdown 格式输出你的建议"
    local content = rikka.getVisualSelection()
    magicHover(content, sysPrompt, "Quick Review")
end, { desc = "Review Visual Selection" })
