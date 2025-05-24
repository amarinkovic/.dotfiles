return {
  "saghen/blink.cmp",
  version = "1.*",
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = "default" },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      ghost_text = {
        enabled = true,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounder" },
      },
      menu = {
        border = "rounded",
        scrollbar = false,
        draw = {
          treesitter = { "lsp" },
          columns = {
            { "label", width = { fill = true } },
            { "kind_icon", width = { min = 2 } },
            { "kind", width = { min = 10 } },
            { "source_name", width = { min = 12 } },
            -- { "kind_icon" },
            -- { "label", "label_description", gap = 1 },
            -- { "label_description", gap = 1 },
            -- { "kind", gap = 1 },
            -- { "source_name", gap = 1 },
          },
          components = {
            kind_icon = {
              ellipsis = false,
              width = { fill = true },
              text = function(ctx)
                local kind_icons = {
                  Copilot = "",
                  Text = "",
                  Method = "󰆧",
                  Function = "󰊕",
                  Constructor = "",
                  Field = "󰇽",
                  Variable = "󰂡",
                  Class = "󰠱",
                  Interface = "",
                  Module = "",
                  Property = "󰜢",
                  Unit = "",
                  Value = "󰎠",
                  Enum = "",
                  Keyword = "󰌋",
                  Snippet = "",
                  Color = "󰏘",
                  File = "󰈙",
                  Reference = "",
                  Folder = "󰉋",
                  EnumMember = "",
                  Constant = "󰏿",
                  Struct = "",
                  Event = "",
                  Operator = "󰆕",
                  TypeParameter = "󰅲",
                }

                local icon = kind_icons[ctx.kind]
                if icon == nil then
                  icon = ctx.kind_icon
                end
                return icon
              end,
            },
            label = {
              hl = function(ctx)
                return ctx.is_selected and "CmpItemAbbrMatch" or "CmpItemAbbr"
              end,
            },
            kind = {
              hl = function(ctx)
                return "CmpItemKind" .. ctx.kind
              end,
            },
          },
        },
      },
    },

    signature = { window = { border = "rounded" } },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      -- default = { "lsp", "path", "buffer" },
      default = { "lsp" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
