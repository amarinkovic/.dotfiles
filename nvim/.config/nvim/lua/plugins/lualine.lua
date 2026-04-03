return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "dracula",
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
          {
            "filename",
            path = 1, -- relative path
          },
        },
        lualine_x = {
          {
            function()
              local devicons = require("nvim-web-devicons")
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              local lsp_icons = {
                copilot = "\u{e708}",
                lua_ls = "\u{e620}",
                ts_ls = "\u{e628}",
                gopls = "\u{e626}",
                pylsp = "\u{e73c}",
                rust_analyzer = "\u{e7a8}",
                jsonls = "\u{e60b}",
                bashls = "\u{e795}",
                yaml_ls = "\u{e6a8}",
                dockerls = "\u{f308}",
                terraformls = "\u{f1bb}",
                kotlin_lsp = "\u{e634}",
                zls = "\u{e6a9}",
                jdtls = "\u{e738}",
                metals = "\u{e737}",
              }
              local icons = {}
              local seen = {}
              for _, client in ipairs(clients) do
                local icon = lsp_icons[client.name]
                if not icon then
                  local ft_icon = devicons.get_icon_by_filetype(vim.bo.filetype)
                  icon = ft_icon or "\u{f013}"
                end
                if not seen[icon] then
                  seen[icon] = true
                  table.insert(icons, icon .. client.name)
                end
              end
              return " LSP[" .. table.concat(icons, ",") .. "]"
            end,
          },
          -- "encoding",
          -- "fileformat",
          { "filetype", icon_only = false, padding = 2 },
        },
      },
    })
  end,
}
