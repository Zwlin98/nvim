local rikka = require("rikka")

rikka.createCommand("GetFilePath", function()
    local path = vim.fn.expand("%:~:.")
    vim.fn.setreg("+", path)
    rikka.info("File path [" .. path .. "] copied to clipboard", "Get FilePath")
end, { desc = "Copy file path to clipboard" })

local function getCodeRangeRef(opts)
    local path = vim.fn.expand("%:p")
    if path == "" then
        rikka.warn("No file path for current buffer", "Get Codex Range")
        return nil
    end

    local startLine = math.min(opts.line1, opts.line2)
    local endLine = math.max(opts.line1, opts.line2)
    local range = tostring(startLine)
    if startLine ~= endLine then
        range = range .. "-" .. endLine
    end

    return path .. ":" .. range, startLine, endLine
end

rikka.createCommand("GetCodeRange", function(opts)
    local ref = getCodeRangeRef(opts)
    if not ref then
        return
    end

    vim.fn.setreg("+", ref)

    rikka.info("Code range [" .. ref .. "] copied to clipboard", "Get Codex Range")
end, { desc = "Copy file range for LLM Agent", range = true })

rikka.createCommand("GetCodeRangeWithContent", function(opts)
    local ref, startLine, endLine = getCodeRangeRef(opts)
    if not ref then
        return
    end

    local lines = vim.api.nvim_buf_get_lines(0, startLine - 1, endLine, false)
    local text = ref .. "\n" .. table.concat(lines, "\n")

    vim.fn.setreg("+", text)

    rikka.info("Code range and content copied to clipboard", "Get Codex Range")
end, { desc = "Copy file range and content for LLM Agent", range = true })

rikka.createCommand("GetDiagnostic", function()
    local text = rikka.getDiagnosticText()
    if text then
        vim.fn.setreg("+", text)
        rikka.info("Diagnostic copied to clipboard", "Get Diagnostic")
    else
        rikka.warn("No diagnostics on current line", "Get Diagnostic")
    end
end, { desc = "Copy diagnostics to clipboard" })

local externalOpeners = {
    md = { "limn" },
}

rikka.createCommand("PreviewExternally", function()
    local path = vim.fn.expand("%:p")
    if path == "" then
        rikka.warn("No file path for current buffer", "Open Externally")
        return
    end

    local ext = vim.fn.expand("%:e")
    local opener = externalOpeners[ext]
    if not opener then
        rikka.warn("No external opener configured for .%s files", ext)
        return
    end

    local executable = opener[1]
    if vim.fn.executable(executable) ~= 1 then
        rikka.warn("%s executable not found", executable)
        return
    end

    local cmd = vim.list_extend(vim.deepcopy(opener), { path })
    local job = vim.fn.jobstart(cmd)
    if job <= 0 then
        rikka.error("Failed to open %s externally", path)
        return
    end
end, { desc = "Open current file with an external app" })
