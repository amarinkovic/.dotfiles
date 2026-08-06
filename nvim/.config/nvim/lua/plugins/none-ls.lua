return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    -- solhint honours .solhintignore only for paths it globs itself. Handed an ignored
    -- file directly it exits 255 with "No files to lint!", which null-ls reports as a
    -- failed generator, so ignored buffers have to be filtered out before spawning.
    local function solhint_ignores(root, bufname)
      local ignorefile = root .. "/.solhintignore"
      if vim.fn.filereadable(ignorefile) == 0 then
        return false
      end
      local relative = bufname:sub(#root + 2)
      for _, line in ipairs(vim.fn.readfile(ignorefile)) do
        local pattern = vim.trim(line):gsub("/+$", "")
        if pattern ~= "" and not vim.startswith(pattern, "#") then
          -- match the pattern itself for globs, plus /** so a bare directory entry
          -- covers everything beneath it
          local matches = vim.glob.to_lpeg(pattern):match(relative)
            or vim.glob.to_lpeg(pattern .. "/**"):match(relative)
          if matches then
            return true
          end
        end
      end
      return false
    end

    null_ls.setup({
      sources = {
        -- null_ls.builtins.diagnostics.checkstyle.with({
        --   extra_args = { "-c", "/google_checks.xml" }, -- or "/sun_checks.xml" or path to self written rules
        -- }),
        null_ls.builtins.diagnostics.solhint.with({
          -- The builtin passes $FILENAME, so solhint reads the file on disk, not the
          -- buffer. Registered as plain DIAGNOSTICS it would run on didChange only —
          -- always linting the last saved content, and never re-running after a write,
          -- which leaves fixed warnings on screen until the buffer changes again.
          -- On save, runs when the disk actually changes (and still on open).
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          -- Search upwards from the buffer rather than the project root, so a
          -- config nested in a monorepo (evm/.solhint.json) is still found.
          -- cwd must match it for .solhintignore and nested configs to resolve.
          cwd = function(params)
            return vim.fs.root(params.bufname, ".solhint.json")
          end,
          runtime_condition = function(params)
            local root = vim.fs.root(params.bufname, ".solhint.json")
            return root ~= nil and not solhint_ignores(root, params.bufname)
          end,
          -- solhint exits 1 whenever it reports a problem; without this null-ls
          -- treats its normal output as a crash.
          check_exit_code = function(code)
            return code <= 1
          end,
        }),
      },
    })
  end,
}
