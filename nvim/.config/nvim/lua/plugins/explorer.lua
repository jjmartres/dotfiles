return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        natural_sort_order = true,
        is_always_hidden = function(name, _)
          return name == ".git" or name == ".DS_Store"
        end,
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = 40,
      },
      keymaps = {
        ["<C-c>"] = false,
        ["q"] = "actions.close",
      },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>-", "<cmd>Oil --float<cr>", desc = "Open parent directory (float)" },
    },
  },
}
