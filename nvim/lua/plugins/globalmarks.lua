-- custom program to show what global marks i have and delete any i dont want
local marks_win = nil
local marks_buf = nil

local function open_marks_window()
  -- If window already exists, close it before recreating
  if marks_win and vim.api.nvim_win_is_valid(marks_win) then
    vim.api.nvim_win_close(marks_win, true)
  end

  -- Fetch global marks (A-Z)
  local all = vim.fn.getmarklist()
  local marks = {}

  for _, m in ipairs(all) do
    local mark = m.mark:sub(2, 2)
    if mark:match("%u") then
      table.insert(marks, {
        mark = mark,
        file = vim.fn.fnamemodify(m.file or "", ":~"),
        line = m.pos[2]
      })
    end
  end

  -- Convert to display lines
  local lines = {}
  for _, m in ipairs(marks) do
    table.insert(lines, string.format("%s  %s  line %d", m.mark, m.file, m.line))
  end
  if #lines == 0 then lines = { "No global marks found." } end

  -- Create new buffer
  marks_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(marks_buf, 0, -1, false, lines)

  -- Compute width
  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, #l)
  end

  -- Create window
  marks_win = vim.api.nvim_open_win(marks_buf, true, {
    relative = "editor",
    width = width + 4,
    height = #lines + 2,
    row = 4,
    col = 10,
    style = "minimal",
    border = "rounded",
  })

  -- Keybind: close with q
  vim.keymap.set("n", "q", function()
    if marks_win and vim.api.nvim_win_is_valid(marks_win) then
      vim.api.nvim_win_close(marks_win, true)
    end
    marks_win = nil
    marks_buf = nil
  end, { buffer = marks_buf })

  -- Keybind: delete mark under cursor
  vim.keymap.set("n", "d", function()
    local row = vim.api.nvim_win_get_cursor(marks_win)[1]
    local entry = marks[row]
    if not entry then return end

    local mark = entry.mark

    -- Delete globally
    vim.cmd("delmarks " .. mark)

    -- Refresh window safely (close first)
    open_marks_window()
  end, { buffer = marks_buf })
end

-- Keybind to open window
vim.keymap.set("n", "<leader>gm", open_marks_window)
