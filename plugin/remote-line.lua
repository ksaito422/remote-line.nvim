if vim.g.loaded_remote_line then
  return
end
vim.g.loaded_remote_line = 1

vim.api.nvim_create_user_command("RemoteLine", function(opts)
  require("remote-line.window").menu(opts.line1, opts.line2, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), opts.args)
end, {
  range = true,
  nargs = "?",
})
