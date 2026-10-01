vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
})

---@module 'dap-view'
---@type dapview.Config
require("dap-view").setup({
  auto_toggle = true,
  winbar = {
    default_section = "scopes",
  },
  windows = {
    position = "right",
    size = 0.35,
  },
})

vim.keymap.set("n", "<leader>DT", "<cmd>DapViewToggle<cr>", { desc = "DAP View Toggle" })
