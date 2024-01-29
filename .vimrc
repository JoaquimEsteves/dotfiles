"" Stop being compatible with the 1960's
"" This must be first, because it changes other options as a side effect.
"" Avoid side effects when it was already reset." Avoid side-effects by
if &compatible
  set nocompatible
endif

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


"" use gQ instead. Such a promiment key for such a minor feature is a pain in the ass.
map Q <Nop>

"" Command Line Editing Shortcuts
"" Use emacs style editing
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
" back one word
cnoremap <M-b> <S-Left>
inoremap <M-b> <S-Left>
" forward one word
cnoremap <M-f> <S-Right>
inoremap <M-f> <S-Right>
" Delete word forward
cnoremap <M-d> <S-Right><C-w>
inoremap <M-d> <S-Right><C-w>
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

" Deleted: Still need a bit more practise
" nnoremap <Leader>g :silent lgrep<Space>
" nnoremap <silent> [f :lprevious<CR>
" nnoremap <silent> ]f :lnext<CR>

" Clear highlighting by mashing escape in normal mode
nnoremap <silent><esc> :noh<return><esc>
nnoremap <silent><esc>^[ <esc>^[

" delete without yanking
" Also makes x and d have separate separate functionality! 
nnoremap x "_x
vnoremap x "_x

" replace currently selected text with default register
" without yanking it
" Note: That I've switched around the meaning of p and P.
vnoremap <leader>p "_c<C-o>P<Esc>
vnoremap <leader>P "_c<C-o>P<Esc>

"" REMOVE ME

"" FULL LINE
"" pre tweak me post



"" GENERAL CONFIGURATION

" Hit `%` on `if` to jump to `else`.
runtime macros/matchit.vim
" let matchit handle it
let c_no_curly_error=1
let c_no_bracket_error=1

" let g:netrw_keepdir=0


" Enable bash aliases!
let $BASH_ENV = "~/.bash_aliases"

"" Smarc case writting! Case insensitive unless /C or a capital letter in
"" search :)
set ignorecase
set smartcase


"" Don't wrap goddamn lines of text
set nowrap

"" Easily find your line
set cursorline

"" Folding!
"" By default, fold through indents
"" But set the default foldlevel to 99, so we don't start with everything
"" hidden away
set foldmethod=indent
set foldlevel=99

"" Tell the preview menu to bugger off
set completeopt=menuone,noselect,noinsert
"" Autoload file changes.
set autoread

"" Save undo changes somewhere on /tmp
set undofile
if has('nvim')
  "" Set the swap files to the vim default
  set directory=.,~/tmp,/var/tmp,/tmp
endif

"" MORE UPDATES YO
set updatetime=100
"" Tells me when I'm quitting unsaved files in a nicer way
"" really useful with `qall`
set confirm

"" Highlights the column (I am a beta...)
"" 
"" set cuc


"" Set ripgrep as the default vimgrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ -g\ \'!.git\/'
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

"" No more silly guessword! `8j` is now visually represented!!! This shit's
"" bananas. I love it
set relativenumber
"Show line numbers (next to relativenumber)
set number

"" Set the standard yank register to the godsdamned normal clipboard
set clipboard=unnamedplus

"" Make tabs look like 4 spaces visually
set tabstop=4
" Always allow me to see the dang ruler
set laststatus=2
" Search goodness!
"     Top tip - press "*" to search for the word under the cursor! Incredible
set incsearch "search as you type
" Highlight Search
set hlsearch  
" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

syntax enable
filetype plugin indent on

" set t_Co=256
set background=dark


"  ______________________________________________________________________
" /                                                                      \
" |                            Auto Commands                             |
" \________________________________________________________________  __'\
"                                                                  |/   \\
"                                                                   \    \\  .
"                                                                        |\\/|
"                                                                        / " '\
"                                                                        . .   .
"                                                                       /    ) |
"                                                                      '  _.'  |
"                                                                      '-'/    \
" 
"

" https://fosstodon.org/@yaeunerd/109828668917540080
" Auto resizes windows when vim's size changes
autocmd VimResized * wincmd =

"  _____________________________________________________________________
" /                                                                     \
" |                              PLUGINS                                |
" \_______________________________________________________________  __'\
"                                                                 |/   \\
"                                                                  \    \\  .
"                                                                       |\\/|
"                                                                       / " '\
"                                                                       . .   .
"                                                                      /    ) |
"                                                                     '  _.'  |
"                                                                     '-'/    \
" 

call plug#begin('~/.vim/plugged')

"" COLORS

Plug 'morhetz/gruvbox'
if has("nvim")
  Plug 'RRethy/nvim-base16'
endif
Plug 'christianchiarulli/nvcode-color-schemes.vim'

function! FixGruvColors()
  "" Tweaks to the coloring
  if has("nvim-0.8")
    hi! link @variable GruvboxBlue
    hi! link @type GruvboxGreen
    hi! link @constructor GruvboxGreen
    hi! link @function GruvboxYellow
    hi! link @function.call GruvboxYellow
    hi! link @method GruvboxYellow
    hi! link @identifier GruvboxAqua
    hi! link @special GruvboxGreen
    hi! link @string GruvboxOrange
    hi! link @include GruvboxRed
    hi! link @punctuation.delimiter Noise
    hi! link @string.regex GruvBoxRed 
    hi! link @keyword.return GruvBoxPurple
    hi! link @field GruvboxAqua
    "" TODO: https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
    hi! @lsp.type.parameter guifg=GruvBoxPurple
  else
    hi! link TSVariable GruvboxBlue
    hi! link TSFunction GruvboxYellow
    hi! link TSMethod GruvboxYellow
    hi! link Identifier GruvboxAqua
    hi! link Special GruvboxGreen
    hi! link String GruvboxOrange
    hi! link Include GruvboxRed
    hi! Function ctermfg=3
    hi! link Delimiter Noise
    hi! link TSStringRegex GruvBoxRed 
    hi! link TSKeywordReturn GruvBoxPurple
  endif
endfunction

Plug 'altercation/vim-colors-solarized'
Plug 'kyazdani42/blue-moon'
Plug 'fenetikm/falcon'
Plug 'bluz71/vim-nightfly-guicolors'
"" Allows me to _see_ the dang colors
"" Main Command: :XtermColorTable
"" :help xterm-color-table
Plug 'guns/xterm-color-table.vim'

"" Zen mode for vim
"" Usage: 
"" :Goyo
"" 
""     Toggle Goyo
"" 
"" :Goyo [dimension]
"" 
""     Turn on or resize Goyo
"" 
"" :Goyo!
Plug 'junegunn/goyo.vim'


" Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'


" CSV
" Main thing is: :RainbowAlign and :RainbowShrink
Plug 'mechatroner/rainbow_csv'

"" Move things!
"" Usage:
"" <A-k>   Move current line/selection up
"" <A-j>   Move current line/selection down
"" <A-h>   Move current character/selection left
"" <A-l>   Move current character/selection right
"" Works best with visual mode
Plug 'matze/vim-move'


"" An indent level object!
"" Usage:
"" <count>ai 	An Indentation level and line above.
"" <count>ii 	Inner Indentation level (no line above).
"" <count>aI 	An Indentation level and lines above/below.
"" Example:
""
"" 0 | if foo == "bar":
"" 1 |    print(foo)
"" 2 |    print(foo)
"" 3 |    print(foo)
"" 4 |    print(foo)
"" 5 |    print(foo)
""
"" Typing `dii` on line 1-4 would result in
""
"" 0 | if foo == "bar":
""
""
"" Typing `dai` on line 1-4 would result in:
""
"" 0 | <nothing>
""
"" `aI` is only useful for funny languages ALGOL like languages that have a word after an if, like bash:
""
"" 1 | if [ my_test ]; then
"" 2 |   echo 'foo'
"" 3 |   echo 'foo'
"" 4 |   echo 'foo'
"" 5 |   echo 'foo'
"" 6 | fi
"" Typing daI would delete lines 1-6
Plug 'urxvtcd/vim-indent-object'

" Neat css colors (mayyyyyyyybe)
"Plug 'norcalli/nvim-colorizer.lua'


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
"" Fancy way to do search
"" `:%Subvert/facilit{y,ies}/building{,s}/g`
Plug 'tpope/vim-abolish'


"" use gS to turn this:
"" <div id="foo">bar</div>
"" 
"" Into this:
"" 
"" <div id="foo">
""   bar
"" </div>
"" use gJ to do the opposite!
Plug 'AndrewRadev/splitjoin.vim'
"" use :Tab/|
"" FROM
"" |start|eat|left|
"" |12|5|7|
"" |20|5|15|
"" INTO
"" | start | eat | left |
"" | 12    | 5   | 7    |
"" | 20    | 5   | 15   |
"" HELP: http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
Plug 'godlygeek/tabular'
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
  Plug 'gfanto/fzf-lsp.nvim'
  Plug 'nvim-lua/plenary.nvim'
endif

if has("nvim-0.6")
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'nvim-treesitter/playground'
  "" Abuses tree sitter for pretty context colors
  Plug 'lukas-reineke/indent-blankline.nvim'
  "" auto-complete + snippets
  "" main one
  "" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  "" 9000+ Snippets
  "" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
  " lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
  "" Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
endif



call plug#end()

"" Fix the colors on ShowMarks so they don't look like a bloody disaster
highlight SignColumn     ctermfg=239 ctermbg=235
highlight SignatureMarkText ctermfg=Red ctermbg=235

"  _____________________________________________________________________
" /                                                                     \
" |                         CUSTOM FUNCTIONS                            |
" |                                                                     |
" |                 Call them with `call FuncName()`                    |
" \_______________________________________________________________  __'\
"                                                                 |/   \\
"                                                                  \    \\  .
"                                                                       |\\/|
"                                                                       / " '\
"                                                                       . .   .
"                                                                      /    ) |
"                                                                     '  _.'  |
"                                                                     '-'/    \

command! MakeTags !ctags -R --exclude=node_modules  --exclude=__pycache__ --exclude=.mypy_cache --exclude=*.json .
command! OpenVimRc :tabnew ~/.vimrc
command! OpenLspRc :tabnew ~/Projects/dotfiles/nvim/lua/lsp-config.lua
command! ClearColumn :set colorcolumn&
command! AddColumn :set colorcolumn=80,120
command! ToggleSmartCase :set smartcase!
command! Shfmt !shfmt -w -i 2 -ci -bn %
command! CopyFileName let @+ = expand('%')


"" Command I kept forgetting
"" For future reference: <C-W> T
command! MoveToTab :wincmd T

" See the difference between the current buffer and the original file
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis


function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction



function! Redir(cmd)
  """ Redirects the output of any command over to it's own split
  """ Usage:
  """   :call Redir('!pylint %')	
  """
  redir => output
      silent! execute(a:cmd )
  redir END
  let output = split(output, "\n")
  
  if bufwinnr('cmd.out') >0 
     bdelete cmd.out
  endif

  vnew cmd.out
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe noswapfile
  call setline(1, output)

  wincmd h
endfunction

"redirect any vim command output using Redir command.
command! -nargs=1 Redir call Redir(<f-args>)

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

function! TabCloseRight(bang)
    let cur=tabpagenr()
    while cur < tabpagenr('$')
        exe 'tabclose' . a:bang . ' ' . (cur + 1)
    endwhile
endfunction

function! TabCloseLeft(bang)
    while tabpagenr() > 1
        exe 'tabclose' . a:bang . ' 1'
    endwhile
endfunction

command! -bang TabCloseRight call TabCloseRight('<bang>')
command! -bang TabCloseLeft call TabCloseLeft('<bang>')

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
  "" use `:checkhealth` to setup proper terminal colors
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


if PlugLoaded('vim-indent-object')
  xmap ii <Plug>(indent-object_linewise-none)
  omap ii <Plug>(indent-object_linewise-none)

  xmap ai <Plug>(indent-object_linewise-start)
  omap ai <Plug>(indent-object_linewise-start)

  xmap iI <Plug>(indent-object_linewise-end)
  omap iI <Plug>(indent-object_linewise-end)

  xmap aI <Plug>(indent-object_linewise-both)
  omap aI <Plug>(indent-object_linewise-both)
endif

if PlugLoaded('coq_nvim')
  " Keybindings
  ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
  ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
  ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
  ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
  let g:coq_settings = { 'keymap.jump_to_mark': '', "keymap.recommended": v:false}
endif

if executable('emoji-fzf')
  " See: https://github.com/noahp/emoji-fzf 
  function! InsertEmoji(emoji)
    let @a = system('cut -d " " -f 1 | emoji-fzf get', a:emoji)
    normal! "agP
  endfunction

  command! -bang Emoj
	\ call fzf#run({
	\ 'source': 'emoji-fzf preview',
	\ 'options': '--preview ''emoji-fzf get --name {1}''',
	\ 'sink': function('InsertEmoji')
	\ })
