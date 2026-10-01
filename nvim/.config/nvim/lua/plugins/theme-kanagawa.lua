-- disabled: flip to true (and set the colorscheme below) to use
local enabled = false
if not enabled then
  return
end

vim.pack.add({ { src = "https://github.com/rebelot/kanagawa.nvim", name = "kanagawa" } })

require("kanagawa").setup({
  transparent = false,
  theme = "wave", -- wave, dragon, lotus
  background = {
    dark = "wave",
    light = "lotus",
  },
})
-- vim.cmd.colorscheme("kanagawa")
