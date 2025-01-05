return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier.with({
					extra_filetypes = { "solidity" },
				}),
				null_ls.builtins.diagnostics.solhint.with({
					condition = function(utils)
						return utils.root_has_file({
							".solhint.json",
							".solhint.yaml",
							".solhint.yml",
						})
					end,
				}),
				require("none-ls.code_actions.eslint_d"),
				null_ls.builtins.completion.spell,
			},
		})
		vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, { desc = "Buffer format (none-ls)" })

		-- trigger buffer format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.lua", "*.sol", "*.scala", "*.rs", "*.go", "*.py", "*.js", "*.ts", "*.json" },
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end,
}
