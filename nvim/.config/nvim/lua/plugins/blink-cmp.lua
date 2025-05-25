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
        },
      },
    },

    appearance = {
      nerd_font_variant = "normal",
      kind_icons = {
        Copilot = " ",
        Text = " ", -- "󰉿 ",
        Method = "󰊕 ",
        Function = "󰊕 ",
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
        Constant = "󰏿 ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
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
