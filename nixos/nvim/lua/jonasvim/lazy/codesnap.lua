return {
  'mistricky/codesnap.nvim',
  build = 'make',
  config = function()
    require('codesnap').setup({
      border = 'rounded',
      has_breadcrumbs = true,
      bg_theme = "#535c68",
      -- bg_theme = 'grape',
      watermark = '',
      save_path = '~/Pictures/CodeSnaps', -- Directory for snapshots
    })

    -- Keymap for saving snapshots in visual mode
    vim.api.nvim_set_keymap(
      'x',                      -- Visual mode
      '<leader>cs',             -- Keymap
      ':<C-u>CodeSnapSave<CR>', -- Command
      { noremap = true, silent = true, desc = 'Save snapshot to disk' }
    )
  end,
}
