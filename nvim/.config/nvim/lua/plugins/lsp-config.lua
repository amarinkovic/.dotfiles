return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      { "williamboman/mason.nvim", config = true, version = "^1.0.0", opts = { ui = { border = "rounded" } } },
      { "williamboman/mason-lspconfig.nvim", version = "^1.0.0" },
      { "j-hui/fidget.nvim", opts = {} },
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

      local servers = {
        "lua_ls",
        "ts_ls",
        -- "solidity",
        "solidity_ls_nomicfoundation",
        "jdtls",
        "yamlls",
        "bashls",
        "lemminx",
        "zls",
        "glsl_analyzer",
        "terraformls",
        "gradle_ls",
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

      -- Center screen to cursor when going to definition
      local original_definition_handler = vim.lsp.handlers["textDocument/definition"]
      vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
        original_definition_handler(err, result, ctx, config)
        vim.cmd("normal! zz")
      end

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        focusable = false, -- Make the doc window non-focusable
      })

      -- Diagnostic Config, see :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      -- general LSP key mappings
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
      vim.keymap.set({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
    end,
  },
}
