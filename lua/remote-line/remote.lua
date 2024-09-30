local generate = require("remote-line.generate")

local M = {}

local function open_remote(url)
  if vim.fn.has("macunix") == 1 then
    vim.fn.system("open " .. url)
  elseif vim.fn.has("unix") == 1 then
    vim.fn.system("xdg-open " .. url)
  elseif vim.fn.has("win32") == 1 then
    os.execute("start " .. url)
  else
    print("Unsupported OS")
  end
end

local function url_clipboard(url)
  if vim.fn.has("macunix") == 1 then
    vim.fn.system("echo " .. vim.fn.shellescape(url) .. " | pbcopy")
  elseif vim.fn.has("unix") == 1 then
    vim.fn.system("echo " .. vim.fn.shellescape(url) .. " | xclip -selection clipboard")
  elseif vim.fn.has("win32") == 1 then
    vim.fn.system("echo " .. vim.fn.shellescape(url) .. " | clip")
  else
    print("Unsupported OS")
  end
end

function M.open(firstLine, lastLine, path, action)
  local url = generate.url(firstLine, lastLine, path, action)

  if url == "" then
    return
  end

  open_remote(url)
end

function M.copy(firstLine, lastLine, path, action)
  local url = generate.url(firstLine, lastLine, path, action)

  url_clipboard(url)
  print("success to copy the URL to clipboard")
end

return M
