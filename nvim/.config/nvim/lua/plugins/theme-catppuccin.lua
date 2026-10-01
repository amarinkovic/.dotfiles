vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

require("catppuccin").setup({
  transparent_background = true,
  -- Listed explicitly: auto_integrations only sees plugins already on disk when
  -- this runs (it's loaded first), and the compiled cache is keyed on this table,
  -- so plugins installed later would otherwise never get their highlights.
  integrations = {
    alpha = true,
    blink_cmp = true,
    dap = true,
    mason = true,
    neotree = true,
    noice = true,
    notify = true,
    render_markdown = true,
    treesitter = true,
    lsp_trouble = true,
    fidget = true,
    cmp = true,
    gitsigns = true,
    telescope = true,
    nvimtree = true,
    which_key = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
  },
  custom_highlights = function(colors)
    return {
      GitSignsCurrentLineBlame = { fg = colors.overlay1 },
      NonText = { fg = colors.overlay1 },
      LspInlayHint = { fg = colors.overlay1 },
      LspCodeLens = { fg = colors.overlay1 },
    }
  end,
})

vim.cmd.colorscheme("catppuccin")
