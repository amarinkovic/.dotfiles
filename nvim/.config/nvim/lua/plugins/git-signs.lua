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
    current_line_blame_opts = { delay = 100, },
    current_line_blame_formatter = '     <author>, <author_time:%R> - <summary> ',
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
}
