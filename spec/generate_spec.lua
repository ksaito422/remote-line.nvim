describe("url", function()
  local generate
  local original_get_git_info

  before_each(function()
    -- dummy file for testing
    vim.cmd("edit plugin/test.lua")
    generate = require("remote-line.generate")

    -- Mock only get_git_info to return fixed values
    original_get_git_info = generate.get_git_info
    generate.get_git_info = function(path)
      local relative = "plugin/test.lua"
      if path:find("test%.lua") then
        relative = "plugin/test.lua"
      end
      return "123abc", "main", relative
    end
  end)

  after_each(function()
    -- Restore original get_git_info
    generate.get_git_info = original_get_git_info
  end)

  describe("when action is blob", function()
    it("returns blob url", function()
      local url = generate.url(1, 3, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), "blob", "commit")

      assert.are.equal(url, "https://github.com/ksaito422/remote-line.nvim/blob/123abc/plugin/test.lua#L1-L3")
    end)
  end)

  describe("when action is blame", function()
    it("returns blame url", function()
      local url = generate.url(1, 3, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), "blame", "commit")

      assert.are.equal(url, "https://github.com/ksaito422/remote-line.nvim/blame/123abc/plugin/test.lua#L1-L3")
    end)
  end)

  describe("when branch is specified", function()
    it("returns url with branch name", function()
      local url = generate.url(1, 3, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), "blob", "branch")

      assert.are.equal(url, "https://github.com/ksaito422/remote-line.nvim/blob/main/plugin/test.lua#L1-L3")
    end)
  end)

  describe("when commit hash is specified", function()
    it("returns url with commit hash", function()
      local url = generate.url(1, 3, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), "blob", "commit")

      assert.are.equal(url, "https://github.com/ksaito422/remote-line.nvim/blob/123abc/plugin/test.lua#L1-L3")
    end)
  end)
end)
