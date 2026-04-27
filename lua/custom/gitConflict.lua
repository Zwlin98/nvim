-- Git conflict marker detection, highlighting, and resolution.
-- Ported from akinsho/git-conflict.nvim.

local api = vim.api
local rikka = require("rikka")
local bit = require("bit")

local NAMESPACE = api.nvim_create_namespace("git-conflict")
local AUGROUP = "GitConflict"
local PRIORITY = vim.highlight.priorities.user

local CURRENT_HL = "GitConflictCurrent"
local INCOMING_HL = "GitConflictIncoming"
local CURRENT_LABEL_HL = "GitConflictCurrentLabel"
local INCOMING_LABEL_HL = "GitConflictIncomingLabel"

local DEFAULT_CURRENT_BG = nil
local DEFAULT_INCOMING_BG = nil

local conflict_start = "^<<<<<<<"
local conflict_middle = "^======="
local conflict_end = "^>>>>>>>"

local SIDES = { OURS = "ours", THEIRS = "theirs", BOTH = "both", NONE = "none" }
local name_map = { ours = "current", theirs = "incoming", both = "both", none = "none" }

local DEFAULT_MAPPINGS = {
    ours = "co",
    theirs = "ct",
    none = "c0",
    both = "cb",
    next = "]x",
    prev = "[x",
}

-----------------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------------

local function shade_color(rgb_24bit, percent)
    local r = bit.band(bit.rshift(rgb_24bit, 16), 255)
    local g = bit.band(bit.rshift(rgb_24bit, 8), 255)
    local b = bit.band(rgb_24bit, 255)
    local function alter(v)
        return math.min(math.floor(v * (100 + percent) / 100), 255)
    end
    return string.format("#%02x%02x%02x", alter(r), alter(g), alter(b))
end

local function get_hl_bg(name)
    if not name then
        return nil
    end
    local hl = api.nvim_get_hl(0, { name = name })
    return hl and hl.bg or nil
end

local function is_valid_buf(bufnr)
    return #vim.bo[bufnr].buftype == 0 and vim.bo[bufnr].modifiable
end

-----------------------------------------------------------------------------
-- State
-----------------------------------------------------------------------------

--- @type table<string, { bufnr: integer, positions: table[], tick: integer }>
local visited_buffers = setmetatable({}, {
    __index = function(t, k)
        if type(k) == "number" then
            return t[api.nvim_buf_get_name(k)]
        end
    end,
})

-----------------------------------------------------------------------------
-- Highlights
-----------------------------------------------------------------------------

local function set_highlights()
    local rikka = require("rikka")
    local cur_bg = get_hl_bg("DiffText") or rikka.color.blue
    local inc_bg = get_hl_bg("DiffAdd") or rikka.color.green
    api.nvim_set_hl(0, CURRENT_HL, { bg = cur_bg, bold = true, default = true })
    api.nvim_set_hl(0, INCOMING_HL, { bg = inc_bg, bold = true, default = true })
    api.nvim_set_hl(0, CURRENT_LABEL_HL, { bg = shade_color(cur_bg, 60), default = true })
    api.nvim_set_hl(0, INCOMING_LABEL_HL, { bg = shade_color(inc_bg, 60), default = true })
end

-----------------------------------------------------------------------------
-- Detection
-----------------------------------------------------------------------------

