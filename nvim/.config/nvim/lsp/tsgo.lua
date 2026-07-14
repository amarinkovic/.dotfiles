--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/tsgo.lua

---@brief
---
--- https://github.com/microsoft/typescript-go
---
--- `tsgo` is the native Go port of the TypeScript compiler and language server
--- (the future TypeScript 7). Installed via Mason (`:MasonInstall tsgo`).

return {
  cmd = { "tsgo", "--lsp", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
  },
}
