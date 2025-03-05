local presenceEnabled = os.getenv("NVIM_DISCORD_PRESENCE") == "true"

return {
  "vyfor/cord.nvim",
  build = "./build || .\\build",
  event = "VeryLazy",
  enabled = presenceEnabled,
  opts = {},
  config = function()
    require("cord").setup({
      usercmds = true,
      editor = {
        client = "neovim",
        tooltip = "The Superior Text Editor",
      },
      display = {
        theme = "onyx",             -- onyx or pastel
        show_repository = false,
      },
      lsp = {
        show_problem_count = true,  -- Display number of diagnostics problems
        severity = 1,               -- 1 = Error, 2 = Warning, 3 = Info, 4 = Hint
        scope = "workspace",        -- buffer or workspace
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
          icon = "https://procoders.tech/wp-content/uploads/2022/12/How_to_Find_a_Solidity_Developer_for_Hire_Comprehensive_Guide.png",
          tooltip = "Solidity Smart Contract",
          -- text = "Writing Solidity",
        },
        zig = {
          icon = "https://programming.dev/pictrs/image/d9362f3f-d7a2-4837-8fef-47bc92ccc91e.png",
          tooltip = "Zig",
          -- text = "Writing Zig",
        },
        rust = {
          icon = "https://www.techzine.eu/wp-content/uploads/2024/11/Rust_programming_language_black_logo.svg_.jpg",
          tooltip = "Rust",
        },
      },
    })
  end,
}