endif



if PlugLoaded('goyo.vim')
  " let g:goyo_linenr = 1
  " let g:goyo_width = '50%'
endif


if PlugLoaded('mechatroner/rainbow_csv')
  command! ShrinkCSV :RainbowShrink
  command! AlignCSV :RainblowAlign
endif

if PlugLoaded('animate.vim')
  "" Doesn't animate the damned window if it's there's only one
  function! UpDown(delta)
    if winnr('$') == 1
      return
    endif
    call animate#window_delta_height(a:delta)
  endfunction
  "" SMOOTH AF
  nnoremap <silent> <C-Up>    :call UpDown(10)<CR>
  nnoremap <silent> <C-Down>  :call UpDown(-10)<CR>
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
  call FixGruvColors()
endif

if PlugLoaded('nvcode-color-schemes.vim') && !has("nvim")
  colorscheme nvcode
endif


if PlugLoaded('vim-gitgutter')
  let g:gitgutter_sign_added = '+'
  let g:gitgutter_sign_modified = '*'
  let g:gitgutter_sign_removed = '-'
  let g:gitgutter_sign_removed_first_line = '-'
  let g:gitgutter_sign_modified_removed = '-'
endif


if PlugLoaded('fzf.vim')
  let $FZF_DEFAULT_COMMAND = 'fd --type f'
  function! RipgrepFzf(query, fullscreen)
    let command_fmt = "rg --hidden --column --line-number --no-heading --color=always --smart-case --glob '!.git' -- %s || true"
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  "" custom ripgrep command that actually ignores .gitignore but not
  "" hidden files :)
  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
  "" REMEMBER:
  ""      Download fzf!
  "" 	C-t => Open in new tab
  "" 	C-x => Tmux vertical
  ""   	C-v => Tmux horizontal
  "" Classic Ctrl-F to search lines in opened buffers
  nnoremap <C-F> :BLines<CR>
  "" use good ol' rip grep
  nnoremap <M-f> :RG<CR>
  "" Search for files with git ls-files
  nnoremap <C-P> :GFiles<CR>
  "" Search _all_ files with fuzzy search
  nnoremap <C-G> :Files<CR>
endif

" Uses the same controls as ale. But uses neovims built-in lsp
if PlugLoaded("nvim-lspconfig")

  nnoremap <Leader>d :LspDetail<CR>
  nnoremap <Leader>h :LspHover<CR>
  nnoremap <Leader>H :LspSignatureHelp<CR>
  "" Follow  vim convention instead of <leader>gg
  "" Remember - <C-o> to go back! I always forget lol
  nnoremap <Leader>gg :LspDef<CR>
  nnoremap <Leader>f :LspFormatting<CR>
  "" navigation
  nnoremap <Leader>gn :LspDiagNext<CR>
  nnoremap <Leader>gp :LspDiagPrev<CR>
  nnoremap <Leader>gr :LspFindReferences<CR>

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
  let g:ale_enabled = 0

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
  let g:ale_echo_msg_format = '🔥 [ALE+%linter%] %code: %%s'

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



""" lsp's normal formatting will cock-up your marks
""" So if you have some format.sh in the $PATH you can just use it
command! Format !format.sh %
nnoremap <Leader>gf  :Format<CR>
