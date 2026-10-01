vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/mfussenegger/nvim-jdtls",
})

local jdtls = require("jdtls")

-- Paths
local home = os.getenv("HOME")
local workspace_base = home .. "/.local/share/nvim/jdtls-workspace/"
local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
local lombok_path = mason_path .. "/jdtls/lombok.jar"
local sdkman_java = (os.getenv("SDKMAN_DIR") or home .. "/.sdkman") .. "/candidates/java"

-- JDKs installed through sdkman, newest first. Folder names look like "21.0.1-tem";
-- for equal versions Temurin wins so the pick is deterministic.
local function sdkman_jdks()
  local jdks = {}
  for name, type in vim.fs.dir(sdkman_java) do
    local version = vim.version.parse(name:match("^[%d.]+") or "")
    if name ~= "current" and type ~= "file" and version and vim.fn.executable(sdkman_java .. "/" .. name .. "/bin/java") == 1 then
      table.insert(jdks, { path = sdkman_java .. "/" .. name, version = version, tem = name:match("%-tem$") ~= nil })
    end
  end
  table.sort(jdks, function(a, b)
    if a.version ~= b.version then
      return a.version > b.version
    end
    return a.tem and not b.tem
  end)
  return jdks
end

-- jdtls itself is pinned to the newest sdkman JDK >= 21 (its minimum), independent of
-- `sdk use`/`sdk default`. Projects are compiled against the JDK matching the level in
-- their build file (maven.compiler.release, Gradle toolchain, ...), picked from
-- `runtimes` by execution environment name, e.g. JavaSE-17.
local function java_setup()
  local runtimes, seen, launcher = {}, {}, nil
  for _, jdk in ipairs(sdkman_jdks()) do
    local major = jdk.version.major
    if major >= 21 and not launcher then
      launcher = jdk
    end
    local env = major == 8 and "JavaSE-1.8" or "JavaSE-" .. major
    if not seen[env] then
      seen[env] = true
      table.insert(runtimes, { name = env, path = jdk.path, default = (jdk == launcher) or nil })
    end
  end
  return launcher, runtimes
end

-- Build the config per buffer so each Java project gets its own root and workspace,
-- instead of reusing the root of whichever file loaded the plugin first.
local function make_config()
  -- Find root of project
  local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
  local root_dir = vim.fs.root(0, root_markers) or vim.fn.expand("%:p:h")

  -- Use a hash of the full path to avoid collisions between projects with the same directory name
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local project_hash = vim.fn.sha256(root_dir):sub(1, 8)
  local workspace_dir = workspace_base .. project_name .. "-" .. project_hash

  local launcher, runtimes = java_setup()
  if not launcher then
    vim.notify("jdtls: no JDK >= 21 found in " .. sdkman_java, vim.log.levels.ERROR)
    return nil
  end

  return {
    cmd = {
      jdtls_bin,
      "--java-executable=" .. launcher.path .. "/bin/java",
      "--jvm-arg=-Xmx1g",
      "--jvm-arg=-javaagent:" .. lombok_path,
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
          runtimes = runtimes,
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
        vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/*.jar", true, true),
        -- Skip jars jdtls can't install as bundles: two that aren't OSGi bundles at all
        -- (see nvim-jdtls README), and ones jdtls already ships in the same version.
        vim.tbl_filter(function(jar)
          local name = vim.fs.basename(jar)
          return name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar" and name ~= "jacocoagent.jar" and not vim.uv.fs_stat(mason_path .. "/jdtls/plugins/" .. name)
        end, vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", true, true))
      ),
    },
  }
end

-- Command to list and clean up stale JDTLS workspaces
vim.api.nvim_create_user_command("JdtlsCleanWorkspaces", function()
  local dirs = vim.fn.glob(workspace_base .. "*", false, true)
  if #dirs == 0 then
    vim.notify("No JDTLS workspaces found", vim.log.levels.INFO)
    return
  end
  vim.ui.select(dirs, {
    prompt = "Select workspace to delete (or close to cancel):",
    format_item = function(path)
      return vim.fn.fnamemodify(path, ":t")
    end,
  }, function(choice)
    if choice then
      vim.fn.delete(choice, "rf")
      vim.notify("Deleted: " .. vim.fn.fnamemodify(choice, ":t"), vim.log.levels.INFO)
    end
  end)
end, { desc = "Clean up stale JDTLS workspaces" })

-- Setup autocmd to start jdtls
local jdtls_augroup = vim.api.nvim_create_augroup("nvim-jdtls", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local config = make_config()
    if config then
      jdtls.start_or_attach(config)
    end
  end,
  group = jdtls_augroup,
})

-- Keymaps (will be set when attached to Java files)
vim.api.nvim_create_autocmd("LspAttach", {
  group = jdtls_augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "jdtls" then
      jdtls.setup_dap({ config_overrides = {} })

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
