vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })

require("fidget").setup({
  -- fixes fidget output coloring
  notification = {
    window = {
      winblend = 0,
    },
  },
})
