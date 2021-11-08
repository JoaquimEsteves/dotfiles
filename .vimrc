" Hit `%` on `if` to jump to `else`.
runtime macros/matchit.vim
" let matchit handle it
let c_no_curly_error=1
let c_no_bracket_error=1

"" open help in a new tab
cabbrev thelp tab help

"" Mappings!

"" set <Leader> to <Space>
let mapleader = " "

""     Fun with EU keyboards
""     My non-US keyboard makes it hard to type [ and ].
""     FEAR NO MORE

"" nmap < [
"" nmap > ]
"" omap < [
"" omap > ]
"" xmap < [
"" xmap > ]
"" does what it days on the tin (see function definition bellow)
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

"" Command Line Editing Shortcuts
"" Use emacs style editing
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
" back one word
cnoremap <M-b> <S-Left>
" forward one word
cnoremap <M-f> <S-Right>
" Delete word forward
cnoremap <M-d> <S-Right><C-w>
" Open VIM, in VIM. Short cut is now the same as in bash
cnoremap <C-x><C-e> <C-f>

"" Smooth scrolling 😎
map <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>
map <C-D> <C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>


"" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


" Clear highlighting by mashing escape in normal mode
nnoremap <silent><esc> :noh<return><esc>
nnoremap <silent><esc>^[ <esc>^[

"" GENERAL CONFIGURATION

" Enable bash aliases!
let $BASH_ENV = "~/.bash_aliases"

"" Smarc case writting! Case insensitive unless /C or a capital letter in
"" search :)
set ignorecase
set smartcase

"" Autoload file changes.
set autoread

"" Save undo changes somewhere on /tmp
set undofile


"" MORE UPDATES YO
set updatetime=100
"" Tells me when I'm quitting unsaved files in a nicer way
"" really useful with `qall`
set confirm

"" Highlights the column (I am a beta...)
"" 
"" set cuc
"" Set ripgrep as the default vimgrep
set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m,%f:%l:%m

"" No more silly guessword! `8j` is now visually represented!!! This shit's
"" bananas. I love it
set relativenumber

" Set the standard yank register to the godsdamned normal clipboard
set clipboard=unnamedplus
" Ignore 1960's compatibility mode
set nocp
" Always allow me to see the dang ruler
set laststatus=2
" Search goodness!
"     Top tip - press "*" to search for the word under the cursor! Incredible
set incsearch "search as you type
" Highlight Search
set hlsearch  
"how line numbers
set number
" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

syntax enable
filetype plugin indent on

set t_Co=256
set background=dark

" Modules!

"" PLUGINS
call plug#begin('~/.vim/plugged')

"" COLORS

Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'kyazdani42/blue-moon'
Plug 'fenetikm/falcon'
Plug 'bluz71/vim-nightfly-guicolors'
"" Allows me to _see_ the dang colors
"" Main Command: :XtermColorTable
"" :help xterm-color-table
Plug 'guns/xterm-color-table.vim'


Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'

"" Typescript - React stuff

"" SYNTAX
"" way too bloody many syntax highlighters
"" I'm not happy with either...
let js_files = [ 'javascript', 'javascriptreact' ]
let ts_files = [ 'typescript', 'typescriptreact' ]



"" autocmd FileType javascriptreact set syntax=typescriptreact
"" Plug 'HerringtonDarkholme/yats.vim'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }


"" Plug 'pangloss/vim-javascript'
"" Plug 'maxmellon/vim-jsx-pretty'

"" Plug 'pangloss/vim-javascript', { 'for': js_files }
"" Plug 'maxmellon/vim-jsx-pretty', { 'for': js_files } 
"" Plug 'leafgarland/typescript-vim', { 'for': ts_files }
"" Plug 'peitalin/vim-jsx-typescript', { 'for': ts_files }

"" If the need arises...
"" Plug 'jparise/vim-graphql'

"" General formatter
let ale_compatible = [ 'sh', 'css', 'sh', 'yaml' ]
Plug 'dense-analysis/ale', { 'for': ale_compatible  } 
"" Cute little visual things on marks!
Plug 'kshenoy/vim-signature'
"" TPOPE GOD
"" Surround words and stuff
Plug 'tpope/vim-surround'
"" Automatic indent rules
Plug 'tpope/vim-sleuth'
"" :Git is good
Plug 'tpope/vim-fugitive'
"" Comment with gc
Plug 'tpope/vim-commentary'
"" Use fuzzy search!
"" https://github.com/junegunn/fzf.vim
if executable('fzf')
  Plug '$HOME/.fzf'
  Plug 'junegunn/fzf.vim'
