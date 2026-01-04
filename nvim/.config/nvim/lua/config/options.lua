-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.wrap = true
vim.g.codeium_os = "Darwin"
vim.g.codeium_arch = "arm64"

-- Keymaps for the spell checker:
-- *   z=: Show spelling suggestions.
-- *   ]s: Move to the next misspelled word.
-- *   [s: Move to the previous misspelled word.
-- *   zg: Add the word under the cursor to your dictionary.
-- *   <leader>ss: Toggle the spell checker on and off.
vim.opt.spell = true
vim.opt.spelllang = { "en", "fr" }
