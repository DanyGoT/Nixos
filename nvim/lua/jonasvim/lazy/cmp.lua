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
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      
      -- Key mappings
      mapping = cmp.mapping.preset.insert({
        -- Navigate completion menu
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        
        -- Scroll documentation
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        
        -- Trigger completion manually
        ['<C-Space>'] = cmp.mapping.complete(),
        
        -- Close completion menu
        ['<C-e>'] = cmp.mapping.abort(),
        
        -- Accept completion
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Only confirm explicitly selected items
        ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Tab confirms selected or first item
        
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
        { name = 'buffer', priority = 500, keyword_length = 3 }, -- Only after 3 chars
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
        completeopt = 'menu,menuone,noinsert',
        keyword_length = 1, -- Start suggesting after 1 character
      },
      
      -- Enable fuzzy matching
      matching = {
        disallow_fuzzy_matching = false,
        disallow_fullfuzzy_matching = false,
        disallow_partial_fuzzy_matching = false,
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
