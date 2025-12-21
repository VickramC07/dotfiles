local M = {}

-- Comment strings per filetype
local comment_map = {
    lua        = "--",
    python     = "#",
    sh         = "#",
    bash       = "#",
    zsh        = "#",
    javascript = "//",
    typescript = "//",
    java       = "//",
    c          = "//",
    cpp        = "//",
    go         = "//",
    rust       = "//",
    html       = "<!-- -->",
    css        = "/* */",
    vim        = "\"",
}

-- Get comment string for current buffer
local function get_comment()
    local ft = vim.bo.filetype
    return comment_map[ft]
end

-- Toggle comment for a single line
local function toggle_line(line, comment)
    if not line then line = "" end

    -- Skip empty or whitespace-only lines
    if line:match("^%s*$") then
        return line
    end

    if comment:find(" ") then
        -- block comments (e.g. <!-- -->, /* */)
        local open, close = comment:match("^(.*) (.*)$")
        if line:match("^%s*" .. vim.pesc(open)) then
            return line:gsub("^%s*" .. vim.pesc(open) .. "%s?", "")
                       :gsub("%s*" .. vim.pesc(close) .. "%s*$", "")
        else
            return open .. " " .. line .. " " .. close
        end
    else
        -- line comments
        local indent = line:match("^(%s*)") or ""
        local content = line:sub(#indent + 1)
        if string.sub(content, 1, #comment) == comment then
            return indent .. string.sub(content, #comment + 2)
        else
            return indent .. comment .. " " .. content
        end
    end
end

-- Comment current line, count of lines, or visual selection
function M.toggle()
    local comment = get_comment()
    if not comment then
        vim.notify("No comment defined for filetype", vim.log.levels.WARN)
        return
    end

    local mode = vim.fn.mode()

    if mode == "v" or mode == "V" then
        -- Visual mode
        local start = vim.fn.line("'<")
        local finish = vim.fn.line("'>")
        for i = start, finish do
            local line = vim.fn.getline(i)
            vim.fn.setline(i, toggle_line(line, comment))
        end
    else
        -- Normal mode with optional count
        local count = vim.v.count1 -- defaults to 1 if no count
        local start = vim.fn.line(".")
        local last_line = vim.fn.line("$")
        local finish = math.min(start + count - 1, last_line) -- clamp to buffer end
        for i = start, finish do
            local line = vim.fn.getline(i)
            vim.fn.setline(i, toggle_line(line, comment))
        end
    end
end


-- Keymap at the bottom

vim.keymap.set({ "n", "v" }, "<leader>cc", function()
    M.toggle()
end, { desc = "Toggle comment" })

return M

