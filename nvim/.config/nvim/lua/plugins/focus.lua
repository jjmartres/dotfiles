return {
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>z", false },
      { "<leader>m", "<cmd>ZenMode<cr>" },
    },
    opts = {
      window = {
        width = 120,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
      },
    },
  },
}
