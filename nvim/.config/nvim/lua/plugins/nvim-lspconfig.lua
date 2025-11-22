return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      { "williamboman/mason.nvim", config = true, version = "^2.0.0", opts = { ui = { border = "rounded" } } },
      { "saghen/blink.cmp" },
    },
  },
}
