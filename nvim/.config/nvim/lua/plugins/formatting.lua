return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      fish = { "fish_indent" },
      go = { "gofumpt" },
      json = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      sh = { "shfmt" },
      toml = { "taplo" },
      yaml = { "yamlfmt" },
    },
    formatters = {
      yamlfmt = {
        command = "yamlfmt",
        args = { "-formatter", "basic", "-indentless_arrays=true" },
      },
      shfmt = {
        args = { "-i", "2", "-ci" },
      },
    },
  },
}
