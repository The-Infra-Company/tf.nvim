# tf.nvim

A small Neovim plugin that uses Telescope to list Terraform resources and variables in the current buffer, then jump to the selected block.

---

## What is tf.nvim?

`tf.nvim` helps you move through Terraform files without manually searching for blocks. It parses the current buffer for Terraform `resource` and `variable` declarations, opens them in a Telescope picker, and jumps to the selected block.

## Features

- List Terraform resources from the current buffer using Telescope
- List Terraform variables from the current buffer using Telescope
- Jump directly to a selected block
- Works with standard Terraform `resource "<type>" "<name>"` and `variable "<name>"` declarations
- Minimal setup for existing Neovim configurations

## Requirements

> [!IMPORTANT]
>
> - Neovim `0.8` or later
> - [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "The-Infra-Company/tf.nvim",
  requires = { "nvim-telescope/telescope.nvim" }
}
```

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug "nvim-telescope/telescope.nvim"
Plug "The-Infra-Company/tf.nvim"
```

For other package managers, please refer to their documentation for adding plugins.

## Setup

Add the following to your Neovim configuration:

```lua
require("tfnvim")
```

## Usage

The plugin provides two commands:

1. `:TFResources`
   - Opens a Telescope picker listing Terraform resources in the current buffer
   - Selecting a resource jumps to its location in the current buffer
2. `:TFVariables`
   - Opens a Telescope picker listing Terraform variables in the current buffer
   - Selecting a variable jumps to its location in the current buffer

You can map the commands to key bindings for quicker access. For example:

```lua
vim.api.nvim_set_keymap("n", "<leader>tr", ":TFResources<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tv", ":TFVariables<CR>", { noremap = true, silent = true })
```
