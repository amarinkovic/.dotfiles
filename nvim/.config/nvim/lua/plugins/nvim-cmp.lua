return {
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lua",

      "hrsh7th/cmp-path",
      "nvim-tree/nvim-web-devicons",
      "xzbdmw/colorful-menu.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      require("nvim-web-devicons").setup()
      cmp.setup({
        performance = {
          enabled = true,
          debounce = 0, -- 60ms
          throttle = 0, -- 30ms
          -- max_view_entries = 30,
        },
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

        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            local menu_icons = {
              nvim_lsp = "λ",
              luasnip = "󰯁",
              buffer = "",
              path = "󰘍",
              nvim_lua = "Π",
            }

            item.menu = menu_icons[entry.source.name]

            -- Placed here as path only needs source and icon
            if vim.tbl_contains({ "path" }, entry.source.name) then
              local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
              if icon then
                item.kind = icon .. " " .. item.kind
                item.kind_hl_group = hl_group
                return item
              end
            end

            -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#basic-customisations
            local kind_icons = {
              Text = " ",
              Method = " ",
              Function = "ƒ ",
              Constructor = " ",
              Field = "󰜢 ",
              Variable = " ",
              Class = " ",
              Interface = "󰜰 ", -- " ",
              Module = " ", -- " ",
              Property = " ", -- " ",
              Unit = " ",
              Value = "󰎠 ",
              Enum = " ",
              EnumMember = " ",
              Keyword = "󰌆 ", -- " ",
              Snippet = " ", -- " ",
              Color = " ",
              File = " ",
              Folder = " ",
              Reference = " ", -- " ",
              Constant = " ", -- " ",
              Struct = " ", -- " ",
              Event = " ",
              Operator = " ",
              TypeParameter = " ",
            }

            item.kind = (kind_icons[item.kind] or "") .. item.kind

            -- CUSTOM TREESITTER BASED COLORFUL CMP MENU
            local highlights_info = require("colorful-menu").cmp_highlights(entry)
            if highlights_info ~= nil then
              item.abbr_hl_group = highlights_info.highlights
              item.abbr = highlights_info.text
            end

            return item
          end,
        },

        -- -------------------------------------------END
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          -- { name = "minuet" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "treesitter" },
        }),
      })
    end,
  },
}
