local OLLAMA_HOST = os.getenv("OLLAMA_HOST") or "http://localhost:11434"
local OLLAMA_MODEL = os.getenv("OLLAMA_MODEL") or "qwen2.5-coder:7b"

return {
  "milanglacier/minuet-ai.nvim",
  config = function()
    require("minuet").setup({
      provider = "openai_fim_compatible",
      n_completions = 2,
      context_window = 512,

      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM",
          name = "Ollama",
          end_point = OLLAMA_HOST .. "/v1/completions",
          model = OLLAMA_MODEL,
          optional = {
            max_tokens = 256,
            top_p = 0.9,
          },
        },
      },

      cmp = {
        enable_auto_complete = true,
      },

      virtualtext = {
        auto_trigger_ft = {},
        keymap = {
          accept = "<A-A>",         -- accept whole completion
          accept_line = "<A-a>",    -- accept one line
          accept_n_lines = "<A-z>", -- accept n lines (prompts for number)
          prev = "<A-[>",           -- cycle to prev or manually invoke
          next = "<A-]>",           -- cycle to next or manually invoke
          dismiss = "<A-e>",
        },
      },
    })
  end,
}
