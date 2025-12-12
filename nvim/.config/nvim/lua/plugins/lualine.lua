return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "dracula",
      },
      sections = {
        lualine_b = {
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
          {
            "filename",
            path = 1, -- relative path
          },
        },
        lualine_x = {
          {
            "lsp_status",
            icon = " ", -- f013
            symbols = {
              spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
              done = "✓",
              separator = ", ",
            },
            ignore_lsp = {},
            show_name = true,
          },
          "encoding",
          "fileformat",
          "filetype",
        },
      },
    })
  end,
}
