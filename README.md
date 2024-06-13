# JS Playground for Neovim

A Neovim plugin that allows you to run JavaScript code in a playground-like environment. This plugin will open a window on the right side, execute the current JavaScript file using Node.js, and display the output. It also supports automatic execution and result update upon saving the file.

![录屏2024-06-13 11 04 54](https://github.com/try-to-fly/js-playground.nvim/assets/16008258/c7856310-4dac-46a2-8329-63c2e491bae3)

## Features

- Opens a window on the right side to display JavaScript execution results.
- Reuses the window if it is already opened.
- Only updates results when the window is open.
- Displays execution time using Neovim's notification system.
- Syntax highlighting for JavaScript output.
- Handles and displays error messages.

## Installation

### Using LazyVim

To install using LazyVim, add the following configuration to your LazyVim setup:

```lua
return {
  "try-to-fly/js-playground.nvim",
  config = function()
    require("js_playground").setup_autocmds()
    vim.api.nvim_set_keymap(
      "n",
      "<leader>r",
      ":lua require('js_playground').run_js_code()<CR>",
      { noremap = true, silent = true }
    )
  end,
}
```

## Usage

1. **Run JavaScript Code Manually**: Press `<leader>r` to execute the current JavaScript file and display the results in the right-side window.

2. **Automatic Execution on Save**: When the right-side window is open, saving a JavaScript file will automatically execute the code and update the results.

## Configuration

### Key Bindings

By default, the plugin uses the following key binding:

- `<leader>r`: Run the current JavaScript file and display the results.

### Example Configuration in `init.lua`

```lua
require('js_playground').setup_autocmds()

vim.api.nvim_set_keymap('n', '<leader>r', ":lua require('js_playground').run_js_code()<CR>", { noremap = true, silent = true })
```
