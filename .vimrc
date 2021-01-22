" `matchit.vim` is built-in so let's enable it!
" Hit `%` on `if` to jump to `else`.
" runtime macros/matchit.vim

" Enable bash aliases!
let $BASH_ENV = "~/.bash_aliases"


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
"" Cute little visual things on marks!
Plug 'kshenoy/vim-signature'
call plug#end()

"" Fix the colors on ShowMarks so they don't look like a bloody disaster
highlight SignColumn     ctermfg=239 ctermbg=235
highlight SignatureMarkText ctermfg=Red ctermbg=235

