local rikka = require("rikka")

rikka.createCommand("GetFilePath", function()
    local path = vim.fn.expand("%:~:.")
    vim.fn.setreg("+", path)
    rikka.info("File path [" .. path .. "] copied to clipboard")
end, { desc = "Get File Path" })

rikka.createCommand("GetDiagnostic", function()
    local line = vim.fn.line(".") - 1
    local diagnostics = vim.diagnostic.get(0, { lnum = line })
    if #diagnostics > 0 then
        local text = table.concat(
            vim.tbl_map(function(d)
                return d.message
            end, diagnostics),
            " "
        )
        vim.fn.setreg("+", text)
        rikka.info("Diagnostic copied to clipboard")
    else
        rikka.warn("No diagnostics on current line")
    end
end, { desc = "Copy diagnostics to clipboard" })
