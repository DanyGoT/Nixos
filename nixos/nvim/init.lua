require('jonasvim')

vim.opt.laststatus = 3 -- Required for proper window handling

-- Enable diagnostics globally
vim.diagnostic.enable()

-- Configure how they appear
vim.diagnostic.config({
  virtual_text = { prefix = "💥", spacing = 2 },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.cmd 'colorscheme vscode'
vim.cmd [[
  highlight Normal guibg=none ctermbg=none
  highlight NonText guibg=none ctermbg=none
]]
