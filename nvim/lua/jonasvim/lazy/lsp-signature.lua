return {
  'ray-x/lsp_signature.nvim',
  event = 'LspAttach',
  config = function()
    require('lsp_signature').setup({
      -- Show function signature when you type
      bind = true,
      
      -- Floating window settings - show above cursor line for less disruption
      floating_window = true,
      floating_window_above_cur_line = true,
      floating_window_off_x = 1,
      floating_window_off_y = 0,
      
      -- Hint settings - DISABLED for less intrusion
      hint_enable = false, -- Disabled: virtual text with panda emoji is too intrusive
      hint_prefix = "", -- No prefix needed since hints are disabled
      hint_scheme = "String",
      
      -- UI improvements
      handler_opts = {
        border = "rounded",
      },
      
      -- Less disruptive settings
      always_trigger = false, -- Only show when manually triggered or in specific contexts
      auto_close_after = 3, -- Auto-close after 3 seconds of no activity
      
      -- Extra trigger characters
      extra_trigger_chars = {},
      
      -- Highlight parameter
      hi_parameter = "LspSignatureActiveParameter",
      
      -- Manual toggle key
      toggle_key = '<C-k>', -- Use Ctrl+k to manually show/hide signature help
      
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
