----------------=[ Imports ]=---------------------------------

require("options")
require("keymaps")
require("autocmds")

----------------=[ Lazy Bootstrap ]=--------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  ui = {
    border = "rounded",
  },
  change_detection = {
    notify = false,
  },
})

----------------=[ LSP ]=------------------------------------

vim.lsp.enable({
  "bashls",
  "glsl_analyzer",
  "gopls",
  "gradle_ls",
  -- "hyprls",
  "jsonls",
  "lemminx",
  "lua_ls",
  "solidity_ls_nomicfoundation",
  "terraformls",
  "ts_ls",
  "yamlls",
})

------------------------------------------------------------
