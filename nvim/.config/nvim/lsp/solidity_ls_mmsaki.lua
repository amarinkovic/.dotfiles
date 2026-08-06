--- https://github.com/mmsaki/solidity-language-server
---
---@brief
---
--- A fast, Foundry-native Solidity language server powered by solc and foundry.
--- Unlike nomicfoundation's server, this one implements textDocument/documentHighlight,
--- so occurrences of the symbol under the cursor get highlighted.
---
--- Install via cargo:
---
--- ```sh
--- cargo install solidity-language-server
--- ```
---
--- or the install script:
---
--- ```sh
--- curl -fsSL https://asyncswap.org/lsp/install.sh | sh
--- ```
return {
  -- Spawn in root_dir, not Neovim's cwd: the server drives solc through Foundry's
  -- project machinery, which resolves out/ and cache/ against the process cwd. Opening
  -- nvim above the foundry.toml would otherwise litter that parent with build artifacts.
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ "solidity-language-server", "--stdio" }, dispatchers, {
      cwd = config.root_dir,
    })
  end,
  filetypes = { "solidity" },
  root_markers = {
    "foundry.toml",
    "remappings.txt",
    "hardhat.config.js",
    "hardhat.config.ts",
    ".git",
    "package.json",
  },
}
