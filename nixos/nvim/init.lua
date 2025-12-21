require('jonasvim')

vim.opt.laststatus = 3 -- Required for proper window handling

vim.cmd 'colorscheme vscode'
vim.cmd [[
  highlight Normal guibg=none ctermbg=none
  highlight NonText guibg=none ctermbg=none
]]
