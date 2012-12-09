set nocompatible
filetype off " Required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'
"
" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
" Nice colours for our Vim
Bundle 'altercation/vim-colors-solarized'
" CoffeeScript support in Vim
Bundle 'kchmck/vim-coffee-script'
" Jade support
Bundle 'jade.vim'
" VCS
Bundle 'vcscommand.vim'
" C# Compiler support
Bundle 'gmcs.vim'
" Compilation of lonely files
Bundle 'SingleCompile'
" EasyMotion
Bundle 'Lokaltog/vim-easymotion'
" End of bundles

filetype plugin indent on
syntax on

" Some nice COLOURS! {{{
set background=dark
colorscheme solarized
" }}}

" Wearing LaTeX rubber gloves, oh my! {{{
autocmd BufWritePost,FileWritePost *.tex silent !if [ -f .rubber ]; then rubber -dfsq --cache --inplace `cat .rubber` & fi
" }}}

set expandtab
set shiftwidth=2
set softtabstop=2

" SingleCompile
nmap <F8> :SCCompile<cr> 
nmap <F9> :SCCompileRun<cr> 

" C# settings
autocmd BufNewFile,BufRead *.cs compiler gmcs
autocmd BufNewFile,BufRead *.cs set makeprg=make
