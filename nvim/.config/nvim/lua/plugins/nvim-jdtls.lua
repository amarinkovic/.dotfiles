return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local jdtls = require("jdtls")
    local jdtls_setup = require("jdtls.setup")

    -- Find root of project
    local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
    local root_dir = jdtls_setup.find_root(root_markers)
    if not root_dir then
      return
    end

    -- Paths
    local home = os.getenv("HOME")
    local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
    local jdtls_path = mason_path .. "/jdtls"
    local lombok_path = jdtls_path .. "/lombok.jar"

    -- Determine OS
    local os_config = "linux"
    if vim.fn.has("mac") == 1 then
      os_config = "mac"
    elseif vim.fn.has("win32") == 1 then
      os_config = "win"
    end

    -- Java executable
    local java_cmd = "java"
    local java_home = os.getenv("JAVA_HOME")
    if java_home then
      java_cmd = java_home .. "/bin/java"
    end

    -- JDTLS configuration
    local config = {
      cmd = {
        java_cmd,
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. lombok_path,
        "-jar",
        vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        jdtls_path .. "/config_" .. os_config,
        "-data",
        workspace_dir,
      },
      root_dir = root_dir,
      settings = {
        java = {
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            updateBuildConfiguration = "interactive",
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          format = {
            enabled = true,
          },
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
            importOrder = {
              "java",
              "javax",
              "com",
              "org",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
        },
      },
      flags = {
        allow_incremental_sync = true,
      },
      init_options = {
        bundles = vim.list_extend(
          vim.split(vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/*.jar", true), "\n"),
          vim.split(vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true), "\n")
        ),
      },
    }

    -- Setup autocmd to start jdtls
    local jdtls_augroup = vim.api.nvim_create_augroup("nvim-jdtls", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        jdtls.start_or_attach(config)
      end,
      group = jdtls_augroup,
    })

    -- Keymaps (will be set when attached to Java files)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then
          local opts = { buffer = args.buf, silent = true }
          vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
          vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
          vim.keymap.set("v", "<leader>jv", [[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]], vim.tbl_extend("force", opts, { desc = "Extract variable" }))
          vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
          vim.keymap.set("v", "<leader>jc", [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]], vim.tbl_extend("force", opts, { desc = "Extract constant" }))
          vim.keymap.set("v", "<leader>jm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], vim.tbl_extend("force", opts, { desc = "Extract method" }))
          vim.keymap.set("n", "<leader>ju", jdtls.update_project_config, vim.tbl_extend("force", opts, { desc = "Update project config" }))
          vim.keymap.set("n", "<leader>jt", jdtls.test_class, vim.tbl_extend("force", opts, { desc = "Test class" }))
          vim.keymap.set("n", "<leader>jn", jdtls.test_nearest_method, vim.tbl_extend("force", opts, { desc = "Test nearest method" }))
        end
      end,
    })
  end,
}
