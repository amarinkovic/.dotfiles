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

local lsp_files = vim.fn.glob(vim.fn.stdpath("config") .. "/lsp/*.lua", false, true)
vim.lsp.enable(vim.tbl_map(function(path)
  return vim.fn.fnamemodify(path, ":t:r")
end, lsp_files))

------------------------------------------------------------
