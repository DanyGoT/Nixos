return {
  'stevearc/oil.nvim',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
    { 'christoomey/vim-tmux-navigator' },
  },
  lazy = false,
  opts = {
    default_file_explorer = true,
    use_default_keymaps = true,
    columns = { 'icon' },
    -- Hide hidden files by default
    view_options = {
      show_hidden = false,
    },
    keymaps = {
      ['<C-h>'] = false,
      ['<C-j>'] = false,
      ['<C-k>'] = false,
      ['<C-l>'] = false,
      -- Remove the default 'H' binding first
      ['H'] = false,
      -- Add the new Shift+h binding
      ['<S-h>'] = function()
        require('oil').toggle_hidden()
      end,
    },
  },
  keys = {
  },
  config = function(_, opts)
    require('oil').setup(opts)

    -- Restore tmux navigator keymaps globally
    vim.keymap.set('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>')
    vim.keymap.set('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>')
    vim.keymap.set('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>')
    vim.keymap.set('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>')
  end,
}