endif

"" Quality of like. <Ctrl-w>z to toggle zoom on windows
Plug 'dhruvasagar/vim-zoom'

"" REMOVED NERDTREE
"" It was just super heavy. Disliked it a lil' bit
"" Plug 'preservim/nerdtree'
"" When a file is changed or deleted or added, it will be highlighted in the NerdTree.
"" Plug 'Xuyuanp/nerdtree-git-plugin'
"" Neat nerd-icons :)
"" Plug 'ryanoasis/vim-devicons'
"" Plug 'tiagofumo/vim-nerdtree-syntax-highlight' 

" Git gutters! Tells me when a line has changed according to git diff
" top tip: jump in between 'hunk's with [c and ]c
function! NoAutoGutter(info)
  "" Makes it so auto gutter doesn't run every other time
  autocmd! gitgutter CursorHold,CursorHoldI
  "" Add new git diffs on save
  autocmd BufWritePost * GitGutter
endfunction

Plug 'airblade/vim-gitgutter', { 'do': function('NoAutoGutter') }
" Swag parentheses!
Plug 'kien/rainbow_parentheses.vim'
" Press F, go flying!
Plug 'easymotion/vim-easymotion'



function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release --locked
    else
      !cargo build --release --locked --no-default-features --features json-rpc
    endif
  endif
endfunction

if executable('cargo')
  Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
endif

if has("nvim-0.5")
  Plug 'neovim/nvim-lspconfig'
  Plug 'ray-x/lsp_signature.nvim'
Plug 'kosayoda/nvim-lightbulb'
endif

if has("nvim-0.6")
  "" SOON...
  "" Plug 'github/copilot.vim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'nvim-treesitter/playground'
  "" Abuses tree sitter for pretty context colors
  Plug 'lukas-reineke/indent-blankline.nvim'
endif



call plug#end()

"" Autocommand to start with rainbow parentheses
"" au VimEnter * RainbowParenthesesToggle
"" au Syntax * RainbowParenthesesLoadRound
"" au Syntax * RainbowParenthesesLoadSquare
"" au Syntax * RainbowParenthesesLoadBraces
"" au Syntax * RainbowParenthesesLoadChevrons

"" Fix the colors on ShowMarks so they don't look like a bloody disaster
highlight SignColumn     ctermfg=239 ctermbg=235
highlight SignatureMarkText ctermfg=Red ctermbg=235

" OLD SCHOOL FUCK IT
" Just run prettier/your_prefered_formatter manually if ALE isn't collaborating
" nnoremap gp :silent %!prettier --stdin-filepath %<CR>

"  _______________________________________________________________________
" /                                                                       \
" |                           CUSTOM FUNCTIONS                            |
" |                                                                       |
" |                   Call them with `call FuncName()`                    |
" \_________________________________________________________________  __'\
"                                                                   |/   \\
"                                                                    \    \\  .
"                                                                         |\\/|
"                                                                         / " '\
"                                                                         . .   .
"                                                                        /    ) |
"                                                                       '  _.'  |
"                                                                       '-'/    \

command! OpenVimRc :tabnew ~/.vimrc
command! ClearColumn :set colorcolumn&
command! AddColumn :set colorcolumn=80,120

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction


function! GetHighlightAtCursor()
  echo synIDattr(synID(line("."), col("."), 1), "name")
endfunction


function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction


function! FixTSRainbow()
  hi! rainbowcol1 ctermfg=1 
  hi! rainbowcol2 ctermfg=2 
  hi! rainbowcol3 ctermfg=3 
  hi! rainbowcol4 ctermfg=4 
  hi! rainbowcol5 ctermfg=5
  hi! rainbowcol6 ctermfg=6
  hi! rainbowcol7 ctermfg=7
endfunction



"" I FUCKING HATE VIM SCRIPT OMG
"" function! CallSort() range
""     " Get the line and column of the visual selection marks
""     let [lnum1, col1] = getpos("'<")[1:2]
""     let [lnum2, col2] = getpos("'>")[1:2]
""
""     " Get all the lines represented by this range
""     let lines = getline(lnum1, lnum2)
""   execute ":!echo " . join(lines, "\t") . "| xargs -n1 | sort"
"" endfunction

