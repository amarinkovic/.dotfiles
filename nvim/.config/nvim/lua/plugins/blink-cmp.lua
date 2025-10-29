return {
  "saghen/blink.cmp",
  version = "1.*",
  lazy = true,
  dependencies = {
    { "giuxtaposition/blink-cmp-copilot" },
  },
  opts = {
    keymap = {
      preset = "default",
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Esc>"] = { "cancel", "fallback" },
      ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
      ["<PageDown>"] = { "scroll_documentation_down", "fallback" },
    },

    completion = {
      ghost_text = { enabled = false },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },

      menu = {
        scrollbar = false,
        draw = {
          treesitter = { "lsp" },
          columns = {
            { "label", width = { fill = true } },
            { "kind_icon", width = { min = 2 } },
            { "kind", width = { min = 10 } },
          },
        },
      },
    },

    appearance = {
      nerd_font_variant = "HackNerdFont",

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

    sources = {
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100, --higher number, higher prioroty
          async = true,
        },
      },
      default = { "copilot", "lsp", "path" },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
  },
  opts_extend = { "sources.default" },
}
