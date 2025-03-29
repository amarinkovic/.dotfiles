local presenceEnabled = os.getenv("NVIM_DISCORD_PRESENCE") == "true"

return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  event = "VeryLazy",
  enabled = presenceEnabled,
  config = function()
    require("cord").setup({
      usercmds = true,
      editor = {
        client = "neovim",
        tooltip = "The Superior Text Editor",
      },
      display = {
        theme = "default",
        flavour = "dark",
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
        -- details = "Thinking 🤔",
      },
      buttons = {
        { label = "Github", url = "https://github.com/amarinkovic" },
      },
      assets = {
        solidity = {
          icon = "https://procoders.tech/wp-content/uploads/2022/12/How_to_Find_a_Solidity_Developer_for_Hire_Comprehensive_Guide.png",
          tooltip = "Solidity Smart Contract",
          text = "Writing Solidity Smart Contracts",
        },
      },
    })
  end,
}
