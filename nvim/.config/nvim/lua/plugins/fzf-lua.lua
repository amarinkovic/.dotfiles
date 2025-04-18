return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local actions = require("fzf-lua.actions")

    require("fzf-lua").setup({
      actions = {
        files = { ["default"] = actions.file_edit },
        grep = { ["default"] = actions.file_edit },
        buffers = { ["default"] = actions.buf_edit },
      },
    })

    local fzf = require("fzf-lua")

    -- stylua: ignore start
    vim.keymap.set("n", "<C-p>", function() fzf.files() end, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", function() fzf.live_grep() end, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>fb", function() fzf.buffers() end, { desc = "Find buffers" })
    vim.keymap.set("n", "<leader>fr", function() fzf.lsp_references() end, { desc = "LSP References" })
    vim.keymap.set("n", "<leader>fk", function() fzf.keymaps() end, { desc = "Find keymaps" })
    vim.keymap.set("n", "<leader>fh", function() fzf.help_tags() end, { desc = "Find help tags" })
    -- stylua: ignore end
  end,
}
