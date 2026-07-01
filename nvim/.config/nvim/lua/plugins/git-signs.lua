return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    { "<leader>gb", "<cmd>Gitsigns blame<cr>", desc = "Gitsigns blame" },
    { "<leader>gl", "<cmd>Gitsigns blame_line<cr>", desc = "Gitsigns blame line" },
    { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Gitsigns diffthis" },
  },
  opts = {
    current_line_blame = true,
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
}