local function detect_conflicts(lines)
    local positions = {}
    local pos, has_start, has_middle = nil, false, false
    for index, line in ipairs(lines) do
        local lnum = index - 1
        if line:match(conflict_start) then
            has_start = true
            pos = {
                current = { range_start = lnum, content_start = lnum + 1 },
                middle = {},
                incoming = {},
            }
        end
        if has_start and line:match(conflict_middle) then
            has_middle = true
            pos.current.range_end = lnum - 1
            pos.current.content_end = lnum - 1
            pos.middle.range_start = lnum
            pos.middle.range_end = lnum + 1
            pos.incoming.range_start = lnum + 1
            pos.incoming.content_start = lnum + 1
        end
        if has_start and has_middle and line:match(conflict_end) then
            pos.incoming.range_end = lnum
            pos.incoming.content_end = lnum - 1
            positions[#positions + 1] = pos
            pos, has_start, has_middle = nil, false, false
        end
    end
    return #positions > 0, positions
end

-----------------------------------------------------------------------------
-- Highlighting
-----------------------------------------------------------------------------

local function clear(bufnr)
    if bufnr and not api.nvim_buf_is_valid(bufnr) then
        return
    end
    api.nvim_buf_clear_namespace(bufnr or 0, NAMESPACE, 0, -1)
end

local function hl_range(bufnr, hl, range_start, range_end)
    if not range_start or not range_end then
        return
    end
    return api.nvim_buf_set_extmark(bufnr, NAMESPACE, range_start, 0, {
        hl_group = hl,
        hl_eol = true,
        hl_mode = "combine",
        end_row = range_end,
        priority = PRIORITY,
    })
end

local function draw_label(bufnr, hl, label, lnum)
    local width = api.nvim_win_get_width(0) - api.nvim_strwidth(label)
    return api.nvim_buf_set_extmark(bufnr, NAMESPACE, lnum, 0, {
        hl_group = hl,
        virt_text = { { label .. string.rep(" ", width), hl } },
        virt_text_pos = "overlay",
        priority = PRIORITY,
    })
end

local function highlight_conflicts(bufnr, positions, lines)
    clear(bufnr)
    for _, p in ipairs(positions) do
        local cur_label = lines[p.current.range_start + 1] .. " (Current changes)"
        local inc_label = lines[p.incoming.range_end + 1] .. " (Incoming changes)"
        draw_label(bufnr, CURRENT_LABEL_HL, cur_label, p.current.range_start)
        hl_range(bufnr, CURRENT_HL, p.current.range_start, p.current.range_end + 1)
        hl_range(bufnr, INCOMING_HL, p.incoming.range_start, p.incoming.range_end + 1)
        draw_label(bufnr, INCOMING_LABEL_HL, inc_label, p.incoming.range_end)
    end
end

-----------------------------------------------------------------------------
-- Buffer processing
-----------------------------------------------------------------------------

local function parse_buffer(bufnr)
    local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local name = api.nvim_buf_get_name(bufnr)
    local prev_had = visited_buffers[name] and visited_buffers[name].positions and #visited_buffers[name].positions > 0
    local has_conflict, positions = detect_conflicts(lines)

    if not visited_buffers[name] then
        visited_buffers[name] = {}
    end
    visited_buffers[name].bufnr = bufnr
    visited_buffers[name].tick = vim.b[bufnr].changedtick
    visited_buffers[name].positions = positions

    if has_conflict then
        highlight_conflicts(bufnr, positions, lines)
    else
        clear(bufnr)
    end

    if prev_had ~= has_conflict then
        local pattern = has_conflict and "GitConflictDetected" or "GitConflictResolved"
        api.nvim_exec_autocmds("User", { pattern = pattern, data = { buf = bufnr } })
    end
end

local function process(bufnr)
    if not bufnr or not api.nvim_buf_is_valid(bufnr) then
        return
    end
    local entry = visited_buffers[bufnr]
    if entry and entry.tick == vim.b[bufnr].changedtick then
        return
    end
    parse_buffer(bufnr)
end

local function try_register(bufnr)
    if not is_valid_buf(bufnr) then
        return
    end
    local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
    for _, line in ipairs(lines) do
        if line:match(conflict_start) then
            local name = api.nvim_buf_get_name(bufnr)
            if not visited_buffers[name] then
                visited_buffers[name] = {}
            end
            parse_buffer(bufnr)
            return
        end
    end
end

-----------------------------------------------------------------------------
-- Navigation
-----------------------------------------------------------------------------

local function find_position(bufnr, comparator, opts)
    local match = visited_buffers[bufnr]
    if not match then
        return
    end
    local line = api.nvim_win_get_cursor(0)[1] - 1 -- 0-based

    if opts and opts.reverse then
        for i = #match.positions, 1, -1 do
            if comparator(line, match.positions[i]) then
                return match.positions[i]
            end
        end
        if opts.wrap and match.positions[#match.positions] then
            return match.positions[#match.positions]
        end
        return nil
    end

    for _, position in ipairs(match.positions) do
        if comparator(line, position) then
            return position
        end
    end
    if opts and opts.wrap and match.positions[1] then
        return match.positions[1]
    end
    return nil
end

local function get_current_position(bufnr)
    return find_position(bufnr, function(line, position)
        return position.current.range_start <= line and position.incoming.range_end >= line
    end)
end

local function set_cursor(position, side)
    if not position then
        return
    end
    local target = side == SIDES.OURS and position.current or position.incoming
    api.nvim_win_set_cursor(0, { target.range_start + 1, 0 })
end

local function find_next(side)
    local pos = find_position(0, function(line, position)
        return line < position.current.range_start
    end, { wrap = true })
    set_cursor(pos, side)
end

local function find_prev(side)
    local pos = find_position(0, function(line, position)
        return line > position.current.range_start
    end, { wrap = true, reverse = true })
    set_cursor(pos, side)
end

-----------------------------------------------------------------------------
-- Resolution
-----------------------------------------------------------------------------

local function resolve_position(bufnr, position, side)
    local lines = {}
    if vim.tbl_contains({ SIDES.OURS, SIDES.THEIRS }, side) then
        local data = position[name_map[side]]
        lines = api.nvim_buf_get_lines(bufnr, data.content_start, data.content_end + 1, false)
    elseif side == SIDES.BOTH then
        local first = api.nvim_buf_get_lines(bufnr, position.current.content_start, position.current.content_end + 1, false)
        local second = api.nvim_buf_get_lines(bufnr, position.incoming.content_start, position.incoming.content_end + 1, false)
        lines = vim.list_extend(first, second)
    elseif side == SIDES.NONE then
        lines = {}
    else
        return
    end

    local pos_start = math.max(position.current.range_start, 0)
    local pos_end = position.incoming.range_end + 1
    api.nvim_buf_set_lines(bufnr, pos_start, pos_end, false, lines)
    parse_buffer(bufnr)
end

local function choose(side)
    local bufnr = api.nvim_get_current_buf()
    local mode = vim.fn.mode()

    if mode == "v" or mode == "V" or mode == "\22" then
        api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        vim.defer_fn(function()
            local start = api.nvim_buf_get_mark(0, "<")[1]
            local finish = api.nvim_buf_get_mark(0, ">")[1]
            local position = find_position(bufnr, function(_, pos)
                return pos.current.range_start >= start - 1 and pos.incoming.range_end <= finish + 1
            end)
            while position do
                resolve_position(bufnr, position, side)
                position = find_position(bufnr, function(_, pos)
                    return pos.current.range_start >= start - 1 and pos.incoming.range_end <= finish + 1
                end)
            end
        end, 50)
        return
    end

    local position = get_current_position(bufnr)
    if position then
        resolve_position(bufnr, position, side)
    end
end

-----------------------------------------------------------------------------
-- Buffer mappings
-----------------------------------------------------------------------------

local function setup_buffer_mappings(bufnr)
    local function opts(desc)
        return { silent = true, buffer = bufnr, desc = "Git Conflict: " .. desc }
    end
    vim.keymap.set({ "n", "v" }, DEFAULT_MAPPINGS.ours, function()
        choose("ours")
    end, opts("Choose Ours"))
    vim.keymap.set({ "n", "v" }, DEFAULT_MAPPINGS.theirs, function()
        choose("theirs")
    end, opts("Choose Theirs"))
    vim.keymap.set({ "n", "v" }, DEFAULT_MAPPINGS.both, function()
        choose("both")
    end, opts("Choose Both"))
    vim.keymap.set({ "n", "v" }, DEFAULT_MAPPINGS.none, function()
        choose("none")
    end, opts("Choose None"))
    vim.keymap.set("n", DEFAULT_MAPPINGS.next, function()
        find_next("ours")
    end, opts("Next Conflict"))
    vim.keymap.set("n", DEFAULT_MAPPINGS.prev, function()
        find_prev("ours")
    end, opts("Previous Conflict"))
    vim.b[bufnr].conflict_mappings_set = true
end

local function clear_buffer_mappings(bufnr)
    if not bufnr or not vim.b[bufnr].conflict_mappings_set then
        return
    end
    for _, mapping in pairs(DEFAULT_MAPPINGS) do
        pcall(api.nvim_buf_del_keymap, bufnr, "n", mapping)
        pcall(api.nvim_buf_del_keymap, bufnr, "v", mapping)
    end
    vim.b[bufnr].conflict_mappings_set = false
end

-----------------------------------------------------------------------------
-- Commands
-----------------------------------------------------------------------------

local function set_commands()
    local cmd = api.nvim_create_user_command
    cmd("GitConflictRefresh", function()
        for _, buf in ipairs(api.nvim_list_bufs()) do
            if api.nvim_buf_is_loaded(buf) and is_valid_buf(buf) then
                try_register(buf)
            end
        end
    end, {})
    cmd("GitConflictChooseOurs", function()
        choose("ours")
    end, {})
    cmd("GitConflictChooseTheirs", function()
        choose("theirs")
    end, {})
    cmd("GitConflictChooseBoth", function()
        choose("both")
    end, {})
    cmd("GitConflictChooseNone", function()
        choose("none")
    end, {})
    cmd("GitConflictNextConflict", function()
        find_next("ours")
    end, {})
    cmd("GitConflictPrevConflict", function()
        find_prev("ours")
    end, {})
end

-----------------------------------------------------------------------------
-- Setup
-----------------------------------------------------------------------------

set_highlights()
set_commands()

local aug = api.nvim_create_augroup(AUGROUP, { clear = true })

api.nvim_create_autocmd("BufReadPost", {
    group = aug,
    callback = function(args)
        try_register(args.buf)
    end,
})

api.nvim_create_autocmd("User", {
    group = aug,
    pattern = "GitConflictDetected",
    callback = function()
        local bufnr = api.nvim_get_current_buf()
        vim.diagnostic.enable(false, { bufnr = bufnr })
        setup_buffer_mappings(bufnr)
    end,
})

api.nvim_create_autocmd("User", {
    group = aug,
    pattern = "GitConflictResolved",
    callback = function()
        local bufnr = api.nvim_get_current_buf()
        vim.diagnostic.enable(true, { bufnr = bufnr })
        clear_buffer_mappings(bufnr)
    end,
})

api.nvim_set_decoration_provider(NAMESPACE, {
    on_buf = function(_, bufnr)
        return is_valid_buf(bufnr)
    end,
    on_win = function(_, _, bufnr)
        if visited_buffers[bufnr] then
            process(bufnr)
        end
    end,
})

-- Process current buffer on first load (BufReadPost already fired before require)
rikka.createAutocmd("BufReadPost", {
    callback = function(args)
        local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
        for _, line in ipairs(lines) do
            if line:match("^<<<<<<<") then
                try_register(args.buf)
                return true -- delete this autocmd after first trigger
            end
        end
    end,
})
