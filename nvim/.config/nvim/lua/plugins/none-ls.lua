return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
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
