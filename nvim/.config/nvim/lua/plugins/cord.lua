if os.getenv("NVIM_DISCORD_PRESENCE") ~= "true" then
  return
end

-- `:Cord update` runs from the PackChanged hook in init.lua
vim.pack.add({ "https://github.com/vyfor/cord.nvim" })

require("cord").setup({
  editor = {
    client = "neovim",
    tooltip = "The Superior Text Editor",
  },
  display = {
    theme = "default",
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
