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
  group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
  pattern = { "*.lua", "*.json" },
  callback = function()
    require("conform").format()
  end,
})

-- vim.diagnostic.config({ virtual_text = true, float = { border = "rounded" } })

-- General LSP key mappings
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP Keybinds",
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(args)
    local buf = args.buf
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to Definition" })
    vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = buf, desc = "Go to Implementation" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "Go to References" })
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
    vim.keymap.set({ "n", "v" }, "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
    vim.keymap.set("n", "<leader>th", function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
    end, { buffer = buf, desc = "Toggle Inlay Hints" })
  end,
})

-- no auto commenting on new lines
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- On idle: show diagnostic float + highlight LSP references under cursor
local cursor_hold_group = vim.api.nvim_create_augroup("CursorHoldActions", { clear = true })

vim.api.nvim_create_autocmd("CursorHold", {
  group = cursor_hold_group,
  desc = "Show diagnostics and highlight LSP references on idle",
  callback = function()
    vim.diagnostic.open_float(nil, { scope = "cursor", focus = false })
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      if client.server_capabilities.documentHighlightProvider then
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
        break
      end
    end
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = cursor_hold_group,
  desc = "Clear LSP reference highlights when entering insert mode",
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})
--------------------------------------------------------------------------------------------------
