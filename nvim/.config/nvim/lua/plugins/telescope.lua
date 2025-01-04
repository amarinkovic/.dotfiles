return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find file by name" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Files grep live" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
      vim.keymap.set("n", "<leader>qf", "<cmd>copen<CR>", { desc = "Show quick fix list" })
      vim.keymap.set("n", "<leader>qq", "<cmd>cclose<CR>", { desc = "Close quick fix list" })
      vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Go to next in quick fix list" })
      vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Go to previous in quick fix list" })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
