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
  local remotes = vim.fn.system(string.format("%s git remote", cdDir))
  local remote_list = vim.split(remotes, "\n")

  if #remote_list == 0 then
    print("It seems the repo does not have any remote.")
    return nil
  end

  -- NOTE: Remove the last empty string
  if remote_list[#remote_list] == "" then
    table.remove(remote_list, #remote_list)
  end

  local remote = remote_list[1]
  if #remote_list >= 2 then
    vim.ui.select(remote_list, {
      prompt = "Select remote",
    }, function(selected)
      if selected then
        remote = selected
      end
    end)
  end

  local remote_url = vim.fn.system(cdDir .. "git config --get remote." .. remote .. ".url")
  remote_url = vim.fn.trim(remote_url)

  return remote_url
end

local function github_line_range(firstLine, lastLine)
  if firstLine == lastLine then
    return "L" .. firstLine
  else
    return "L" .. firstLine .. "-L" .. lastLine
  end
end

local function is_github(remote_url)
  return string.match(remote_url, "github")
end

local function generate_url(remote_url, action, commit, relative, firstLine, lastLine)
  local url = ""
  local lineRange = ""

  -- TODO: want to refactor
  if action == "pull" then
    local commit_hash = vim.fn.system(
      "git blame -L " .. firstLine .. "," .. firstLine .. " " .. relative .. " -s | awk '{print $1}' | tr -d '\n'"
    )
    url = vim.fn.system("gh search prs " .. commit_hash .. " --json url | jq '.[].url'")

    if url == "" then
      print("No pull request containing '" .. commit_hash .. "' was found")
      return url
    end
    return vim.fn.system("gh search prs " .. commit_hash .. " --json url | jq '.[].url'")
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

function M.url(firstLine, lastLine, path, action)
  local remote_url = get_remote_url()

  if not remote_url then
    return
  end

  local commit, relative = get_git_info(path)

  return generate_url(remote_url, action, commit, relative, firstLine, lastLine)
end

return M
