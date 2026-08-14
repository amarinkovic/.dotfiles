---@brief
---
--- https://github.com/microsoft/typescript-go
---
--- The native Go port of the TypeScript compiler and language server (TypeScript 7),
--- shipped as the `tsgo` binary. Installed via Mason (`:MasonInstall tsgo`).
---
--- Works for TypeScript 6 and 7 projects alike: tsgo is a self-contained server that
--- reads the project's tsconfig.json and does not care which `typescript` version sits
--- in node_modules. Note that editor diagnostics therefore come from the TS 7 checker
--- while a TS 6 project's `tsc` build uses its own -- they can diverge in edge cases.
---
--- Deliberately NOT named `tsc` or `tsgo`. nvim-lspconfig ships `lsp/tsc.lua` (plus a
--- deprecated `lsp/tsgo.lua` alias), and configs from `lsp/*.lua` are merged in
--- runtimepath order with `tbl_deep_extend('force', ...)` -- nvim-lspconfig is a lazy
--- plugin and so comes AFTER this config dir, meaning its keys win. Its `cmd` is a
--- resolver that prefers a project-local `node_modules/.bin/tsc`, which only speaks
--- LSP from TypeScript 7 on; against a TS 6 install it exits 1 immediately with
---   error TS5023: Unknown compiler option '--lsp'
--- and no server attaches at all. Under a name lspconfig does not ship, this file is
--- authoritative for every key -- same as the other servers in this directory.

---@type vim.lsp.Config
return {
  cmd = { "tsgo", "--lsp", "--stdio" },
  capabilities = {
    workspace = {
      -- Declining dynamic registration makes tsgo use its own in-process Go watcher:
      --   "file watching: using builtin in-process watcher"
      --
      -- Otherwise it registers four recursive didChangeWatchedFiles watchers spanning
      -- the whole repo, node_modules included. On macOS nvim honours those with
      -- recursive FSEvents watchers (vim/lsp/_watchfiles.lua passes uvflags.recursive)
      -- and glob-matches every event in Lua on the main loop, stalling the editor on
      -- large trees.
      didChangeWatchedFiles = { dynamicRegistration = false },
    },
  },
  -- Carried over from nvim-lspconfig's lsp/tsc.lua, which no longer applies here.
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = {
          enabled = "literals",
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
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
