-- Enable LSP servers
vim.lsp.enable({ 'luals', 'typescript-language-server', 'gopls', 'pylsp', 'csharp-ls' })

-- Set completeopt for better completion experience with nvim-cmp
vim.o.completeopt = 'menu,menuone,noselect'

-- Set border and highlight
vim.o.winborder = 'rounded'

-- Configure LSP handlers with borders
local border = 'rounded'

-- Custom hover handler that sets conceallevel for proper markdown rendering
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border,
  -- Ensure conceallevel is set to 1 in hover window for markdown rendering
  focusable = true,
})

-- Override the hover handler to set conceallevel in the floating window
local original_hover_handler = vim.lsp.handlers['textDocument/hover']
vim.lsp.handlers['textDocument/hover'] = function(...)
  local bufnr, winnr = original_hover_handler(...)
  if winnr then
    -- Set conceallevel to 1 in the hover window for proper markdown rendering
    vim.api.nvim_set_option_value('conceallevel', 1, { win = winnr })
  end
  return bufnr, winnr
end

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method('textDocument/implementation') then
      -- Create a keymap for vim.lsp.buf.implementation ...
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
