return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    -- fixes fidget output coloring
    notification = {
      window = {
        winblend = 0,
      },
    },
  },
}
