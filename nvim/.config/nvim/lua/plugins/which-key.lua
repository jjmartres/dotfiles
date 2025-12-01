return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.plugins = { spelling = true }
      opts.expand = 1
      opts.icons = {
        mappings = true,
        keys = {},
      }

      opts.defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["z"] = { name = "+zettelkasten" },
        ["m"] = { name = "+fold" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      }

      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>m", desc = "Zen Mode", icon = { icon = "󰚀", color = "purple" } },

        { "<leader>z", group = "zettelkasten", icon = { icon = "󱓷", color = "azure" } },

        { "<leader>zn", desc = "New note", icon = { icon = "󰈙", color = "green" } },
        { "<leader>zp", desc = "New project", icon = { icon = "󰉋", color = "blue" } },
        { "<leader>zi", desc = "New incident", icon = { icon = "󰀪", color = "red" } },
        { "<leader>zd", desc = "Daily note", icon = { icon = "󰃭", color = "cyan" } },

        { "<leader>zf", desc = "Find notes", icon = { icon = "󰈞", color = "yellow" } },
        { "<leader>zt", desc = "Find by tags", icon = { icon = "󰓹", color = "orange" } },
        { "<leader>zg", desc = "Grep notes", icon = { icon = "󰱼", color = "yellow" } },

        { "<leader>zl", desc = "Insert link", icon = { icon = "󰌷", color = "purple" } },
        { "<leader>zb", desc = "Backlinks", icon = { icon = "󰁍", color = "cyan" } },
        { "<leader>zo", desc = "Outgoing links", icon = { icon = "󰁔", color = "cyan" } },

        { "<leader>znt", desc = "Note from title", icon = { icon = "󰷈", color = "green" }, mode = "v" },
        { "<leader>znc", desc = "Note from content", icon = { icon = "󰷉", color = "green" }, mode = "v" },
      })

      return opts
    end,
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}
