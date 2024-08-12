local M = {}

local function get_git_info(path)
  local fileDir = vim.fn.expand("%:p:h")
  local cdDir = string.format("cd %s; ", fileDir)

  local commit = vim.fn.system(cdDir .. "git log -1 --format=%H")
  local gitRoot = vim.fn.system(cdDir .. "git rev-parse --show-toplevel")

  local function strip_newlines(s)
    return s:gsub("\n", "")
  end

  commit = strip_newlines(commit)
  gitRoot = strip_newlines(gitRoot)
  local fullPath = strip_newlines(path)

  local relative = fullPath:sub(#gitRoot + 2)

  return commit, relative
end

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

  if rl_git_remote == "" then
    return nil
  end

  local remote_url = vim.fn.system(cdDir .. "git config --get remote." .. rl_git_remote .. ".url")
  remote_url = vim.fn.trim(remote_url)

  return remote_url
end

local function generate_url(remote_url, action, commit, relative, firstLine, lastLine)
  local url = ""
  local lineRange = ""

  local function is_github(remote_url)
    return string.match(remote_url, "github")
  end

  local function github_line_range(firstLine, lastLine)
    if firstLine == lastLine then
      return "L" .. firstLine
    else
      return "L" .. firstLine .. "-L" .. lastLine
    end
  end

  local function github_url(remote)
    local rv = remote
    local a_pattern = "^[^@]*@([^:/]*):?/?"
    local replacement = "https://%1/"
    rv = rv:gsub(a_pattern, replacement)

    rv = rv:gsub("\n$", "")

    local b_pattern = ".git" .. "$"
    rv = rv:gsub(b_pattern, "")

    return rv
  end

  if is_github(remote_url) then
    lineRange = github_line_range(firstLine, lastLine)
    url = github_url(remote_url) .. "/" .. action .. "/" .. commit .. "/" .. relative .. "#" .. lineRange
  else
    error(
      "The remote: "
        .. remote_url
        .. " has not been recognized as belonging to "
        .. "one of the supported git hosting environments: Github"
    )
  end

  return url
end

local function gh_exec_cmd(url)
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

function M.open(firstLine, lastLine, path)
  local remote_url = get_remote_url()

  if not remote_url then return end

  -- TODO I want to be able to choose the action for this.
  local action = "blob"
  local commit, relative = get_git_info(path)

  local url = generate_url(remote_url, action, commit, relative, firstLine, lastLine)

  gh_exec_cmd(url)
end

return M
