return {
  "vyfor/cord.nvim",
  build = "./build || .\\build",
  event = "VeryLazy",
  opts = {},
  config = function()
    require("cord").setup({
      usercmds = true,
      editor = {
        client = "neovim",
        tooltip = "The Superior Text Editor",
      },
      display = {
        theme = "pastel", -- onyx or pastel
        show_repository = false,
      },
      lsp = {
        show_problem_count = true, -- Display number of diagnostics problems
        severity = 1, -- 1 = Error, 2 = Warning, 3 = Info, 4 = Hint
        scope = "workspace", -- buffer or workspace
      },
      idle = {
        enabled = true,
        timeout = 300000,
        details = "Thinking 🤔",
      },
      buttons = {
        { label = "Github", url = "https://github.com/amarinkovic" },
      },
      assets = {
        solidity = {
          -- icon = "https://images.seeklogo.com/logo-png/42/1/solidity-logo-png_seeklogo-426731.png?v=1957664661399450704",
          tooltip = "Solidity Smart Contract",
          -- text = "Writing in Solidity",
        },
      },
    })
  end,
}
