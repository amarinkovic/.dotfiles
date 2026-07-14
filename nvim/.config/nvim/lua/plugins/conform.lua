return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  -- stylua: ignore
  keys = {
    { "<leader>bf", function() require("conform").format() end, mode = { "n", "v" }, desc = "Buffer format" },
  },
  config = function()
    local webFormatter = { "oxfmt" }

    require("conform").setup({
      format_on_save = false,
      formatters_by_ft = {
        lua             = { "stylua" },
        rust            = { "rustfmt", lsp_format = "fallback" },
        python          = { "isort", "black" },
        java            = { "google-java-format", lsp_format = "fallback" },
        groovy          = { "npm-groovy-lint", lsp_format = "fallback" },
        zig             = { "zigfmt", lsp_format = "fallback" },
        solidity        = { "forge_fmt" },
        terraform       = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        css             = webFormatter,
        html            = webFormatter,
        json            = webFormatter,
        javascript      = webFormatter,
        javascriptreact = webFormatter,
        typescript      = webFormatter,
        typescriptreact = webFormatter,
      },
    })
  end,
}
