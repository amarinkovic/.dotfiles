local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
}

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "mason-org/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
    "igorlfs/nvim-dap-view",
  },
  keys = function()
    local dap = require("dap")
    return {
      { "<leader>DD", dap.disconnect, desc = "DAP Disconnect" },
      { "<leader>DC", dap.continue, desc = "DAP Continue" },
      { "<leader>DB", dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
      { "<F10>", dap.step_over, desc = "Step Over" },
      { "<F11>", dap.step_into, desc = "Step Into" },
      { "<F12>", dap.step_out, desc = "Step Out" },
    }
  end,
  config = function()
    local dap = require("dap")

    -- Signs
    for _, group in pairs({
      "DapBreakpoint",
      "DapBreakpointCondition",
      "DapBreakpointRejected",
      "DapLogPoint",
    }) do
      vim.fn.sign_define(group, { text = "●", texthl = group })
    end
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "debugPC", numhl = "debugPC" })

    -- Setup virtual text to show variable values inline
    require("nvim-dap-virtual-text").setup()

    dap.configurations.javascript = dap.configurations.typescript
  end,
}
