describe("url", function()
  describe("when action is blob", function()
    it("returns blob url", function()
      -- dummy file for testing
      vim.cmd("edit plugin/test.lua")

      local generate = require("remote-line.generate")
      local url = generate.url(1, 3, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), "blob")

      assert.is_true(
        string.match(url, "https://github%.com/ksaito422/remote%-line%.nvim/blob/.*/plugin/test%.lua#L1%-L3") ~= nil
      )
    end)
  end)
end)
