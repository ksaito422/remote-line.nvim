describe("RemoteLine command setup", function()
  before_each(function()
    vim.g.loaded_remote_line = nil
    pcall(vim.api.nvim_del_user_command, "RemoteLine")
  end)

  it("sets vim.g.loaded_remote_line and registers the command if not already loaded", function()
    loadfile("plugin/remote-line.lua")()

    assert.are.equal(1, vim.g.loaded_remote_line)

    local commands = vim.api.nvim_get_commands({})
    assert.is_not_nil(commands["RemoteLine"])
    assert.equals(".", commands["RemoteLine"].range)
    assert.equals("?", commands["RemoteLine"].nargs)
  end)

  it("does nothing if vim.g.loaded_remote_line is already set", function()
    vim.g.loaded_remote_line = 1

    loadfile("plugin/remote-line.lua")()

    assert.are.equal(1, vim.g.loaded_remote_line)

    local commands = vim.api.nvim_get_commands({})
    assert.is_nil(commands["RemoteLine"])
  end)

  it("calls window.menu with correct arguments", function()
    local mock_called = false
    package.loaded["remote-line.window"] = {
      menu = function(start_line, end_line, filename, args)
        mock_called = true
        assert.equals(2, start_line)
        assert.equals(4, end_line)
        assert.equals(vim.fn.resolve(vim.api.nvim_buf_get_name(0)), filename)
        assert.equals("testarg", args)
      end,
    }

    -- Create test buffer
    vim.cmd("enew")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "line1", "line2", "line3", "line4" })
    vim.api.nvim_buf_set_name(0, "testfile.txt")

    -- Load plugin and execute command
    loadfile("plugin/remote-line.lua")()
    vim.cmd("2,4RemoteLine testarg")

    assert.is_true(mock_called)
  end)
end)
