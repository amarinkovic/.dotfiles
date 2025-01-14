return {
  "eandrju/cellular-automaton.nvim",
  config = function()
    vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomation make_it_rain<CR>")
  end,
}
