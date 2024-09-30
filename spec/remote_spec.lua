local mock = require("luassert.mock")
local spy = require("luassert.spy")
local stub = require("luassert.stub")

describe("open", function()
  local M
  local generate_mock
  local print_exec = spy.on(_G, "print")

  before_each(function()
    M = require("remote-line.remote")
    generate_mock = mock(require("remote-line.generate"), true)

    stub(vim.fn, "has")
    stub(vim.fn, "system")
    stub(os, "execute")
  end)

  it('should call "open" on macunix', function()
    vim.fn.has.on_call_with("macunix").returns(1)
    vim.fn.has.on_call_with("unix").returns(0)
    vim.fn.has.on_call_with("win32").returns(0)
    generate_mock.url.returns("http://example.com")

    M.open(1, 10, "path/example", "blob")

    assert.stub(vim.fn.system).was_called_with("open http://example.com")
  end)

  it('should call "xdg-open" on unix', function()
    vim.fn.has.on_call_with("macunix").returns(0)
    vim.fn.has.on_call_with("unix").returns(1)
    vim.fn.has.on_call_with("win32").returns(0)
    generate_mock.url.returns("http://example.com")

    M.open(1, 10, "path/example", "blob")

    assert.stub(vim.fn.system).was_called_with("xdg-open http://example.com")
  end)

  it('should call "start" on win32', function()
    vim.fn.has.on_call_with("macunix").returns(0)
    vim.fn.has.on_call_with("unix").returns(0)
    vim.fn.has.on_call_with("win32").returns(1)
    generate_mock.url.returns("http://example.com")

    M.open(1, 10, "path/example", "blob")

    assert.stub(os.execute).was_called_with("start http://example.com")
  end)

  it('should print "Unsupported OS" for unknown OS', function()
    vim.fn.has.on_call_with("macunix").returns(0)
    vim.fn.has.on_call_with("unix").returns(0)
    vim.fn.has.on_call_with("win32").returns(0)
    generate_mock.url.returns("http://example.com")

    M.open(1, 10, "path/example", "blob")

    assert.spy(print_exec).was_called_with("Unsupported OS")
  end)

  after_each(function()
    mock.revert(generate_mock)
  end)
end)
