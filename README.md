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
- [gh](https://cli.github.com/)
- [jq](https://github.com/jqlang/jq)

## 📦Usage

Available via `RemoteLine` command.

