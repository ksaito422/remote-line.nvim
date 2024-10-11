local open_menu = require("remote-line.window").menu

describe("menu", function()
  it("should open floating window with correct lines", function()
    open_menu()

    local win_id = vim.fn.win_getid()
    assert.is_not_nil(win_id)

    assert.is_true(vim.api.nvim_win_is_valid(win_id))

    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)

    assert.are.same({
      "1. Open remote repository in blob",
      "2. Copy remote repository URL",
      "3. Open remote repository in blame",
      "4. Open pull request the last changed commit",
    }, lines)
  end)

  it("should close the floating window", function()
    open_menu()

    local win_id = vim.fn.win_getid()
    assert.is_true(vim.api.nvim_win_is_valid(win_id))

    vim.api.nvim_win_close(win_id, true)

    assert.is_false(vim.api.nvim_win_is_valid(win_id))
  end)
end)
