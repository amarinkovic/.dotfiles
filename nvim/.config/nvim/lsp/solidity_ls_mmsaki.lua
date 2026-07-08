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
  cmd = { "solidity-language-server", "--stdio" },
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
