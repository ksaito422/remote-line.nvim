if vim.g.loaded_remote_line then
  return
end
vim.g.loaded_remote_line = 1
vim.api.nvim_command("command! -nargs=0 OpenRemote lua require('remote-line.open_remote').open()")
