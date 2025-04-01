return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.checkstyle.with({
          extra_args = { "-c", "/google_checks.xml" }, -- or "/sun_checks.xml" or path to self written rules
        }),
        null_ls.builtins.diagnostics.solhint.with({
          condition = function(utils)
            return utils.root_has_file({
              ".solhint.json",
              ".solhint.yaml",
              ".solhint.yml",
            })
          end,
        }),
      },
    })
  end,
}
