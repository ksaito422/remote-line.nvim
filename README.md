# remote-line.nvim
Open current line on remote repository.

## 🚀Features

- Open the currently selected line in the remote repository
- Copy the URL of the remote repository for the currently selected line
- Open the line currently selected in blame mode in the remote repository
- Open pull request the last changed commit


## ⚙️Introduction

### lazy.nvim
```lua
require("lazy").setup({
  {
    "ksaito422/remote-line.nvim",
    dir = "~/work/project/dev/nvim-plug/remote-line.nvim",
    config = function()
      require("remote-line").setup({})
    end,
  }
)}
```

## ⚡️Requirements
- (optional)[gh](https://cli.github.com/)
- (optional)[jq](https://github.com/jqlang/jq)
- (optional)[luarocks](https://luarocks.org/)
  - (optional)[busted](https://github.com/lunarmodules/busted)

## 📦Usage

Available via `RemoteLine` command.

