return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
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
  end,
}
