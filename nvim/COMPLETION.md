# Completion System

## Overview
The completion system has been upgraded to use **nvim-cmp** with enhanced fuzzy matching, better sorting, and signature help for parameters.

## Features

### 1. Fuzzy Completion
- Fuzzy matching is fully enabled for all completion types
- Completions start appearing after typing just 1 character
- Smart sorting based on:
  - Exact matches (highest priority)
  - Fuzzy match score
  - Recently used items
  - Locality (items from nearby in the file)
  - Item kind (methods, functions, variables, etc.)

### 2. Completion Sources (in priority order)
1. **LSP** - Language Server Protocol (highest priority)
2. **LuaSnip** - Snippets
3. **Buffer** - Words from current and other open buffers (3+ characters)
4. **Path** - File system paths

### 3. Signature Help (Parameter Hints)
- Shows function signature in a floating window when typing
- Highlights the current parameter you're filling in
- Auto-closes after 3 seconds of inactivity to avoid clutter
- Manual toggle with `<C-k>` for on-demand help
- Virtual text hints disabled for less visual intrusion

### 4. LSP Enhancements

#### Go (gopls)
- **completeUnimported**: Suggests packages before you import them
- **deepCompletion**: Better suggestions for nested structures
- **usePlaceholders**: Disabled - allows you to type your own variable names
- Comprehensive hints for types, parameters, and values
- Static analysis enabled for better code intelligence

## Keybindings

### Completion Menu
- `<C-n>` / `<C-p>` - Navigate to next/previous item
- `<C-Space>` - Manually trigger completion
- `<CR>` (Enter) - Confirm selected item (won't auto-select)
- `<Tab>` - Confirm current selection or first item
- `<C-e>` - Close completion menu

### Documentation
- `<C-b>` / `<C-f>` - Scroll documentation up/down

### Signature Help
- `<C-k>` - Manually show signature help (in insert mode)
- Automatically shows when typing function parameters

### Snippets
- `<C-l>` - Jump to next snippet placeholder
- `<C-h>` - Jump to previous snippet placeholder

## Visual Indicators

Each completion item shows:
- **Icon** - Visual indicator of item type (function, variable, etc.)
- **Name** - The completion text
- **Kind** - Type of item (Method, Function, Variable, etc.)
- **Source** - Where the completion came from ([LSP], [Buffer], [Path], [Snippet])

## Behavior

### Non-Disruptive Completion
- Completions appear automatically after typing
- Menu shows without forcing a selection
- Won't interrupt your typing flow
- Press Escape or continue typing to dismiss
- No ghost text preview to keep the interface clean

### Context-Aware
- LSP provides context from your project structure
- Go modules are suggested based on your imports and go.mod
- Respects your language server configuration

## Troubleshooting

If completions aren't working:
1. Check that the LSP server is attached: `:LspInfo`
2. Ensure nvim-cmp is loaded: `:Lazy`
3. Check completion sources are available: `:CmpStatus` (if available)
4. Restart Neovim if needed

## Configuration Files

- `nvim/lua/jonasvim/lazy/cmp.lua` - Main completion configuration
- `nvim/lua/jonasvim/lazy/lsp-signature.lua` - Signature help configuration
- `nvim/lua/jonasvim/lsp_init.lua` - LSP integration
- `nvim/lsp/gopls.lua` - Go-specific settings
