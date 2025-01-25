return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      print("Loading nvim-cmp...") -- Debug print
      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      local kind_icons = {
        Text = "󰉿",
        Method = "m",
        Function = "󰊕",
        Constructor = "",
        Field = "",
        Variable = "󰆧",
        Class = "󰌗",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰇽",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰊄",
      }

      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert" },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
          ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" }, -- Add this as a fallback
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            print("Format function called!")          -- Debug print
            print("Entry source:", entry.source.name) -- Debug print
            print("Vim item kind:", vim_item.kind)    -- Debug print

            vim_item.kind = string.format("%s ", kind_icons[vim_item.kind] or "?")
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  },
}
