return {
  "scalameta/nvim-metals",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "scala", "sbt" },
  opts = function()
    local metals_config = require("metals").bare_config()
    metals_config.on_attach = function(client, bufnr)
      -- your on_attach function
    end

    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
    vim.keymap.set("n", "<leader>mc", ":Telescope metals commands<CR>", { desc = "Metals commands" })
  end,
}
