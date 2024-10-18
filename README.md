# remote-line.nvim

<div align="center"><p>
  <a href="https://github.com/ksaito422/remote-line.nvim/releases/latest">
    <img alt="Latest release" src="https://img.shields.io/github/v/release/ksaito422/remote-line.nvim?style=for-the-badge&logo=startrek&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41&include_prerelease&sort=semver" />
  </a>
  <a href="https://github.com/ksaito422/remote-line.nvim/pulse">
    <img alt="Last commit" src="https://img.shields.io/github/last-commit/ksaito422/remote-line.nvim?style=for-the-badge&logo=lightning&color=8bd5ca&logoColor=D9E0EE&labelColor=302D41"/>
  </a>
  <a href="https://github.com/ksaito422/remote-line.nvim/actions/workflows/test.yml">
    <img alt="CI Status Badge" src="https://img.shields.io/github/actions/workflow/status/ksaito422/remote-line.nvim/test.yml?style=for-the-badge&logo=github&color=8bd5ca&logoColor=D9E0EE&labelColor=302D41" />
  </a>
</div>

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
    config = function()
      require("remote-line").setup({})
    end,
  }
)}
```

## ⚡️Requirements
- [gh](https://cli.github.com/)(optional)
- [jq](https://github.com/jqlang/jq)(optional)

## 📦Usage

Available via `RemoteLine` command.

## ⌨️Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ksaito422/remote-line.nvim.
