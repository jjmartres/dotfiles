return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = { "InsertLeave", "TextChanged" },
    },
    condition = function(buf)
      local fn = vim.fn
      local filepath = fn.expand("#" .. buf .. ":p") -- Get full path
      local zk_dir = os.getenv("ZK_NOTEBOOK_DIR")

      -- Autosave for zk working-sessions notes
      if
        zk_dir
        and filepath:match("^" .. fn.escape(zk_dir, "/"))
        and filepath:match("working-sessions")
        and filepath:match("%.md$")
      then
        return true
      end
      return false
    end,
    write_all_buffers = false,
    debounce_delay = 60000,
  },
}
