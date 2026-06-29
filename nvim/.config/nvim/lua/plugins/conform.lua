return {
  "stevearc/conform.nvim",
  config = function()
    local webFormatter = { "oxfmt" }

    require("conform").setup({
      format_on_save = false,
      formatters_by_ft = {
        lua             = { "stylua" },
        rust            = { "rustfmt", lsp_format = "fallback" },
        python          = { "isort", "black" },
        java            = { "checkstyle", lsp_format = "fallback" },
        groovy          = { "npm-groovy-lint", lsp_format = "fallback" },
        make            = { "checkmake", lsp_format = "fallback" },
        zig             = { "zigfmt", lsp_format = "fallback" },
        solidity        = { "prettierd", "prettier", stop_after_first = true },
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

    vim.keymap.set({ "n", "v" }, "<leader>bf", "<cmd>lua require('conform').format()<CR>", { desc = "Buffer format" })
  end,
}
