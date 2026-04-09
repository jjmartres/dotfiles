return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    opts = {
      defaults = {
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "%.terraform/",
          "vendor/",
          "%.DS_Store",
        },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { preview_width = 0.55 },
          width = 0.87,
          height = 0.80,
        },
        prompt_prefix = " ",
        selection_caret = " ",
        sorting_strategy = "ascending",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },
}
