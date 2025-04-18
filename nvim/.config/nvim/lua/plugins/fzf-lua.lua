return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")
    vim.keymap.set("n", "<C-p>", function() fzf.files() end, { desc = "[FZF] Find files" })
    vim.keymap.set("n", "<leader>fg", function() fzf.live_grep() end, { desc = "[FZF] Live Grep" })
    vim.keymap.set("n", "<leader>fb", function() fzf.buffers() end, { desc = "[FZF] Find buffers" })
    vim.keymap.set("n", "<leader>fr", function() fzf.lsp_references() end, { desc = "[FZF] LSP References" })
    vim.keymap.set("n", "<leader>fk", function() fzf.keymaps() end, { desc = "[FZF] Find keymaps" })
    vim.keymap.set("n", "<leader>fh", function() fzf.help_tags() end, { desc = "[FZF] Find help tags" })
  end,
}
