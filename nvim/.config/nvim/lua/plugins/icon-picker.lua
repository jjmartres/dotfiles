return {
  "ziontee113/icon-picker.nvim",
  keys = {
    {
      "<leader>fi",
      "<cmd>IconPickerNormal nerd_font emoji<cr>",
      desc = "Pick Icon/Emoji (Insert)",
    },

    {
      "<leader>fy",
      "<cmd>IconPickerYank nerd_font emoji<cr>",
      desc = "Pick Icon/Emoji (Yank)",
    },

    {
      "<C-i>",
      "<cmd>IconPickerInsert nerd_font emoji<cr>",
      mode = "i",
      desc = "Pick Icon/Emoji (Insert Mode)",
    },
  },

  config = function()
    require("icon-picker").setup({
      icons = {
        nerd_font = true,
        emoji = true,
      },
    })
  end,
}
