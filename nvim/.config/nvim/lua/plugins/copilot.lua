vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" })

require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  filetypes = {
    ["*"] = true,
    -- disable for certain filetypes
    gitcommit = false,
    gitrebase = false,
    TelescopePrompt = false,
    help = false,
    svn = false,
    hgcommit = false,
  },
})
