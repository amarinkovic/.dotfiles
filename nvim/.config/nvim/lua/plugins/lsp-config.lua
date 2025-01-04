return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "solidity",
          "rust_analyzer",
          "jdtls",
          "yamlls",
          "bashls",
        },
        automatic_installation = true,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.jdtls.setup({
        capabilities = capabilities,
      })

      lspconfig.solidity.setup({
        capabilities = capabilities,
      })

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              enable = false,
            },
          },
        },
      })

      lspconfig.yamlls.setup({
        capabilities = capabilities,
      })

      lspconfig.bashls.setup({
        capabilities = capabilities,
      })

      -- Center screen to cursor when going to definition
      local original_definition_handler = vim.lsp.handlers["textDocument/definition"]
      vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
        original_definition_handler(err, result, ctx, config)
        vim.cmd("normal! zz")
      end

      -- Auto popup diagnostic
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { scope = "cursor", focus = false })
        end,
      })
      vim.diagnostic.config({ virtual_text = true, float = { border = "rounded" } })

      -- general LSP key mappings
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "go", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
    end,
  },
}
