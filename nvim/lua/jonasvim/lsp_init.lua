-- Setup LSP capabilities with nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Safely get cmp_nvim_lsp capabilities if available
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
end

-- Enable LSP servers with enhanced capabilities
vim.lsp.enable({ 'luals', 'typescript-language-server', 'gopls', 'pylsp', 'csharp-ls' })

-- Set completeopt for better completion experience with nvim-cmp
vim.o.completeopt = 'menu,menuone,noselect'

-- Set border and highlight
vim.o.winborder = 'rounded'

-- Configure LSP handlers with borders
local border = 'rounded'
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    
    -- Update client capabilities with nvim-cmp if not already set
    if has_cmp and client.server_capabilities then
      client.server_capabilities = vim.tbl_deep_extend('force', client.server_capabilities, capabilities)
    end
    
    if client:supports_method('textDocument/implementation') then
      -- Create a keymap for vim.lsp.buf.implementation ...
    end
    
    -- Enable signature help (parameter hints)
    if client:supports_method('textDocument/signatureHelp') then
      vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = args.buf, desc = 'Signature Help' })
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
