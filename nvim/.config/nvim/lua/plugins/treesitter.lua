return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			-- ensure_installed = { "lua", "javascript", "rust", "scala", "solidity" }, -- use `auto_install = true` instead of this
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
    vim.filetype.add({
      pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
    })
	end,
}
