describe("url", function()
  local generate

  before_each(function()
    -- dummy file for testing
    vim.cmd("edit plugin/test.lua")
    generate = require("remote-line.generate")
  end)

  describe("when action is blob", function()
    describe("when mode is blank", function()
      it("returns blob url", function()
        local url = generate.url(1, 3, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), "blob", "")

        assert.is_true(
          string.match(url, "https://github%.com/ksaito422/remote%-line%.nvim/blob/.*/plugin/test%.lua#L1%-L3") ~= nil
        )
      end)
    end)

    describe("when mode is specific", function()
      it("returns blob url", function()
        local url = generate.url(1, 3, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), "blob", "main")

        assert.is_true(
          string.match(url, "https://github%.com/ksaito422/remote%-line%.nvim/blob/main/plugin/test%.lua#L1%-L3") ~= nil
        )
      end)
    end)
  end)

  describe("when action is blame", function()
    describe("when mode is blank", function()
      it("returns blame url", function()
        local url = generate.url(1, 3, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), "blame", "")

        assert.is_true(
          string.match(url, "https://github%.com/ksaito422/remote%-line%.nvim/blame/.*/plugin/test%.lua#L1%-L3") ~= nil
        )
      end)
    end)

    describe("when mode is specific", function()
      it("returns blame url", function()
        local url = generate.url(1, 3, vim.fn.resolve(vim.api.nvim_buf_get_name(0)), "blame", "main")

        assert.is_true(
          string.match(url, "https://github%.com/ksaito422/remote%-line%.nvim/blame/main/plugin/test%.lua#L1%-L3")
            ~= nil
        )
      end)
    end)
  end)
end)
