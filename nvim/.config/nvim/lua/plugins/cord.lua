return {
  "vyfor/cord.nvim",
  branch = "client-server",
  build = ":Cord fetch",
  config = function()
    require("cord").setup({
      editor = {
        client = "neovim",
        tooltip = "Neovim The Superior Text Editor",
      },
      display = {
        theme = "pastel", -- onyx or pastel
      },
      idle = {
        enabled = true,
        timeout = 300000,
        details = "Thinking 🤔",
      },
    })
  end,
}
