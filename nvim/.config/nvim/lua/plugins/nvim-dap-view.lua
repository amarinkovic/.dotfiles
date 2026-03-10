return {
  {
    "igorlfs/nvim-dap-view",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      { "<leader>DT", "<cmd>DapViewToggle<cr>", desc = "DAP View Toggle" },
    },
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      auto_toggle = true,
      winbar = {
        default_section = "scopes",
      },
      windows = {
        position = "right",
        size = 0.35,
      },
    },
  },
}
