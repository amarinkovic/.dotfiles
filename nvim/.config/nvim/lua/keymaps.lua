------------------- -=[ Keymaps ]=- -----------------------------------------------------------

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
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute current word" })
-- stylua: ignore end

-- Comment lines out
vim.keymap.set("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- Redo
vim.keymap.set("n", "U", "<c-r>", { noremap = true })

-- Noice dismiss
vim.api.nvim_set_keymap("n", "<leader>nn", ":Noice dismiss<CR>", { noremap = true })

-- Resize panes
vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
-- vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
-- vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -

-- Quickfix list
vim.keymap.set("n", "<leader>qf", "<cmd>copen<CR>", { desc = "Show quick-fix list" })
vim.keymap.set("n", "<leader>qq", "<cmd>cclose<CR>", { desc = "Close quick-fix list" })
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next in quick-fix list" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous in quick-fix list" })

-----------------------------------------------------------------------------------------------
