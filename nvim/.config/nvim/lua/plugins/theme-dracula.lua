-- disabled: flip to true (and set the colorscheme below) to use
local enabled = false
if not enabled then
  return
end

vim.pack.add({ { src = "https://github.com/Mofiqul/dracula.nvim", name = "dracula" } })

require("dracula").setup({})
-- vim.cmd.colorscheme("dracula")
