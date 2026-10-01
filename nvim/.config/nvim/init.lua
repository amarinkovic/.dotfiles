vim.g.start_time = vim.uv.hrtime()

----------------=[ Imports ]=---------------------------------

require("options")
require("keymaps")
require("autocmds")

----------------=[ Plugins ]=--------------------------------

-- Build steps for plugins that need one. Registered before any vim.pack.add()
-- so it also fires on first install (including installs from the lockfile).
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end
    if name == "telescope-fzf-native.nvim" then
      -- wait so the library exists before telescope.lua loads the extension
      local res = vim.system({ "make" }, { cwd = ev.data.path }):wait()
      if res.code ~= 0 then
        vim.notify("telescope-fzf-native: make failed\n" .. res.stderr, vim.log.levels.ERROR)
      end
    elseif name == "cord.nvim" then
      if not ev.data.active then
        vim.cmd.packadd("cord.nvim")
      end
      vim.cmd("Cord update")
    end
  end,
})

-- Colorscheme first so plugins that read highlights at setup see it
require("plugins.theme-catppuccin")

for _, path in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugins/*.lua", false, true)) do
  require("plugins." .. vim.fn.fnamemodify(path, ":t:r"))
end

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  vim.pack.update(#opts.fargs > 0 and opts.fargs or nil)
end, { nargs = "*", desc = "Update plugins (vim.pack)" })

vim.api.nvim_create_user_command("PackClean", function()
  local inactive = vim
    .iter(vim.pack.get())
    :filter(function(p)
      return not p.active
    end)
    :map(function(p)
      return p.spec.name
    end)
    :totable()
  if #inactive == 0 then
    vim.notify("No unused plugins")
    return
  end
  vim.pack.del(inactive)
  vim.notify("Removed: " .. table.concat(inactive, ", "))
end, { desc = "Delete plugins no longer added (vim.pack)" })

----------------=[ LSP ]=------------------------------------

local lsp_files = vim.fn.glob(vim.fn.stdpath("config") .. "/lsp/*.lua", false, true)
vim.lsp.enable(vim.tbl_map(function(path)
  return vim.fn.fnamemodify(path, ":t:r")
end, lsp_files))

------------------------------------------------------------
