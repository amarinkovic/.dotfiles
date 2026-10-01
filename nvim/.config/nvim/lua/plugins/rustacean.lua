-- loads itself on the rust filetype (ftplugin), no setup call needed.
-- Major version pinned as upstream recommends, to avoid surprise breaking changes.
-- LSP capabilities come from vim.lsp.config("*") in nvim-lspconfig.lua.
vim.pack.add({ { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("^9") } })
