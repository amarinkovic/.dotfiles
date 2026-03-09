return {
  {
    "igorlfs/nvim-dap-view",
    -- lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      windows = {
        position = "right",
      },
    },
  },
}
