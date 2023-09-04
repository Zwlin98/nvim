# nvim configuration

## features
+ manage plugin with [lazy.nvim](https://github.com/folke/lazy.nvim)
+ well structured configuration files
+ keymap optimized for HHKB
+ support truecolor and [neovide](https://neovide.dev/)

## install

### clone the repo and prepare the enviroments
```bash
# clone this repo
git clone git@github.com:Zwlin98/nvim.git ~/.config/nvim
# create a python enviroments for neovim (optional)
cd ~/.config/nvim && python -m venv nvim-python
cd $HOME && ./.config/nvim/nvim-python/bin/python3 -m pip install pynvim
# init neovim automatically
nvim
```

### in vim command line
```vim
" ensure neovim work properly
:checkheath
```
