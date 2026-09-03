return {
  "mrcjkb/rustaceanvim",
  version = "^5", -- Recommended
  ft = "rust",
  init = function()
    vim.g.rustaceanvim = {
      server = {
        -- Don't pick up `rust-analyzer.*` keys from a project's
        -- .vscode/settings.json. Their relative paths are resolved against
        -- rustaceanvim's per-buffer root_dir (the cargo workspace_root),
        -- which differs from VS Code's single workspace folder. In repos with
        -- a nested [workspace], a `linkedProjects` entry like
        -- "./trident-tests/Cargo.toml" then resolves to
        -- <root>/trident-tests/./trident-tests/Cargo.toml and workspace
        -- loading fails. Auto-discovery per root_dir handles this correctly.
        load_vscode_settings = false,
      },
    }
  end,
}
