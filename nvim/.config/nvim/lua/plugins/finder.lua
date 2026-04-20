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
    keys = {
      {
        "<leader>fk",
        function()
          local mode_colors = {
            n = "TelescopeResultsIdentifier",
            i = "TelescopeResultsSpecialComment",
            v = "TelescopeResultsVariable",
            x = "TelescopeResultsVariable",
            o = "TelescopeResultsOperator",
            c = "TelescopeResultsConstant",
            t = "TelescopeResultsField",
          }
          local mode_labels = {
            n = "NORMAL",
            i = "INSERT",
            v = "VISUAL",
            x = "VISUAL",
            o = "OPEND ",
            c = "CMDLINE",
            t = "TERM  ",
          }

          require("telescope.builtin").keymaps({
            results_title = "Keymaps",
            lhs_filter = function(lhs)
              return not vim.tbl_contains({ "MouseMove", "<LeftMouse>", "<ScrollWheelDown>", "<ScrollWheelUp>" }, lhs)
            end,
            layout_strategy = "horizontal",
            layout_config = { width = 0.92, height = 0.85, preview_width = 0.45 },
            entry_maker = function(entry)
              local mode = entry.mode or "n"
              local lhs = entry.lhs or ""
              local desc = entry.desc or entry.rhs or ""
              local label = mode_labels[mode] or mode

              return {
                value = entry,
                ordinal = label .. " " .. lhs .. " " .. desc,
                display = function(_)
                  local displayer = require("telescope.pickers.entry_display").create({
                    separator = " ",
                    items = {
                      { width = 7 },
                      { width = 20 },
                      { remaining = true },
                    },
                  })
                  return displayer({
                    { label, mode_colors[mode] or "TelescopeResultsComment" },
                    { lhs,   "TelescopeResultsNumber" },
                    { desc,  "TelescopeResultsComment" },
                  })
                end,
              }
            end,
          })
        end,
        desc = "Keymaps",
      },
    },
  },
}
