return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find by file name" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find with grep live" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
      vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
      vim.keymap.set("n", "<leader>qf", "<cmd>copen<CR>", { desc = "Show quick-fix list" })
      vim.keymap.set("n", "<leader>qq", "<cmd>cclose<CR>", { desc = "Close quick-fix list" })
      vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next in quick-fix list" })
      vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous in quick-fix list" })
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
