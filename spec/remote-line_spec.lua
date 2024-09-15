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
  end)

  it("does nothing if vim.g.loaded_remote_line is already set", function()
    vim.g.loaded_remote_line = 1

    loadfile("plugin/remote-line.lua")()

    assert.are.equal(1, vim.g.loaded_remote_line)

    local commands = vim.api.nvim_get_commands({})
    assert.is_nil(commands["RemoteLine"])
  end)
end)
