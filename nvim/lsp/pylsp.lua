-- Get capabilities from nvim-cmp if available
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
end

return {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_markers = {
    'requirements.txt', 'pyproject.toml', '.git',
  },
  capabilities = capabilities,
  settings = {
  },
}
