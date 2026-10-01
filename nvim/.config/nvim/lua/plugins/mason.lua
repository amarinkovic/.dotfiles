-- loaded before nvim-dap and nvim-lspconfig (alphabetical), both rely on it
vim.pack.add({ { src = "https://github.com/mason-org/mason.nvim", version = vim.version.range("2") } })

require("mason").setup({ ui = { border = "rounded" } })
