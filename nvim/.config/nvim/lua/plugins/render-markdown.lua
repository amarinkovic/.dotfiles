return {
  "MeanderingProgrammer/render-markdown.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>md", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown rendering" },
  },
  ---@module 'render-markdown'
  opts = {
    enabled = false,
    latex = {
      -- Formulas are converted to 2D monospace Unicode by utftex
      -- (`brew install utftex`), which stacks fractions and draws real ceiling
      -- and cases delimiters. latex2text stays as a fallback, but it flattens
      -- everything onto one line.
      converter = { "utftex", "latex2text" },
      position = "above",
      top_pad = 1,
    },
  },
}
