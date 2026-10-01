vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/MunifTanjim/nui.nvim",
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
})

require("neo-tree").setup({
  filesystem = {
    use_libuv_file_watcher = true,
    filtered_items = {
      hide_dotfiles = true,
      hide_by_name = {
        ".git",
        ".DS_Store",
      },
      always_show = {
        ".env",
      },
    },
  },
})
vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", { desc = "Reveal neotree" })
