vim.pack.add({
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/jay-babu/mason-nvim-dap.nvim",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/mfussenegger/nvim-dap",
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>DD", function() require("dap").disconnect() end, { desc = "DAP Disconnect" })
vim.keymap.set("n", "<leader>DC", function() require("dap").continue() end, { desc = "DAP Continue" })
vim.keymap.set("n", "<leader>DB", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, { desc = "Step Out" })
-- stylua: ignore end

local dap = require("dap")

-- Signs
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f1c40f" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#888888" })
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })

vim.fn.sign_define("DapBreakpoint", { text = "◉", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapBreakpointRejected", { text = "◯", texthl = "DapBreakpointRejected" })
vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "debugPC", numhl = "debugPC" })

-- Setup virtual text to show variable values inline
require("nvim-dap-virtual-text").setup({})

-- Auto-register adapters for whatever debuggers are installed via Mason
require("mason-nvim-dap").setup({
  automatic_installation = true,
  handlers = {},
})

-- mason-nvim-dap has no default setup for js-debug-adapter, wire it up manually
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "js-debug-adapter",
    args = { "${port}" },
  },
}
for _, ft in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
  dap.configurations[ft] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to process",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
  }
end
