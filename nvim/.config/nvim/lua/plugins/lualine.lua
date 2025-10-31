return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "dracula",
      },
      sections = {
        lualine_c = {
          {
            "filename",
            path = 1, -- relative path
          },
        },
        lualine_x = {
          {
            function()
              local clients = vim.lsp.get_active_clients()
              if #clients > 0 then
                local client_names = {}
                for _, client in ipairs(clients) do
                  table.insert(client_names, client.name)
                end
                return "LSP: " .. table.concat(client_names, ", ")
              end
              return ""
            end,
            icon = " ",
            color = { fg = "#ffffff" },
          },
          "encoding",
          "fileformat",
          "filetype",
        },
      },
    })
  end,
}
