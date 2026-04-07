return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Remove the clock from lualine (time is already shown in the Zellij session)
    opts.sections.lualine_z = {}
    return opts
  end,
}
