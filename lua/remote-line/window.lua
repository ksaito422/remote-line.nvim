local remote = require("remote-line.remote")

local M = {}

local function select_option(buf, win, currentCursorLine, firstLine, path, mode)
  local row = vim.api.nvim_win_get_cursor(win)[1]
  local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]

  if line == "1. Open remote repository in blob" then
    remote.open(currentCursorLine, firstLine, path, "blob", mode)
  elseif line == "2. Copy remote repository URL" then
    remote.copy(currentCursorLine, firstLine, path, "blob", mode)
  elseif line == "3. Open remote repository in blame" then
    remote.open(currentCursorLine, firstLine, path, "blame", mode)
  elseif line == "4. Open pull request the last changed commit" then
    remote.open(currentCursorLine, firstLine, path, "pull", mode)
  end

  vim.api.nvim_win_close(win, true)
end

function M.menu(firstLine, lastLine, path, mode)
  local content = {
    "1. Open remote repository in blob",
    "2. Copy remote repository URL",
    "3. Open remote repository in blame",
    "4. Open pull request the last changed commit",
  }
  local width = 100
  local height = #content
  local opts = {
    relative = "cursor",
    row = 1,
    col = 1,
    width = width,
    height = height,
    style = "minimal",
    border = "single",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.keymap.set("n", "q", ":q<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<CR>", function()
    select_option(buf, win, firstLine, lastLine, path, mode)
  end, { noremap = true, silent = true, buffer = buf })
end

return M
