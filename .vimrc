" `matchit.vim` is built-in so let's enable it!
" Hit `%` on `if` to jump to `else`.
" runtime macros/matchit.vim

" Ignore 1960's compatibility mode 
set nocp
" Always allow me to see the dang ruler
set laststatus=2

"how line numbers
set number
" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Modules!
execute pathogen#infect()
syntax on
filetype plugin indent on
" Solarized theme!
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
syntax enable
colorscheme solarized


"" PLUGINS
call plug#begin('~/.vim/plugged')
"" Typescript - React stuff
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
call plug#end()
