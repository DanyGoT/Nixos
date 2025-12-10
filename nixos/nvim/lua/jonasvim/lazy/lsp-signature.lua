return {
  'ray-x/lsp_signature.nvim',
  event = 'InsertEnter',
  opts = {
    bind = true,
    hint_enable = false,    -- disable hints
    floating_window = true, -- use compact floating window instead
    doc_lines = 2,          -- no documentation, just signature
    max_height = 3,
    wrap = true,
    handler_opts = {
      border = "none"
    },
  }
}
