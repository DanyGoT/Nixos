return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Completion sources
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    
    -- Snippet support (required by nvim-cmp)
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      
      -- Completion window appearance
      window = {
        completion = {
          border = "none",
          max_width = 50,
          max_height = 5,
          scrollbar = true,
          col_offset = 0,
          side_padding = 1,
        },
        documentation = {
          border = "none",
          max_width = 60,
          max_height = 8,
        },
      },
      
      -- Key mappings
      mapping = cmp.mapping.preset.insert({
        -- Navigate completion menu
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        
        -- Scroll documentation
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        
        -- Trigger completion manually
        ['<C-Space>'] = cmp.mapping.complete(),
        
        -- Close completion menu
        ['<C-e>'] = cmp.mapping.abort(),
        
        -- Accept completion
        ['<CR>'] = cmp.mapping.abort(), -- Enter closes menu instead of confirming
        ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Only Tab confirms
        
        -- Snippet navigation
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),
      }),
      
      -- Completion sources with priority
      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 }, -- Highest priority for LSP
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500, keyword_length = 4 }, -- Only after 4 chars
        { name = 'path', priority = 250 },
      }),
      
      -- Better sorting and matching
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score, -- Based on fuzzy matching score
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      
      -- Formatting
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          -- Kind icons
          local kind_icons = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "",
          }
          
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or '', vim_item.kind)
          
          -- Source name
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            luasnip = '[Snippet]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]
          
          return vim_item
        end,
      },
      
      -- Completion behavior
      completion = {
        completeopt = 'menu,menuone,noselect',
        keyword_length = 2, -- Start suggesting after 2 characters
      },
      
      -- Preselect first item
      preselect = require('cmp').PreselectMode.Item,
      
      -- Enable fuzzy matching
      matching = {
        disallow_fuzzy_matching = false,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
      },
      
      -- Experimental features
      experimental = {
        ghost_text = false, -- Disabled: too intrusive
      },
    })
  end,
}
