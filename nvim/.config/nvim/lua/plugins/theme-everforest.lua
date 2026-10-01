-- disabled: flip to true (and set the colorscheme below) to use
local enabled = false
if not enabled then
  return
end

vim.pack.add({ { src = "https://github.com/sainnhe/everforest", name = "everforest" } })

vim.g.everforest_background = "hard" -- hard, medium, soft
vim.g.everforest_better_performance = 1
-- vim.cmd.colorscheme("everforest")
