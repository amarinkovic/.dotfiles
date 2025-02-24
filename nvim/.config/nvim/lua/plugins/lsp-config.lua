return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim",       opts = {} },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("fidget").setup({
        -- fixes fidget output coloring
        notification = {
          window = {
            winblend = 0,
          },
        },
      })

      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })

      local servers = {
        "lua_ls",
        "ts_ls",
        "solidity",
        "rust_analyzer",
        "jdtls",
        "yamlls",
        "bashls",
        "lemminx",
        "zls",
        "glsl_analyzer"
      }

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      --  LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      require("java").setup()

      local lspconfig = require("lspconfig")

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          capabilities = capabilities,
        })
      end

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

      -- Center screen to cursor when going to definition
      local original_definition_handler = vim.lsp.handlers["textDocument/definition"]
      vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
        original_definition_handler(err, result, ctx, config)
        vim.cmd("normal! zz")
      end

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        focusable = false, -- Make the window non-focusable
      })

      -- Auto popup diagnostic
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { scope = "cursor", focus = false })
        end,
      })
      vim.diagnostic.config({ virtual_text = true, float = { border = "rounded" } })

      -- general LSP key mappings
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
      vim.keymap.set({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
    end,
  },
}
