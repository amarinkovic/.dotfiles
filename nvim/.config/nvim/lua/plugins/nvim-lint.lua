return {
  "mfussenegger/nvim-lint",
  enabled = false, -- still use none-ls
  event = { "BufReadPre", "BufNewFile" }, -- Or other events you prefer
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      solidity = { "solhint" },
      javascript = { "eslint_d" },
      java = { "snyk_iac" },
      yaml = { "yamllint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        if vim.v.event.type == "TextChanged" then
          vim.defer_fn(function()
            lint.try_lint()
          end, 500) -- Delay 500ms
        else
          lint.try_lint()
        end
      end,
    })
    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "Trigger linting" })

    print("nvim-lint configured")
  end,
}
