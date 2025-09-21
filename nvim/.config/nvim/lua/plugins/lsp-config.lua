return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      { "williamboman/mason.nvim", config = true, version = "^2.0.0", opts = { ui = { border = "rounded" } } },
      { "j-hui/fidget.nvim", opts = {} },
      { "saghen/blink.cmp" },
    },
    opts = {
      servers = {
        -- lua_ls = {},
        -- ts_ls = {},
        -- solidity_ls_nomicfoundation = {},
        jdtls = {},
        -- yamlls = {},
        -- bashls = {},
        -- lemminx = {},
        -- zls = {},
        -- glsl_analyzer = {},
        -- terraformls = {},
        -- gradle_ls = {},
      },
    },

    config = function(_, opts)
      require("fidget").setup({
        -- fixes fidget output coloring
        notification = {
          window = {
            winblend = 0,
          },
        },
      })

      require("java").setup()

      local lspconfig = require("lspconfig")

      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
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
    end,
  },
}
