vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.g.mapleader = " "

-- clear search highlighting
vim.api.nvim_set_keymap('n', '<leader>n', ':nohlsearch<CR>', { noremap = true, silent = true})

-- TODO: figure this out (move lines up/down)
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.opt.updatetime = 300
vim.opt.termguicolors = true