"" a b c a

""  ______________________________
"" /                              \
"" | nvim specific shenanigans  |
"" \________________________  __'\
""                          |/   \\
""                           \    \\  .
""                                |\\/|
""                                / " '\
""                                . .   .
""                               /    ) |
""                              '  _.'  |
""                              '-'/    \


if has("nvim")
  set inccommand=nosplit
  "" Assume I'm using a modern terminal lol
  "" See: https://github.com/termstandard/colors
  set termguicolors
endif

if (exists('+colorcolumn'))
    "" reset it to default:
    "" set colorcolumn&
    "" set colorcolumn=80,120
    highlight ColorColumn ctermbg=8
endif

""  ______________________________
"" /                              \
"" | plugin specific shenanigans  |
"" \________________________  __'\
""                          |/   \\
""                           \    \\  .
""                                |\\/|
""                                / " '\
""                                . .   .
""                               /    ) |
""                              '  _.'  |
""                              '-'/    \


function! PlugLoaded(name)
    return has_key(g:plugs, a:name)
endfunction


if PlugLoaded('animate.vim')
  "" SMOOTH AF
  nnoremap <silent> <C-Up>    :call animate#window_delta_height(10)<CR>
  nnoremap <silent> <C-Down>  :call animate#window_delta_height(-10)<CR>
  nnoremap <silent> <C-Left>  :call animate#window_delta_width(10)<CR>
  nnoremap <silent> <C-Right> :call animate#window_delta_width(-10)<CR>
endif

if PlugLoaded('nvim-ts-rainbow')
  hi! rainbowcol1 ctermfg=1 
  hi! rainbowcol2 ctermfg=2 
  hi! rainbowcol3 ctermfg=3 
  hi! rainbowcol4 ctermfg=4 
  hi! rainbowcol5 ctermfg=5
  hi! rainbowcol6 ctermfg=6
  hi! rainbowcol7 ctermfg=7
endif


if PlugLoaded('vim-markdown-composer')
  "" Call through :ComposerStart
  "" see `:help markdown-composer`
  let g:markdown_composer_autostart = 0
endif

if PlugLoaded('vim-colors-solarized')
  " Solarized theme!
  let g:solarized_termcolors=256
  let g:solarized_termtrans=1
  "" override the comment color to always be a nice (readable) dark green
  "" hi Comment ctermfg=64
endif

if PlugLoaded('nerdtree')
  "" AutoOpen Nerdtree (but don't focus on it)
  autocmd VimEnter * NERDTree
  autocmd VimEnter * wincmd p
  "" AutoClose NerdTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  nmap <silent> <C-n> :call NERDTreeToggleInCurDir()<CR>
endif

if PlugLoaded('gruvbox')
  colorscheme gruvbox

  hi! link TSVariable GruvboxBlue
  hi! link Identifier GruvboxAqua
  hi! link Special GruvboxGreen
  hi! link String GruvboxOrange
  hi! link Include GruvboxRed
  hi! Function ctermfg=3
  hi! link Delimiter Noise
  hi! link TSStringRegex GruvBoxRed 
endif


if PlugLoaded('vim-gitgutter')
  let g:gitgutter_sign_added = '✚'
  let g:gitgutter_sign_modified = '✹'
  let g:gitgutter_sign_removed = '-'
  let g:gitgutter_sign_removed_first_line = '-'
  let g:gitgutter_sign_modified_removed = '-'
endif


if PlugLoaded('vim-easymotion')
  " Enable default maps
  " See `help easymotion.txt` -> Default Mappings
  let g:EasyMotion_do_mapping = 1
  nnoremap F <NOP>
  nmap F <Plug>(easymotion-prefix)
endif

if PlugLoaded('fzf.vim')
	"" REMEMBER:
	""      Download fzf!
	"" 	C-t => Open in new tab
	"" 	C-x => Tmux vertical
	""   	C-v => Tmux horizontal
	"" Classic Ctrl-F to search lines in opened buffers
	nnoremap <C-F> :Lines<CR>
	"" use good ol' rip grep
	nnoremap <M-f> :Rg<CR>
	"" Search for files with git ls-files
	nnoremap <C-P> :GFiles<CR>
	"" Search _all_ files with fuzzy search
	nnoremap <C-G> :Files<CR>
endif

" Uses the same controls as ale. But uses neovims built-in lsp
if PlugLoaded("nvim-lspconfig")

  nnoremap <silent> <Leader>d :LspDetail<CR>
  " NOT WORKING YO
  " inoremap <buffer><silent> <C-y> <C-y><Cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> <Leader>h :LspHover<CR>
  "" Follow  vim convention instead of <leader>gg
  "" Remember - <C-o> to go back! I always forget lol
  nnoremap <silent> <Leader>gg :LspDef<CR>
  nnoremap <silent> <Leader>f :LspFormatting<CR>
  "" navigation
  nnoremap <Leader>gn :LspDiagNext<CR>
  nnoremap <Leader>gp :LspDiagPrev<CR>
  nnoremap <silent> <Leader>gr :LspFindReferences<CR>

  nnoremap <leader>rn :LspRename<CR>

  "" Refactor :)
  ""     TOP TIP: use 'V' to select the whole line and then apply the
  ""     refactor
  vnoremap <Leader>r  :LspCodeRangeAction<CR>
  "" Also fixes simple errors inline!
  nnoremap <Leader>r  :LspCodeAction<CR>
