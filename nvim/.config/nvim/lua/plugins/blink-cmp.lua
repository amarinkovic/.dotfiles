return {
  "saghen/blink.cmp",
  version = "1.*",
  Lazy = true,
  opts = {
    keymap = {
      preset = "default",
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Esc>"] = { "hide", "fallback" },
      ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
      ["<PageDown>"] = { "scroll_documentation_down", "fallback" },
    },

    appearance = { nerd_font_variant = "HackNerdFont" },

    completion = {
      ghost_text = { enabled = true },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
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

    sources = {
      default = { "lsp" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
