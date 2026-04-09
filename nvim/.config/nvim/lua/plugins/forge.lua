return {
  {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    build = function()
      require("gitlab.server").build(true)
    end,
    config = function()
      require("gitlab").setup({
        port = 20136,
        log_path = vim.fn.stdpath("cache") .. "/gitlab.nvim.log",
        reviewer = "diffview",
        discussion_sign_and_diagnostic = {
          skip_resolved_discussion = true,
        },
      })
    end,
    keys = {
      { "<leader>glc", "<cmd>lua require('gitlab').choose_merge_request()<cr>", desc = "Choose MR" },
      { "<leader>glS", "<cmd>lua require('gitlab').start_review()<cr>", desc = "Start Review" },
      { "<leader>glr", "<cmd>lua require('gitlab').review()<cr>", desc = "Review Current Branch" },
      { "<leader>gls", "<cmd>lua require('gitlab').summary()<cr>", desc = "MR Summary" },
      { "<leader>glA", "<cmd>lua require('gitlab').approve()<cr>", desc = "Approve MR" },
      { "<leader>glR", "<cmd>lua require('gitlab').revoke()<cr>", desc = "Revoke Approval" },
      { "<leader>glm", "<cmd>lua require('gitlab').merge()<cr>", desc = "Merge MR" },
      { "<leader>glC", "<cmd>lua require('gitlab').create_mr()<cr>", desc = "Create MR" },
      { "<leader>gln", "<cmd>lua require('gitlab').create_note()<cr>", desc = "Create Note" },
      { "<leader>gld", "<cmd>lua require('gitlab').toggle_discussions()<cr>", desc = "Toggle Discussions" },
      { "<leader>glp", "<cmd>lua require('gitlab').pipeline()<cr>", desc = "Pipeline Status" },
      { "<leader>glo", "<cmd>lua require('gitlab').open_in_browser()<cr>", desc = "Open in Browser" },
      { "<leader>glu", "<cmd>lua require('gitlab').copy_mr_url()<cr>", desc = "Copy MR URL" },
      { "<leader>glaa", "<cmd>lua require('gitlab').add_assignee()<cr>", desc = "Add Assignee" },
      { "<leader>glad", "<cmd>lua require('gitlab').delete_assignee()<cr>", desc = "Delete Assignee" },
      { "<leader>glra", "<cmd>lua require('gitlab').add_reviewer()<cr>", desc = "Add Reviewer" },
      { "<leader>glrd", "<cmd>lua require('gitlab').delete_reviewer()<cr>", desc = "Delete Reviewer" },
    },
  },
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Octo",
    opts = {
      picker = "telescope",
      use_local_fs = false,
      enable_builtin = true,
    },
    keys = {
      { "<leader>gop", "<cmd>Octo pr list<cr>", desc = "List PRs" },
      { "<leader>goi", "<cmd>Octo issue list<cr>", desc = "List Issues" },
      { "<leader>gor", "<cmd>Octo review start<cr>", desc = "Start Review" },
      { "<leader>gos", "<cmd>Octo review submit<cr>", desc = "Submit Review" },
      { "<leader>goc", "<cmd>Octo comment add<cr>", desc = "Add Comment" },
      { "<leader>goa", "<cmd>Octo pr create<cr>", desc = "Create PR" },
      { "<leader>goo", "<cmd>Octo pr browser<cr>", desc = "Open PR in Browser" },
    },
  },
}
