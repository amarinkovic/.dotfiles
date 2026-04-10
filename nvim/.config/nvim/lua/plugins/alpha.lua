return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    enabled = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local theme = require("alpha.themes.startify")

      local version = vim.version()
      local version_str = string.format("v%d.%d.%d", version.major, version.minor, version.patch)

      theme.section.header.val = {
        [[                                                       ]],
        [[                                                       ]],
        [[                                                       ]],
        [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗   ]],
        [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║   ]],
        [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║   ]],
        [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║   ]],
        [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║   ]],
        [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝   ]],
        [[                                             ]] .. version_str,
        [[                                                       ]],
      }

      -- disable global MRU
      theme.section.mru.val = { { type = "padding", val = 0 } }

      theme.section.bottom_buttons.val = {
        theme.button("f", "Search for file", "<cmd>Telescope find_files<CR>"),
        theme.button("/", "Search by grep", "<cmd>Telescope live_grep<CR>"),
        theme.button("q", "Quit", "<cmd>qa<CR>"),
      }

      theme.section.footer.val = {
        {
          type = "text",
          val = require("alpha.fortune"),
          opts = { hl = "Conceal" },
        },
      }

      -- show startup time in footer after VimEnter
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local elapsed = (vim.uv.hrtime() - vim.g.start_time) / 1e6
          local startup_text = {
            type = "text",
            val = string.format(" Neovim loaded in %.2f ms", elapsed),
            opts = { hl = "NonText", position = "left" },
          }
          theme.section.footer.val[2] = { type = "padding", val = 1 }
          theme.section.footer.val[3] = startup_text
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      alpha.setup(theme.config)
    end,
  },
}
