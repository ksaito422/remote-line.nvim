if vim.g.loaded_remote_line then
  return
end
vim.g.loaded_remote_line = 1

vim.api.nvim_command(
  "command! -range -nargs=1 -complete=customlist,v:lua.RemoteLineComplete RemoteLine lua require('remote-line.window').menu(<line1>, <line2>, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), <f-args>)"
)

function _G.RemoteLineComplete(A, _, _)
  local items = { "commit", "branch" }
  return vim.tbl_filter(function(val)
    return vim.startswith(val, A)
  end, items)
end
