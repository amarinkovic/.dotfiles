return {
  "stevearc/conform.nvim",
  config = function()
    local prettier = { "prettierd", "prettier", stop_after_first = true }

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
        solidity        = prettier,
        css             = prettier,
        html            = prettier,
        json            = prettier,
        javascript      = prettier,
        javascriptreact = prettier,
        typescript      = prettier,
        typescriptreact = prettier,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>bf", "<cmd>lua require('conform').format()<CR>", { desc = "Buffer format" })
  end,
}
