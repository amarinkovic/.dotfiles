return {
  "voldikss/vim-floaterm",
  config = function()
    -- Appearance
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.g.floaterm_borderchars = "─│─│╭╮╯╰"

    -- Behavior
    vim.g.floaterm_autoclose = 1
    vim.g.floaterm_opener = "edit"
    vim.g.floaterm_title = "Terminal ($1/$2)"

    -- Key mappings
    vim.api.nvim_set_keymap(
      "n",
      "<F12>",
      ":FloatermToggle<CR>",
      { noremap = true, silent = true, desc = "Floating terminal" }
    )
    vim.api.nvim_set_keymap(
      "t",
      "<F12>",
      "<C-\\><C-n>:FloatermToggle<CR>",
      { noremap = true, silent = true, desc = "Floating terminal" }
    )
  end,
}
