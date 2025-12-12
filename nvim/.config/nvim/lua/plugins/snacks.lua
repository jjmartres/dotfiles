return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })
    end,
    opts = {
      dashboard = {
        enabled = true,
        pane_gap = 20,
        width = 80,
        preset = {
          pick = nil,
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            {
              icon = "󰺮",
              key = "g",
              desc = "Find Text",
              action = ":lua Snacks.dashboard.pick('live_grep')",
            },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            -- {
            --   icon = " ",
            --   key = "x",
            --   desc = "Lazy Extras",
            --   action = ":LazyExtras",
            --   enabled = package.loaded.lazy ~= nil,
            -- },
            -- {
            --   icon = " ",
            --   key = "h",
            --   desc = "Lazy Health",
            --   action = ":LazyHealth",
            --   enabled = package.loaded.lazy ~= nil,
            -- },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
                                                      
               ████ ██████           █████      ██
              ███████████             █████ 
              █████████ ███████████████████ ███   ███████████
             █████████  ███    █████████████ █████ ██████████████
            █████████ ██████████ █████████ █████ █████ ████ █████
          ███████████ ███    ███ █████████ █████ █████ ████ █████
         ██████  █████████████████████ ████ █████ █████ ████ ██████
      ]],
        },
        sections = {
          { section = "header" },
          {
            pane = 1,
            {
              section = "keys",
              indent = 1,
              padding = 1,
            },
            function()
              local in_git = Snacks.git.get_root() ~= nil
              local cmds = {
                {
                  icon = " ",
                  title = "Git status",
                  cmd = "git --no-pager diff --stat -B -M -C",
                  height = 3,
                },
                {
                  icon = " ",
                  title = "Merge or pull requests",
                  -- fish fonction
                  cmd = "handle_git_remote",
                  height = 3,
                },
                {
                  icon = "󰆘",
                  title = "Fortune cookie",
                  cmd = "fortune -e",
                  height = 2,
                },
              }
              return vim.tbl_map(function(cmd)
                return vim.tbl_extend("force", {
                  section = "terminal",
                  enabled = in_git,
                  padding = 1,
                  ttl = 5 * 60,
                  indent = 3,
                }, cmd)
              end, cmds)
            end,
          },
          -- {
          --   pane = 2,
          --   {
          --     function()
          --       local in_git = Snacks.git.get_root() ~= nil
          --       local cmds = {
          --         -- Dedicated to github
          --         -- {
          --         --   title = "Open Issues",
          --         --   cmd = "gh issue list -L 3",
          --         --   key = "i",
          --         --   action = function()
          --         --     vim.fn.jobstart("gh issue list --web", { detach = true })
          --         --   end,
          --         --   icon = " ",
          --         --   height = 7,
          --         -- },
          --         -- {
          --         --   icon = " ",
          --         --   title = "Open PRs",
          --         --   cmd = "gh pr list -L 3",
          --         --   key = "P",
          --         --   action = function()
          --         --     vim.fn.jobstart("gh pr list --web", { detach = true })
          --         --   end,
          --         --   height = 7,
          --         -- },
          --         -- Dedicated to gitlab
          --         {
          --           icon = " ",
          --           title = "Assigned MRs",
          --           cmd = "glab mr list --assignee=$GITLAB_USER_NAME",
          --           height = 7,
          --         },
          --         {
          --           icon = " ",
          --           title = "Open MRs",
          --           cmd = "glab mr list --author=$GITLAB_USER_NAME",
          --           height = 7,
          --         },
          --       }
          --       return vim.tbl_map(function(cmd)
          --         return vim.tbl_extend("force", {
          --           section = "terminal",
          --           enabled = in_git,
          --           padding = 1,
          --           ttl = 5 * 60,
          --           indent = 3,
          --         }, cmd)
          --       end, cmds)
          --     end,
          --   },
          -- },
          { section = "startup" },
        },
      },
      lazzygit = { enabled = true },
      terminal = { enabled = true },
      zen = {
        enabled = true,
        toggles = {
          ufo = true,
          dim = true,
          git_signs = false,
          diagnostics = false,
          line_number = false,
          relative_number = false,
          signcolumn = "no",
          indent = false,
        },
      },
    },
    keys = {
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
        mode = "n",
      },
      {
        "<c-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Toggle Terminal",
      },
    },
  },
}
