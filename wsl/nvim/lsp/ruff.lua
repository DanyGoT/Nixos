-- Get capabilities from nvim-cmp if available
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
end

return {
  cmd = { 'ruff', 'server', '--preview' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'ruff.toml',
    '.ruff.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  capabilities = capabilities,
  init_options = {
    settings = {
      -- Ruff language server settings
      logLevel = "info",
      -- Enable preview features
      preview = true,
      -- Lint settings
      lint = {
        enable = true,
        preview = true,
        -- Auto-fix on save
        run = "onType", -- "onType", "onSave", "off"
      },
      -- Format settings
      format = {
        enable = true,
        preview = true,
      },
      -- Code action settings
      codeAction = {
        enable = true,
        disableRuleComment = {
          enable = true,
        },
        fixViolation = {
          enable = true,
        },
      },
      -- Hover settings
      hover = {
        enable = true,
      },
    },
  },
  -- Disable hover capability to let pyright handle it
  -- Ruff will handle linting/formatting, pyright handles types/hover
  on_attach = function(client, bufnr)
    -- Disable ruff's hover capability, let pyright handle it
    client.server_capabilities.hoverProvider = false
  end,
}