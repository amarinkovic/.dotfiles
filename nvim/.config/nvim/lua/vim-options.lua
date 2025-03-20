vim.g.mapleader = " "

vim.g.have_nerd_font = true

--  Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.opt.number = true         -- show line numbers
vim.opt.relativenumber = true -- use relative line numbers
vim.opt.wrap = false          -- turn off line wrapping
vim.opt.ignorecase = true     -- case-insensitive searching
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"    -- Keep signcolumn on by default
vim.opt.updatetime = 50       -- Decrease update time
vim.opt.timeoutlen = 300      -- Decrease mapped sequence wait time
vim.opt.inccommand = "split"  -- Preview substitutions live, as you type!
vim.opt.scrolloff = 10        -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.updatetime = 300
vim.opt.termguicolors = true
vim.opt.expandtab = true      -- convert tabs to spaces
vim.opt.shiftwidth = 2        -- amount to indent with << and >>
vim.opt.tabstop = 2           -- spaces shown per tab
vim.opt.smarttab = true       -- delete tab amount of whitespace at once
vim.opt.smartindent = true    -- when going to a new line
vim.opt.autoindent = true     -- keep indent from previous line
vim.opt.cursorline = true     -- show line under cursor
vim.opt.undofile = true       -- perist undos between sessions
vim.opt.breakindent = true    -- keep indentation on broken down lines 
vim.opt.splitright = true     -- add split to the right of the current buffer
vim.opt.splitbelow = true     -- add split below the current buffer

-- Center cursor when moving vertically
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.api.nvim_set_keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })

-- Move selected lines up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- stylua: ignore start
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection" })
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Substitute current word" })
-- stylua: ignore end

-- Comment lines out
vim.keymap.set("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- Redo
vim.keymap.set("n", "U", "<c-r>", { noremap = true })

-- Noice dismiss
vim.api.nvim_set_keymap("n", "<leader>nn", ":Noice dismiss<CR>", { noremap = true })


-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
-- vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
-- vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -
