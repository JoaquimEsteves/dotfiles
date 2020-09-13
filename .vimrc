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
