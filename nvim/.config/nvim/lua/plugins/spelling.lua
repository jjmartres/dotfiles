return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "typos-ls", "harper-ls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typos_lsp = {},
        harper_lsp = {
          settings = {
            ["harper-ls"] = {
              -- harper-ls is English-only. French is handled by Neovim's built-in spell checker.
              dialect = "American",
              linters = {
                SpellCheck = true,
                SpelledNumbers = false,
                AnA = true,
                SentenceCapitalization = true,
                UnclosedQuotes = true,
                WrongQuotes = false,
                LongSentences = true,
                RepeatedWords = true,
                Spaces = true,
                Matcher = true,
                CorrectNumberSuffix = true
              },
              diagnosticSeverity = "hint",
            }
          }
        },
      },
    },
  },
}
