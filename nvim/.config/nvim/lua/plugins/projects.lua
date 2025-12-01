return {
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      patterns = {
        ".git",
        "Makefile",
        "package.json",
        "Componentfile",
        ".terraform-version",
        "skaffold.yaml",
        "Chart.yaml",
        "values.yaml",
        "README.md",
        "CHANGELOG.md",
      },
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("project_nvim").setup(opts)
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("projects")
      end)
    end,
    keys = {
      { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
    },
  },
}
