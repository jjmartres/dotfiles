return {
  {
    "zk-org/zk-nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    ft = "markdown",
    keys = {
      -- Création de notes
      { "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>" },
      { "<leader>zp", "<Cmd>ZkNew { group = 'projects', title = vim.fn.input('Project: ') }<CR>" },
      { "<leader>zi", "<Cmd>ZkNew { group = 'incidents', title = vim.fn.input('Incident: ') }<CR>" },
      { "<leader>zd", "<Cmd>ZkNew { group = 'daily' }<CR>" },

      -- Recherche
      { "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>" },
      { "<leader>zt", "<Cmd>ZkTags<CR>" },
      { "<leader>zg", "<Cmd>ZkNotes { match = { vim.fn.input('Search: ') } }<CR>" },

      -- Liens
      { "<leader>zl", "<Cmd>ZkInsertLink<CR>", mode = "n" },
      { "<leader>zl", ":'<,'>ZkInsertLinkAtSelection<CR>", mode = "v" },

      -- Navigation
      { "<leader>zb", "<Cmd>ZkBacklinks<CR>" },
      { "<leader>zo", "<Cmd>ZkLinks<CR>" },

      -- Création depuis sélection
      { "<leader>znt", ":'<,'>ZkNewFromTitleSelection<CR>", mode = "v" },
      { "<leader>znc", ":'<,'>ZkNewFromContentSelection<CR>", mode = "v" },
    },
    config = function()
      require("zk").setup({
        picker = "telescope",
        notebook_dir = vim.fn.expand("~/.notes"),
        lsp = {
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
          },
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      })

      -- Navigation dans les notes markdown
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()

          -- Suivre un lien avec Enter
          vim.keymap.set("n", "<CR>", function()
            vim.lsp.buf.definition()
          end, {
            buffer = bufnr,
            desc = "Follow link",
          })

          -- Retour arrière avec Backspace
          vim.keymap.set("n", "<BS>", "<C-o>", {
            buffer = bufnr,
            desc = "Go back",
          })
        end,
      })
    end,
  },
}
