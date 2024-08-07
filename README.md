# nvim configuration

## features
+ manage plugin with [lazy.nvim](https://github.com/folke/lazy.nvim)
+ well structured configuration files
+ keymap optimized for HHKB
+ support truecolor and [neovide](https://neovide.dev/)
+ manual lsp server configuration
+ optimize for game development with lua

## install

### clone the repo and prepare the enviroments
```bash
# clone this repo
git clone https://github.com/Zwlin98/nvim.git ~/.config/nvim
# init neovim automatically
nvim
```

### in vim command line
```vim
" ensure neovim work properly
:checkheath
```

## dependencies

### language servers preconfigured

+ [clangd](https://clangd.llvm.org/) for c/c++
+ [gopls](https://github.com/golang/go) for go
+ [lua-language-server](https://github.com/LuaLS/lua-language-server) for lua
+ [marksman](https://github.com/artempyanykh/marksman) for markdown
+ [rust-analyzer](https://github.com/rust-lang/rust-analyzer) for lua

### formatters preconfigured

+ [stylua](https://github.com/JohnnyMorganz/StyLua)
+ [jq](https://jqlang.github.io/jq/)
+ [yamlfmt](https://github.com/google/yamlfmt)

## articles

+ [My nvim config in 2023 | Zwlin's Blog](https://blog.zwlin.io/post/2023-nvim/)
+ [2022 年的 neovim 配置方案 | Zwlin's Blog](https://blog.zwlin.io/post/2022-nvim/)

