local function projects_file()
  return os.getenv("NVIM_PROJECTS_FILE")
end

local function load_projects()
  local items = {}
  local f = io.open(projects_file(), "r")
  if not f then
    return items
  end
  for line in f:lines() do
    line = vim.trim(line)
    if line ~= "" and not line:match("^#") then
      local expanded = vim.fn.expand(line)
      if vim.fn.isdirectory(expanded) == 1 then
        local name = vim.fn.fnamemodify(expanded, ":t")
        local parent = vim.fn.fnamemodify(expanded, ":h:t")
        table.insert(items, {
          text = parent .. "/" .. name,
          file = expanded,
        })
      end
    end
  end
  f:close()
  return items
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = { enabled = true },
    },
    keys = {
      {
        "<leader>fp",
        function()
          Snacks.picker({
            title = "Projects",
            items = load_projects(),
            format = function(item)
              return { { item.text, "SnacksPickerFile" } }
            end,
            confirm = function(picker, item)
              picker:close()
              if item then
                vim.fn.chdir(item.file)
                Snacks.picker.files({ cwd = item.file })
              end
            end,
          })
        end,
        desc = "Projects",
      },
    },
  },
}
