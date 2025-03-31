------------------- -=[ Options ]=- --------------------------------------------------------------

vim.g.mapleader = " "

vim.g.have_nerd_font = true

--  Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- use relative line numbers
vim.opt.wrap = false -- turn off line wrapping
vim.opt.ignorecase = true -- case-insensitive searching
vim.opt.smartcase = true
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.updatetime = 50 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.updatetime = 300
vim.opt.termguicolors = true
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 2 -- amount to indent with << and >>
vim.opt.tabstop = 2 -- spaces shown per tab
vim.opt.smarttab = true -- delete tab amount of whitespace at once
vim.opt.smartindent = true -- when going to a new line
vim.opt.autoindent = true -- keep indent from previous line
vim.opt.cursorline = true -- show line under cursor
vim.opt.undofile = true -- perist undos between sessions
vim.opt.breakindent = true -- keep indentation on broken down lines
vim.opt.splitright = true -- add split to the right of the current buffer
vim.opt.splitbelow = true -- add split below the current buffer

----------------------------------------------------------------------------------------------------
