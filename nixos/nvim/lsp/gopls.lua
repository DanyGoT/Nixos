-- Get capabilities from nvim-cmp if available
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
end

return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = {
    'go.mod',
    'go.work',
    '.git',
  },
  capabilities = capabilities,
  ettings = {
    gopls = {
      -- Better completion settings
      completeUnimported = true,
      -- usePlaceholders = false,
      deepCompletion = true,

      -- gofumpt = true,

      -- Improve analysis for better suggestions
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },

      -- Better hints
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },



      -- Static check
      staticcheck = true,

      -- Semantic tokens for better highlighting
      semanticTokens = true,
      -- Code lens
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
    },
  },
}
