-- Get capabilities from nvim-cmp if available
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
end

return {
  cmd = { 'elixir-ls' },
  filetypes = { "elixir", "eex", "heex", "surface" },
  root_markers = {
    "mix.exs",
    ".git"
  },
  capabilities = capabilities,
  settings = {
    elixirLS = {
      -- Enable dialyzer for better completions, use short format
      dialyzerEnabled = true,
      dialyzerFormat = "dialyxir_short",
      -- Don't fetch deps (we manage with Nix)
      fetchDeps = false,
      -- Disable auto-inserting @spec suggestions
      suggestSpecs = false,
      -- Disable test lenses
      enableTestLenses = true,
    }
  },
  -- Configure discrete diagnostics for Elixir
  -- on_attach = function(client, bufnr)
  --   vim.defer_fn(function()
  --     vim.diagnostic.config({ virtual_text = false }, bufnr)
  --   end, 0)
  --
  --   -- Disable signature help for Elixir (annoying with macros)
  --   client.server_capabilities.signatureHelpProvider = nil
  -- end
}
