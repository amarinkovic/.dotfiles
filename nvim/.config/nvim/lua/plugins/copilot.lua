return {
  "zbirenbaum/copilot.lua",
  event = "VeryLazy",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
      panel = { enabled = false },
      filetypes = {
        ["*"] = true,
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("copilot", { clear = true }),
      pattern = "*",
      callback = function()
        local suggestion = require("copilot.suggestion")
        vim.keymap.set("i", "<Tab>", function()
          if suggestion.is_visible() then
            suggestion.accept()
          else
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true))
          end
        end, { remap = true })
      end,
    })
  end,
}
