local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
}

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mason-org/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "leoluz/nvim-dap-go", -- Golang
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = function()
    local dap = require("dap")
    return {
      { "<leader>Dc", dap.continue(), desc = "Debug: Start/Continue" },
      { "<leader>Dsi", dap.step_into(), desc = "Debug: Step Into" },
      { "<leader>DsO", dap.step_over(), desc = "Debug: Step Over" },
      { "<leader>Dso", dap.step_out(), desc = "Debug: Step Out" },
      { "<leader>Db", dap.toggle_breakpoint(), desc = "Debug: Toggle Breakpoint" },
      { "<leader>DB", dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")), desc = "Debug: Set Conditional Breakpoint" },
      { "<leader>Dt", dap.toggle(), desc = "Debug: Toggle UI" },
      { "<leader>Dl", dap.run_last(), desc = "Debug: Run Last Configuration" },
    }
  end,
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "delve",
        "js-debug-adapter",
      },
    })

    -- Dap UI setup
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })

    -- Automatically open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    dap.adapters = {
      ["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = {
            "${port}",
          },
        },
      },
    }

    -- Setup virtual text to show variable values inline
    require("nvim-dap-virtual-text").setup()

    -- for _, language in ipairs(js_based_languages) do
    -- dap.configurations[language] = {
    dap.configurations.typescript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        runtimeExecutable = "tsx",
        runtimeArgs = {
          "${file}",
        },
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
    }
    -- end --for-end

    dap.configurations.javascript = dap.configurations.typescript
  end,
}
