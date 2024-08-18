if vim.g.loaded_remote_line then
  return
end
vim.g.loaded_remote_line = 1

vim.api.nvim_command(
  "command! -range -nargs=0 RemoteLine lua require('remote-line.window').menu(<line1>, <line2>, vim.fn.resolve(vim.api.nvim_buf_get_name(0)))"
)

