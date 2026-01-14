return {
  'folke/trouble.nvim',
  opts = {
    modes = {
      diagnostics = {
        -- Auto-follow cursor to current diagnostic
        auto_jump = true,
        -- Show preview window with full error message
        preview = {
          type = "split",
          relative = "win",
          position = "right",
          size = 0.3,
        },
        -- Group by file for better organization
        groups = {
          { "filename", format = "{file_icon} {basename:Title} {count}" },
        },
        -- Focus on the trouble window when opened
        focus = true,
      },
    },
    -- Better icons and formatting
    icons = {
      indent = {
        middle = "├╴",
        last = "└╴",
        top = "│ ",
        ws = "  ",
      },
    },
  },
  cmd = 'Trouble',
  keys = {
    {
      'tt',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      'tc',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Current Buffer Diagnostics (Trouble)',
    },
    {
      'tl',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      'tq',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
    {
      ']t',
      function()
        require('trouble').next({ skip_groups = true, jump = true })
      end,
      desc = 'Next Trouble Item',
    },
    {
      '[t',
      function()
        require('trouble').prev({ skip_groups = true, jump = true })
      end,
      desc = 'Previous Trouble Item',
    },
    {
      ']d',
      function()
        vim.diagnostic.goto_next()
      end,
      desc = 'Next Diagnostic',
    },
    {
      '[d',
      function()
        vim.diagnostic.goto_prev()
      end,
      desc = 'Previous Diagnostic',
    },
  },
}
