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

----------------------------------------------------------------------------------------------------
