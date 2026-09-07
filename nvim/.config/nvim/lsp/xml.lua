---@brief
---
--- https://github.com/eclipse/lemminx
---
--- The easiest way to install the server is to get a binary from https://github.com/redhat-developer/vscode-xml/releases and place it on your PATH.
---
--- NOTE to macOS users: Binaries from unidentified developers are blocked by default. If you trust the downloaded binary, run it once, cancel the prompt, then remove the binary from Gatekeeper quarantine with `xattr -d com.apple.quarantine lemminx`. It should now run without being blocked.
---
--- Deliberately NOT named `lemminx`. nvim-lspconfig ships `lsp/lemminx.lua`, and configs
--- from `lsp/*.lua` are merged in runtimepath order with `tbl_deep_extend('force', ...)`
--- -- nvim-lspconfig is a lazy plugin and so comes AFTER this config dir, meaning its
--- keys win. Its `filetypes` lists "xsl", which is a filename extension, not a filetype
--- (`.xsl` files get filetype "xslt"), and ":checkhealth vim.lsp" warns about it. Because
--- tbl_deep_extend merges lists index-wise, dropping the entry here was not enough: the
--- upstream list overwrote ours element by element and put "xsl" back. Under a name
--- lspconfig does not ship, this file is authoritative -- same as the other servers here.

---@type vim.lsp.Config
return {
  cmd = { "lemminx" },
  -- No "xsl": `.xsl` maps to filetype "xslt" (`:h vim.filetype`), which already covers it.
  filetypes = { "xml", "xsd", "xslt", "svg" },
  root_markers = { ".git" },
}
