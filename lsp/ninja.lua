local uv = vim.loop
local rikka = require("rikka")

local function checkIsNinja(rootPath)
    if not rootPath or rootPath == "" or rootPath == vim.NIL then
        return false
    end
    local skynetDir = rootPath .. "/skynet"
    local stat = uv.fs_stat(skynetDir)
    if not stat then
        return false
    end
    return true
end

---@class DefinitionParams
---@field textDocument { uri: string }
---@field position { line: number, character: number }

---@param dispatchers vim.lsp.rpc.Dispatchers
---@param config vim.lsp.ClientConfig
---@return vim.lsp.rpc.PublicClient
local function ninjaLS(dispatchers, config)
    local closeing = false
    local messageId = 0
    local rootPath

    local definitionCache = {}

    local makeKey = function(pattern, fname)
        fname = fname or "WORKSPACE"
        return pattern .. "@" .. fname
    end

    local function cleanCache(uri)
        if not uri or uri == "" then
            return
        end
        local removed = {}
        for key, res in pairs(definitionCache) do
            for _, record in pairs(res) do
                if record.uri == uri then
                    table.insert(removed, key)
                    break
                end
            end
        end
        for _, key in pairs(removed) do
            definitionCache[key] = nil
        end
    end

    local function extractArgs()
        local node = vim.treesitter.get_node()

        while node do
            local type = node:type()
            if type:match("function_call") then
                break
            end
            node = node:parent()
        end

        if not node then
            return
        end

        local caller
        local args = {}

        for child in node:iter_children() do
            local typ = child:type()
            if typ == "identifier" or typ == "dot_index_expression" or typ == "method_index_expression" then
                local start_row, start_col, end_row, end_col = child:range()
                local text = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
                caller = table.concat(text, "")
            elseif child:type() == "arguments" then
                for arg in child:iter_children() do
                    local typ = arg:type()
                    if typ == "(" or typ == "," or typ == ")" then
                        --skip
                    else
                        local start_row, start_col, end_row, end_col = arg:range()
                        local text = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
                        table.insert(args, table.concat(text, ""))
                    end
                end
            end
        end

        return args, caller
    end

    local function search(pattern, fname)
        local key = makeKey(pattern, fname)
        if definitionCache[key] then
            return definitionCache[key]
        end
        local cmd = {
            "rg",
            "--json",
            pattern,
            fname,
        }

        local res = vim.system(cmd):wait()
        if res.code ~= 0 then
            return
        end
        local lines = vim.split(res.stdout, "\n")
        local result = {}
        for _, line in pairs(lines) do
            local ok, record = pcall(vim.json.decode, line)
            if ok and record.type == "match" then
                table.insert(result, {
                    uri = vim.uri_from_fname(record.data.path.text),
                    range = {
                        start = {
                            line = record.data.line_number - 1,
                            character = record.data.submatches[1].start,
                        },
                        ["end"] = {
                            line = record.data.line_number - 1,
                            character = record.data.submatches[1]["end"],
                        },
                    },
                })
            end
        end
        definitionCache[key] = result
        return result
    end

    local function searchFunction(funcName, fname)
        local pattern = string.format("function.*%s\\(", funcName)
        return search(pattern, fname)
    end

    local function removeQuote(s)
        if s:sub(1, 1) == '"' and s:sub(-1) == '"' then
            return s:sub(2, -2)
        end
        if s:sub(1, 1) == "'" and s:sub(-1) == "'" then
            return s:sub(2, -2)
        end
        return s
    end

    local jumpMethods = {
        moduleCall = function(caller, args)
            local file = removeQuote(args[1])
            local func = removeQuote(args[2])

            local fname = string.format("%s/node/%s.lua", rootPath, file)

            return searchFunction(func, fname)
        end,
        dcCall = function(caller, args)
            local file = removeQuote(args[1])
            local func = removeQuote(args[2])

            local fname = string.format("%s/lualib/datacenter/%s.lua", rootPath, file)
            return searchFunction(func, fname)
        end,
        [{ "cross_call_other_agent", "call_other_agent" }] = function(caller, args)
            local func = removeQuote(args[1])
            local fname = string.format("%s/node/agentonlinecmd.lua", rootPath)
            return searchFunction(func, fname)
        end,
        [{ "send_online_agent", "call_online_agent" }] = function(caller, args)
            local func = removeQuote(args[3])
            local fname = string.format("%s/node/agentonlinecmd.lua", rootPath)
            return searchFunction(func, fname)
        end,
        [{ "callMatchCache", "sendMatchCache" }] = function(caller, args)
            local func = removeQuote(args[1])
            local fname = rootPath .. "/match/matchCache.lua"

            return searchFunction(func, fname)
        end,
        [{ "callMatchMgr", "sendMatchMgr" }] = function(caller, args)
            local func = removeQuote(args[1])
            local fname = rootPath .. "/match/matchMgr.lua"

            return searchFunction(func, fname)
        end,
        [{ "callMatchRound", "sendMatchRound" }] = function(caller, args)
            local func = removeQuote(args[2])
            local fname = rootPath .. "/match/matchRound.lua"

            return searchFunction(func, fname)
        end,
        [{ "callMatchScore", "sendMatchScore" }] = function(caller, args)
            local func = removeQuote(args[2])
            local fname = rootPath .. "/match/matchScore.lua"

            return searchFunction(func, fname)
        end,
        [{ "callMatchTeamNode", "sendMatchTeamNode" }] = function(caller, args)
            local func = removeQuote(args[1])
            local fname = rootPath .. "/match/matchTeamNode.lua"
            return searchFunction(func, fname)
        end,
    }

    local function getdefinitions()
        local args, caller = extractArgs()
        if not args or #args == 0 then
            return
        end

        if not caller or caller == "" then
            return
        end

        for keyword, jump in pairs(jumpMethods) do
            if type(keyword) == "table" then
                for _, k in pairs(keyword) do
                    if string.find(caller, k) then
                        return jump(caller, args)
                    end
                end
            elseif type(keyword) == "string" then
                if string.find(caller, keyword) then
                    return jump(caller, args)
                end
            end
        end
    end

    ---@type vim.lsp.rpc.PublicClient
    local server = {
        request = function(method, params, callback, notify_reply_callback)
            if method == "initialize" then
                if checkIsNinja(params.rootPath) then
                    rootPath = params.rootPath
                    callback(nil, {
                        serverInfo = {
                            name = "Ninja LS",
                            version = "1.0.0",
                        },
                        capabilities = {
                            definitionProvider = true,
                            textDocumentSync = {
                                openClose = true,
                                change = 2, -- TextDocumentSyncKind.Full
                                save = true,
                            },
                        },
                    })
                else
                    callback(nil, {
                        serverInfo = {
                            name = "Ninja LS",
                            version = "0.0.0",
                        },
                        capabilities = {},
                    })
                end
            end
            if method == "textDocument/definition" then
                ---@cast params DefinitionParams
                vim.schedule(function()
                    callback(nil, getdefinitions())
                end)
            end
            messageId = messageId + 1
            return true, messageId
        end,
        notify = function(method, params)
            if method == "textDocument/didChange" then
                cleanCache(params.textDocument.uri)
                return true
            elseif method == "textDocument/didOpen" then
                return true
            elseif method == "textDocument/didClose" then
                return true
            elseif method == "textDocument/didSave" then
                cleanCache(params.textDocument.uri)
                return true
            end
            return true
        end,
        is_closing = function()
            return closeing
        end,
        terminate = function()
            if closeing then
                return
            end
            closeing = true
        end,
    }
    return server
end

return {
    -- Command and arguments to start the server.
    cmd = ninjaLS,
    -- Filetypes to automatically attach to.
    filetypes = { "lua", "lua.txt" },
    -- Sets the "root directory" to the parent directory of the file in the
    -- current buffer that contains either a ".luarc.json" or a
    -- ".luarc.jsonc" file. Files that share a root directory will reuse
    -- the connection to the same LSP server.
    root_markers = { ".luarc.json", ".luarc.jsonc" },
}
