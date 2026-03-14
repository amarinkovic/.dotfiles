return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      { "williamboman/mason.nvim", config = true, version = "^2.0.0", opts = { ui = { border = "rounded" } } },
      { "saghen/blink.cmp" },
    },
    config = function()
      -- Centralize blink.cmp capabilities so ALL servers (including those
      -- started via vim.lsp.enable() in lsp/) inherit them automatically.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
    end,
  },
}
