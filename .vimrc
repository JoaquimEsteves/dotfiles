" `matchit.vim` is built-in so let's enable it!
" Hit `%` on `if` to jump to `else`.
runtime macros/matchit.vim

"" Mappings!
""     Fun with EU keyboards
""     My non-US keyboard makes it hard to type [ and ].
""     FEAR NO MORE

nmap < [
nmap > ]
omap < [
omap > ]
xmap < [
xmap > ]

"" REMEMBER:
""      Download fzf!
"" 	C-t => Open in new tab
"" Classic Ctrl-F to search lines in opened buffers
nnoremap <C-F> :Lines<CR>
"" Search for files with git ls-files
nnoremap <C-P> :GFiles<CR>
"" Search _all_ files with fuzzy search
nnoremap <C-G> :Files<CR>

" Enable bash aliases!
let $BASH_ENV = "~/.bash_aliases"

" Ignore 1960's compatibility mode
set nocp
" Always allow me to see the dang ruler
set laststatus=2
" Search goodness!
"     Top tip - press "*" to search for the word under the cursor! Incredible
set incsearch "search as you type
set hlsearch  "Highlight Search
" Clear highlighting by bashing escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[
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

function! NoAutoGutter(info)
	"" Makes it so auto gutter doesn't run every other time
	autocmd! gitgutter CursorHold,CursorHoldI
	"" Add new git diffs on save
	autocmd BufWritePost * GitGutter
endfunction

"" PLUGINS
call plug#begin('~/.vim/plugged')
"" Typescript - React stuff
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
"" General formatter
Plug 'dense-analysis/ale'
"" Cute little visual things on marks!
Plug 'kshenoy/vim-signature'
"" Surround words and stuff
Plug 'tpope/vim-surround'
"" Use fuzzy search!
"" https://github.com/junegunn/fzf.vim
Plug '$HOME/.fzf'
Plug 'junegunn/fzf.vim'
" Git gutters! Tells me when a line has changed according to git diff
" top tip: jump in between 'hunk's with [c and ]c
Plug 'airblade/vim-gitgutter', { 'do': function('NoAutoGutter') }
call plug#end()



"" Fix the colors on ShowMarks so they don't look like a bloody disaster
highlight SignColumn     ctermfg=239 ctermbg=235
highlight SignatureMarkText ctermfg=Red ctermbg=235

" Activate ale for prettier + eslint

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'javascriptreact': ['prettier', 'eslint'],
\   'json': ['prettier', 'eslint'],
\}
" FIX ME LATER stylelint is not fucking colaborating
let g:ale_linter_aliases = {'jsx': ['css', 'javascript', 'javascriptreact']}
let g:ale_linters = {'jsx': ['stylelint', 'eslint']}
" ALE now __only__ tries to fix shit and lint on save
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
" OLD SCHOOL FUCK IT
" Just run prettier/your_prefered_formatter manually if ALE isn't collaborating
" nnoremap gp :silent %!prettier --stdin-filepath %<CR>
