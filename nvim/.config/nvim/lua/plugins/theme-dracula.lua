return {
  "Mofiqul/dracula.nvim",
  name = "dracula",
  enabled = false,
  config = function()
    require("dracula").setup({})
    -- vim.cmd.colorscheme("dracula")
  end,
}
