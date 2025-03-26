return {
  "stevearc/conform.nvim",
  opts = {},
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- python = { "isort", "black" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        solidity = { "prettierd", "prettier", stop_after_first = true },
      },
    })

    vim.keymap.set("n", "<leader>bf", "<cmd>lua require('conform').format()<CR>", { desc = "Buffer format (none-ls)" })
  end,
}
