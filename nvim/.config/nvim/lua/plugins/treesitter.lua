return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      -- ensure_installed = { "lua", "javascript", "rust", "scala", "solidity" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
    vim.filetype.add({
      pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
    })

    vim.filetype.add({
      extension = { mdx = "mdx" },
    })
    vim.treesitter.language.register("markdown", "mdx")
  end,
}
