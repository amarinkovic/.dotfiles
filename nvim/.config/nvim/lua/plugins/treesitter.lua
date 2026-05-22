return {
  "romus204/tree-sitter-manager.nvim",
  lazy = false,
  init = function()
    vim.filetype.add({
      pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
    })
    vim.filetype.add({
      extension = { mdx = "mdx" },
    })
    vim.treesitter.language.register("markdown", "mdx")
  end,
  config = function()
    require("tree-sitter-manager").setup({
      auto_install = true,
      highlight = true,
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "bash",
        "json",
        "yaml",
        "toml",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "python",
        "go",
        "rust",
        "c",
        "hyprlang",
        "solidity",
        "zig",
        "glsl",
        "scala",
        "gitcommit",
        "gitignore",
        "git_rebase",
        "gitattributes",
        "diff",
        "regex",
        "comment",
        "jsdoc",
        "printf",
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match) or args.match
        if pcall(vim.treesitter.language.inspect, lang) then
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldlevel = 99
        end
      end,
    })
  end,
}
