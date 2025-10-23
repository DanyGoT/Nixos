return {
  'ray-x/lsp_signature.nvim',
  event = 'LspAttach',
  config = function()
    require('lsp_signature').setup({
      -- Show function signature when you type
      bind = true,
      
      -- Floating window settings
      floating_window = true,
      floating_window_above_cur_line = true,
      floating_window_off_x = 1,
      floating_window_off_y = 0,
      
      -- Hint settings
      hint_enable = true, -- Virtual hint text
      hint_prefix = "🐼 ", -- Prefix for hint text
      hint_scheme = "String",
      
      -- UI improvements
      handler_opts = {
        border = "rounded",
      },
      
      -- Always show signature help
      always_trigger = false, -- Not too disruptive
      auto_close_after = nil, -- Keep it open
      
      -- Extra trigger characters
      extra_trigger_chars = {},
      
      -- Highlight parameter
      hi_parameter = "LspSignatureActiveParameter",
      
      -- Use toggle to show/hide signature help
      toggle_key = nil, -- Can set to '<C-k>' if needed
      
      -- Timer settings
      timer_interval = 200, -- Refresh every 200ms
      
      -- Transparency
      transparency = nil, -- Use default window transparency
      
      -- Only show when cursor is inside function call
      trigger_on_newline = false,
      
      -- Log level
      log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log",
      debug = false,
    })
  end,
}
