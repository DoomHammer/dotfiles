" Windows specific {
    if has('win32') || has ('win64')
        " Adds git runtime path so it is able to use Fugitive within and Bundle GVIM,
        " while using the "git bash only" option when installing git for windows

        " uses standard git install directories
        let gitdir='C:\Program Files (x86)\Git\bin'
        let gitdiralt='C:\Program Files\Git\bin'

        if isdirectory(gitdir)
            let $PATH.=';' .gitdir
        elseif isdirectory(gitdiralt)
            let $PATH.=';' . gitdiralt
        endif

    endif
" }

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
" The NerdTree
Bundle 'scrooloose/nerdtree'
" Nice colours for our Vim
Bundle 'altercation/vim-colors-solarized'
" CoffeeScript support in Vim
Bundle 'kchmck/vim-coffee-script'
" EasyMotion
Bundle 'Lokaltog/vim-easymotion'
" Vim Outliner
Bundle 'vimoutliner/vimoutliner'
" Python mode
Bundle 'klen/python-mode'
" Misc
Bundle 'xolox/vim-misc'
" Better session management
Bundle 'xolox/vim-session'
" What's a snake without Jedi powers?
Bundle 'DoomHammer/jedi-vim'
" Jade support
Bundle 'jade.vim'
" VCS
Bundle 'vcscommand.vim'
" C# Compiler support
Bundle 'gmcs.vim'
" Compilation of lonely files
Bundle 'SingleCompile'
" DWM-inspired split management
Bundle 'dwm.vim'
" Taglist to navigate within a project
Bundle 'taglist.vim'
" And of course auto-update of said tags
Bundle 'AutoTag'
" EditorConfig
Bundle 'editorconfig/editorconfig-vim'
" Ack, ack, ack
Bundle 'mileszs/ack.vim'
" Ag, the SilverSearcher
Bundle 'rking/ag.vim'
" End of bundles

filetype plugin indent on
syntax on

let g:pymode_rope = 0
let g:jedi#pydoc = ""
let g:jedi#rename_command = ""
let g:jedi#autocompletion_command = ""

" Some nice COLOURS! {{{
set background=dark
let g:solarized_termcolors=256
colorscheme solarized
" }}}

" Wearing LaTeX rubber gloves, oh my! {{{
autocmd BufWritePost,FileWritePost *.tex silent !if [ -f .rubber ]; then rubber -dfsq --cache --inplace `cat .rubber` & fi
" }}}

set expandtab
set shiftwidth=2
set softtabstop=2

" Better autocompletion for filenames, buffers, colors, etc.
set wildmenu
set wildmode=longest:full,full

" SingleCompile
nmap <F8> :SCCompile<cr> 
nmap <F9> :SCCompileRun<cr> 

" C# settings
autocmd BufNewFile,BufRead *.cs compiler gmcs
autocmd BufNewFile,BufRead *.cs set makeprg=make

" Session settings for mksession and vim-session
set sessionoptions=blank,buffers,curdir,folds,help,options,resize,tabpages,winpos,winsize
