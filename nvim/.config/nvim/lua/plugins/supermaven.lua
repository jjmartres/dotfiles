return {
  {
    "supermaven-inc/supermaven-nvim",
    lazy = false,
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<leader>sa",
          clear_suggestion = "<leader>sc",
        },
      })
    end,
  },
}
