vim.g.mapleader = ' '

-- Keymap for å åpne oil
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- Manual keybind to activate LSP completion
vim.keymap.set('i', '<c-space>', function()
  vim.lsp.completion.get()
end)

-- Better indent dany spesial
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<C-z>', '<Nop>')

-- Split resizing (using Alt + arrow keys since they're intuitive for resizing)
vim.keymap.set('n', '<A-Up>', ':resize -5<CR>', { silent = true, desc = 'Increase height' })
vim.keymap.set('n', '<A-Down>', ':resize +5<CR>', { silent = true, desc = 'Decrease height' })
vim.keymap.set(
  'n',
  '<A-Left>',
  ':vertical resize -5<CR>',
  { silent = true, desc = 'Decrease width' }
)
vim.keymap.set(
  'n',
  '<A-Right>',
  ':vertical resize +5<CR>',
  { silent = true, desc = 'Increase width' }
)

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<A-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- ThePrimeagen sine keymaps
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'J', 'mzJ`z')
-- vim.keymap.set('n', '<C-d>', '<C-d>zz')
-- vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

vim.keymap.set('v', '<leader>v', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set('n', '<leader>v', '"+p', { desc = 'Paste from system clipboard' })

vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')

-- disable the Q key
vim.keymap.set('n', 'Q', '<nop>')

vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('v', '<leader>s', [[y:%s/\V<C-r>"/<C-r>"/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>xx', '<cmd>!chmod +x %<CR>', { silent = true })

vim.keymap.set('n', '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>')
