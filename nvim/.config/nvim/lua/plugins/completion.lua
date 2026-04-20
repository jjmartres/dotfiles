return {
  {
    "Saghen/blink.cmp",
    dependencies = {
      "olimorris/codecompanion.nvim",
      "saghen/blink.compat",
      "supermaven-inc/supermaven-nvim",
    },
    event = "InsertEnter",
    opts = {
      enabled = function()
        return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
      end,
      completion = {
        accept = {
          auto_brackets = {
            kind_resolution = {
              blocked_filetypes = { "typescriptreact", "javascriptreact", "vue", "codecompanion" },
            },
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "supermaven" },
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
        providers = {
          supermaven = {
            name = "supermaven",
            module = "blink.compat.source",
            score_offset = 100,
          },
        },
      },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    lazy = true,
    opts = {
      disable_inline_completion = true,
    },
  },
}