endif

if PlugLoaded('vim-zoom')
   silent! unmap <C-w>m
   nmap <C-w>z <Plug>(zoom-toggle)
endif

if PlugLoaded('ale')
  "" Follow [Google's shell style](https://google.github.io/styleguide/shellguide.html)
  let g:ale_sh_shfmt_options = '-i 2 -ci -bn'

  let g:ale_fixers = {
	\   '*': ['remove_trailing_lines', 'trim_whitespace'],
	\   'css': ['prettier'],
	\   'sh': ['shfmt'],
	\   'yaml': ['prettier', 'yamlfix']
	\}
  " ALE now __only__ tries to fix shit when I invoke `:AleFix`
  let g:ale_fix_on_save = 0
  "" let g:ale_lint_on_text_changed = 'never'
  "" let g:ale_lint_on_insert_leave = 0
  let g:ale_completion_enabled = 1
  let g:ale_completion_autoimport = 1
  let g:ale_completion_tsserver_remove_warnings = 1
  let g:ale_list_vertical = 1
  let g:ale_floating_preview = 1
  "" VIM's default window looks cute already :)
  let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
  let g:ale_cursor_detail = 0
  let g:ale_hover_cursor = 1
  let g:ale_completion_autoimport = 1
  let g:ale_echo_msg_format = '🔥 [%linter%] %code: %%s'

  "   nnoremap <Leader>d :ALEDetail<CR>
  "   "" By default, lints only on save
  "   "" but we can call the linter again
  "   nnoremap <Leader>l :ALELint<CR>

  "   nnoremap <Leader>f :ALEFix<CR>
  "   nnoremap <Leader>F :ALEFixSuggest<CR>

  "   nnoremap <Leader>h :ALEHover<CR>
  "   nnoremap <Leader>gg :ALEGoToDefinition -tab<CR>
  "   "" Follow  vim convention instead of <leader>gg
  "   "" Remember - <C-o> to go back! I always forget lol
  "   "" autocmd FileType typescript map <buffer> <c-]> :ALEGoToDefinition<CR>
  "   "" autocmd FileType typescriptreact map <buffer> <c-]> :ALEGoToDefinition<CR>

  "   "" navigation
  "   nnoremap <Leader>gf :ALEFirst<CR>
  "   nnoremap <Leader>gn :ALENext<CR>
  "   nnoremap <Leader>gp :ALEPrevious<CR>
  "   nnoremap <silent> gr :ALEFindReferences<CR>

  "   nnoremap <leader>rn :ALERename<CR>

  "   "" Refactor :)
  "   ""     TOP TIP: use 'V' to select the whole line and then apply the
  "   ""     refactor
  "   vnoremap <Leader>r  :ALECodeAction<CR>
  "   "" Also fixes simple errors inline!
  "   nnoremap <Leader>r  :ALECodeAction<CR>

  if has("nvim")
    let g:ale_virtualtext_cursor = 1
    let g:ale_virtualtext_prefix = "🔥 "
  endif
endif
