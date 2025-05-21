return {
  "stevearc/conform.nvim",
  opts = {},
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        solidity = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        python = { "isort", "black" },
        java = { "checkstyle", lsp_format = "fallback" },
        groovy = { "npm-groovy-lint", lsp_format = "fallback" },
        make = { "checkmake", lsp_format = "fallback" },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>bf", "<cmd>lua require('conform').format()<CR>", { desc = "Buffer format (none-ls)" })
  end,
}
