return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto", -- dracula
      },
      sections = {
        lualine_b = {
          "branch",
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              end
              return "recording @" .. reg
            end,
          },
        },
        lualine_c = {
          { "filename", path = 1 }, -- relative path
        },
        lualine_x = {
          {
            "lsp_status",
            icon = " ", -- f013
            symbols = {
              separator = "/",
            },
            ignore_lsp = {},
            show_name = true,
          },
          { "filetype", icon_only = true },
          {
            "diagnostics",
            sources = { "nvim_workspace_diagnostic" },
          },
        },
      },
    })
  end,
}
