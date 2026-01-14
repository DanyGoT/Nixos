-- Get capabilities from nvim-cmp if available
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
end

return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  },
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        -- Enable type checking
        typeCheckingMode = "basic", -- "off", "basic", or "strict"
        -- Auto-import completions
        autoImportCompletions = true,
        -- Better diagnostics
        diagnosticMode = "workspace", -- "openFilesOnly" or "workspace"
        -- Use library code for completions even if not imported
        stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
        -- Auto-search for type stubs
        autoSearchPaths = true,
        -- Use library code for better completions
        useLibraryCodeForTypes = true,
      },
    },
  },
}
