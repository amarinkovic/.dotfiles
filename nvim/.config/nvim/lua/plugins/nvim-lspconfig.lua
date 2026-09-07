return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      { "mason-org/mason.nvim", config = true, version = "^2.0.0", opts = { ui = { border = "rounded" } } },
      { "saghen/blink.cmp" },
    },
    config = function()
      -- Centralize blink.cmp capabilities so ALL servers (including those
      -- started via vim.lsp.enable() in lsp/) inherit them automatically.
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Neovim advertises { utf-8, utf-16, utf-32 } and the server picks the first it
      -- supports, so servers that speak utf-8 (tsgo, gopls) negotiate utf-8 while
      -- utf-16-only ones (most node servers, null-ls) stay on utf-16. Two such clients
      -- on one buffer interpret column numbers differently -- that is the "Position
      -- Encodings" warning in ":checkhealth vim.lsp". Ask for utf-16 everywhere: it is
      -- the only encoding the LSP spec makes mandatory, so every server can honour it.
      -- (vim.lsp merges this over its own list with tbl_deep_extend, which merges lists
      -- index-wise, so the advertised list ends up { utf-16, utf-16, utf-32 } -- the
      -- leading entry is what negotiation uses.)
      capabilities.general = capabilities.general or {}
      capabilities.general.positionEncodings = { "utf-16" }

      vim.lsp.config("*", {
        capabilities = capabilities,
      })
    end,
  },
}
