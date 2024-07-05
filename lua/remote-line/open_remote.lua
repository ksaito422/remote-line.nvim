local M = {}

local function get_remote_url()
  local fileDir = vim.fn.expand("%:p:h")
  local cdDir = string.format("cd %s; ", fileDir)
  local remotes = vim.fn.system(string.format(cdDir .. "git remote"))
  local remote_list = vim.split(remotes, "\n")

  if #remote_list == 0 then
    print("It seems the repo does not have any remote.")
    return nil
  end

  local rl_git_remote = vim.g.rl_git_remote or remote_list[1]
  -- TODO: remoteが複数設定されている場合に選択できるようにしたい
  -- if vim.v.argc == 2 or rl_git_remote == "" or not vim.tbl_contains(remote_list, rl_git_remote) then
  --   rl_git_remote = vim.fn.inputlist(remote_list)
  --   vim.g.rl_git_remote = rl_git_remote
  -- end

  if rl_git_remote == "" then
    return nil
  end

function M.open()
  print("Open remote!!")

  local remote_url = get_remote_url()
  print(remote_url)
end

return M
