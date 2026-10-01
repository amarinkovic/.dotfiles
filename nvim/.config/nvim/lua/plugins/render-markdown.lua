vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

---@module 'render-markdown'
require("render-markdown").setup({
  latex = {
    -- Formulas are converted to 2D monospace Unicode by utftex
    -- (`brew install utftex`), which stacks fractions and draws real ceiling
    -- and cases delimiters. latex2text stays as a fallback, but it flattens
    -- everything onto one line.
    converter = { "utftex", "latex2text" },
    position = "above",
    top_pad = 1,
  },
})

vim.keymap.set("n", "<leader>md", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle markdown rendering" })
