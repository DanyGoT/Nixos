return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = {
    'go.mod',
    'go.work',
    '.git',
  },
  settings = {
    gopls = {
      -- Better completion settings
      completeUnimported = true, -- Suggest unimported packages
      usePlaceholders = true, -- Use placeholders for function parameters
      deepCompletion = true, -- Enable deep completion
      
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
