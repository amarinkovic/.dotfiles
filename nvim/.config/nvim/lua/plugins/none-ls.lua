return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- null_ls.builtins.diagnostics.checkstyle.with({
        --   extra_args = { "-c", "/google_checks.xml" }, -- or "/sun_checks.xml" or path to self written rules
        -- }),
        null_ls.builtins.diagnostics.solhint.with({
          -- Search upwards from the buffer rather than the project root, so a
          -- config nested in a monorepo (evm/.solhint.json) is still found.
          -- cwd must match it for .solhintignore and nested configs to resolve.
          cwd = function(params)
            return vim.fs.root(params.bufname, ".solhint.json")
          end,
          runtime_condition = function(params)
            return vim.fs.root(params.bufname, ".solhint.json") ~= nil
          end,
          -- solhint exits 1 whenever it reports a problem; without this null-ls
          -- treats its normal output as a crash.
          check_exit_code = function(code)
            return code <= 1
          end,
        }),
      },
    })
  end,
}
