return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
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
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    require("nvim-treesitter").install({
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
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match) or args.match
        local ok = pcall(vim.treesitter.language.inspect, lang)
        if ok then
          vim.treesitter.start()
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldlevel = 99
        end
      end,
    })
  end,
}
