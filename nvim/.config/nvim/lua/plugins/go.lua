return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if not opts.servers then
        opts.servers = {}
      end

      -- Get the utility functions for root detection
      local lspconfig = require("lspconfig.util")

      -- Define the root detection logic for gopls
      local find_gopls_root = function(fname)
        -- 1. Check for 'go.mod' in standard and common nested locations
        local go_mod_root = lspconfig.root_pattern(
          "go.mod", -- Standard root
          "app/go.mod", -- Nested under app/
          "src/go.mod" -- Nested under src/
        )(fname)

        -- If a Go module root is found, return it immediately.
        if go_mod_root then
          return go_mod_root
        end

        -- 2. FALLBACK: Find the Git root using vim.fs.find (Recommended)

        -- Start by finding the .git path
        -- If no .git is found, vim.fs.find returns {}, so [1] will be nil.
        local git_path = vim.fs.find(".git", { path = fname, upward = true })[1]

        -- Safely convert the .git path to the actual root directory path
        if git_path then
          -- If git_path is found (a string), return its containing directory
          return vim.fs.dirname(git_path)
        end

        -- If no root is found at all, return nil (or the path of the current file)
        -- Returning nil tells nvim-lspconfig to look elsewhere or not start the server.
        return nil
      end

      -- Configure the gopls language server
      opts.servers.gopls = {
        -- Set the custom root detection function
        root_dir = find_gopls_root,

        -- gopls specific settings
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true,
            gofumpt = true,
          },
        },
      }

      return opts
    end,
  },
}
