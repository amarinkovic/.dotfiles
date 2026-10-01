vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/scalameta/nvim-metals",
})

local metals_config = require("metals").bare_config()
metals_config.settings = {
  startMcpServer = true,
  mcpClient = "gemini",
  defaultBspToBuildTool = true,
  enableSemanticHighlighting = false,
  inlayHints = {
    byNameParameters = { enable = true },
    hintsInPatternMatch = { enable = true },
    implicitArguments = { enable = true },
    implicitConversions = { enable = true },
    inferredTypes = { enable = true },
    typeParameters = { enable = true },
  },
  serverVersion = "latest.snapshot",
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}
metals_config.on_attach = function(client, bufnr)
  -- your on_attach function
end

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
vim.keymap.set("n", "<leader>mc", ":Telescope metals commands<CR>", { desc = "Metals commands" })
