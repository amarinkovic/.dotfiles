return {
  cmd = { "kotlin-language-server", "--stdio" },
  filetypes = { "kotlin" },
  root_markers = { "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", ".git" },
  init_options = {
    storagePath = vim.fn.stdpath("data") .. "/kotlin-language-server",
  },
}
