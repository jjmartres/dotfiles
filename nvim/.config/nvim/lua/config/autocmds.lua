-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable spell checking in all terminal panes
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
  end,
  desc = "Disable spell in terminal panes",
})

-- Disable spell checking in OpenCode buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "opencode",
  callback = function()
    vim.opt_local.spell = false
  end,
  desc = "Disable spell in OpenCode buffers",
})
