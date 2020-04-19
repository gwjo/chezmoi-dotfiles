" Install if missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Automaticallly install missing plugins on startup
if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall | q
endif

" Order matters for these two
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale'
Plug 'ekalinin/Dockerfile.vim'
Plug 'itspriddle/vim-shellcheck'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'mattn/emmet-vim'
Plug 'psf/black'
Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'


call plug#end()
