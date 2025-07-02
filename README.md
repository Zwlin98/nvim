# Personal Neovim Configuration

A modern, well-structured Neovim configuration optimized for development productivity, featuring a clean plugin architecture and thoughtful keybindings designed for HHKB users.

## ✨ Features

### Core Features
- **Plugin Management**: Powered by [lazy.nvim](https://github.com/folke/lazy.nvim) with lazy loading for fast startup
- **Well-Structured Architecture**: Modular configuration with clear separation of concerns
- **HHKB Optimized**: Keybindings specifically designed for Happy Hacking Keyboard users
- **Modern UI**: Full truecolor support with beautiful themes and smooth animations
- **Game Development Focus**: Special optimizations for Lua-based game development
- **Remote Development**: Built-in support for remote development workflows

### Developer Experience
- **Intelligent Code Completion**: Advanced completion with [blink.cmp](https://github.com/Saghen/blink.cmp)
- **Smart Navigation**: Fast file and symbol navigation with [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- **Git Integration**: Comprehensive Git support with visual diff and conflict resolution
- **Syntax Highlighting**: Tree-sitter powered syntax highlighting with custom queries
- **Code Folding**: Intelligent folding with [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo)
- **Terminal Integration**: Seamless terminal workflow with smart window management

## 🚀 Installation

### Prerequisites
Ensure you have Neovim 0.9+ installed:
```bash
nvim --version
```

### Quick Setup
```bash
# Backup existing configuration (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this configuration
git clone https://github.com/Zwlin98/nvim.git ~/.config/nvim

# Start Neovim (plugins will be installed automatically)
nvim
```

### Post-Installation Verification
Run the following command in Neovim to ensure everything is working correctly:
```vim
:checkhealth
```

## 📦 Dependencies

### Language Servers (Pre-configured)
The configuration includes automatic setup for the following language servers:

- **[clangd](https://clangd.llvm.org/)** - C/C++ language support with advanced features
- **[gopls](https://github.com/golang/tools/tree/master/gopls)** - Official Go language server
- **[lua-language-server](https://github.com/LuaLS/lua-language-server)** - Lua with Neovim API support
- **[rust-analyzer](https://github.com/rust-lang/rust-analyzer)** - Rust language server
- **[pyright](https://github.com/microsoft/pyright)** - Python static type checker

### Code Formatters (Pre-configured)
- **[stylua](https://github.com/JohnnyMorganz/StyLua)** - Lua code formatter
- **[jq](https://jqlang.github.io/jq/)** - JSON processor and formatter
- **[yamlfmt](https://github.com/google/yamlfmt)** - YAML formatter

### Optional Dependencies
For enhanced functionality, consider installing:
- **ripgrep** - Fast text search (for grep functionality)
- **fd** - Fast file finder (alternative to find)
- **git** - Version control (for Git integrations)
- **nodejs & npm** - For additional language servers

## 🗂️ Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lazy-lock.json          # Plugin version lock file
├── after/                  # After-load configurations
│   └── ftplugin/          # Filetype-specific settings
├── ftdetect/              # Custom filetype detection
├── indent/                # Custom indentation rules
├── lsp/                   # Language server configurations
│   ├── c.lua             # C/C++ LSP setup
│   ├── go.lua            # Go LSP setup
│   ├── lua.lua           # Lua LSP setup
│   └── pyright.lua       # Python LSP setup
├── lua/
│   ├── basic.lua         # Basic Neovim settings
│   ├── keymaps.lua       # Global keybindings
│   ├── autocmds.lua      # Auto commands
│   ├── lsp.lua           # LSP configuration
│   ├── rikka.lua         # Custom utility functions
│   └── plugins/          # Plugin configurations
│       ├── common/       # General purpose plugins
│       ├── git/          # Git-related plugins
│       ├── theme/        # Color schemes and themes
│       ├── treesitter/   # Syntax highlighting
│       └── ui/           # User interface plugins
└── syntax/               # Custom syntax files
```

## ⌨️ Key Bindings

### Leader Key
- **Space** - Primary leader key

### File Navigation
- **`<M-e>`** - Find files with fuzzy search
- **`<M-r>`** - Switch between buffers
- **`<M-t>`** - Navigate tabs
- **`<M-p>`** - FzfLua builtin commands
- **`gf`** - Go to file under cursor

### Search & Replace
- **`<M-f>`** - Live grep in project
- **`<M-g>`** - Grep word under cursor
- **`<M-s>`** - Search current buffer lines
- **`?`** - Search word in current buffer

### Window Management
- **`<M-c>`** - Close current window
- **`<M-x>`** - Close current tab

### Code Navigation
- **`<M-z>`** - Jump list navigation
- **`gq`** - Document diagnostics

### Git Integration
- **`<C-h>`** - File commit history

## 🎨 Themes and UI

### Color Scheme
- **Primary**: Nightfox theme with custom modifications
- **Truecolor**: Full 24-bit color support
- **Consistent**: Unified color palette across all UI elements

### UI Components
- **Status Line**: Custom lualine configuration with Git integration
- **Tab Line**: Custom tabby setup with buffer information
- **File Explorer**: Neo-tree with Git status indicators
- **Notifications**: Snacks.nvim for elegant notifications

## 🔧 Customization

### Adding New Plugins
Create a new file in `lua/plugins/` and it will be automatically loaded:
```lua
-- lua/plugins/my-plugin.lua
return {
    "author/plugin-name",
    config = function()
        -- Plugin configuration
    end
}
```

### Custom Keybindings
Add keybindings using the rikka helper:
```lua
local rikka = require("rikka")
rikka.setKeymap("n", "<leader>x", ":command<CR>", { desc = "Description" })
```

### Language Server Setup
Add new language servers in the `lsp/` directory following the existing patterns.

## 🐛 Troubleshooting

### Plugin Issues
```vim
:Lazy health      " Check plugin health
:Lazy sync        " Update plugins
:Lazy clean       " Remove unused plugins
```

### General Health Check
```vim
:checkhealth      " Comprehensive health check
```

## 📚 Resources

### Related Articles
- [My nvim config in 2023 | Zwlin's Blog](https://blog.zwlin.io/post/2023-nvim/)
- [2022 年的 neovim 配置方案 | Zwlin's Blog](https://blog.zwlin.io/post/2022-nvim/)

### Documentation
- [Neovim Documentation](https://neovim.io/doc/)
- [Lua Guide for Neovim](https://neovim.io/doc/user/lua-guide.html)
- [Lazy.nvim Documentation](http,s://lazy.folke.io/)

## 📄 License

This configuration is open source and available under the MIT License.

