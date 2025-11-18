----------------=[ Auto-commands ]=- ------------------------------------------------------------

-- highlight text briefly when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- trigger buffer format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.lua", "*.json" },
  callback = function()
    -- vim.lsp.buf.format({ async = false })
    require("conform").format()
  end,
})

-- Auto popup diagnostic
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { scope = "cursor", focus = false })
  end,
})
vim.diagnostic.config({ virtual_text = true, float = { border = "rounded" } })

-- General LSP key mappings
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP Keybinds",
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function()
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
    vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
    vim.keymap.set({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
  end,
})

-- no auto commenting on new lines
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})
----------------------------------------------------------------------------------------------------
