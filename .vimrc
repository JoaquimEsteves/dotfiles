"" # vim: shiftwidth=2 expandtab:
"" This is my vimrc
"" The idea is that it _should_ just work for both `vim` and `nvim`
"" I _might_ not have vim in some weird remote machine, and so we do a bunch
"" of checks
"" FOR NEOVIM NERDS: Your `init.vim` should basically just be:
"" ```vim
"" set runtimepath^=~/.vim runtimepath+=~/.vim/after
"" let &packpath = &runtimepath
"" source ~/.vimrc
"" ```
"" ______________________________________________________________________
""/                                                                      \
""|                                 SETS                                 |
""\________________________________________________________________  __'\
""                                                                 |/   \\
""                                                                  \    \\  .
""                                                                       |\\/|
""                                                                       / " '\
""                                                                       . .   .
""                                                                      /    ) |
""                                                                     '  _.'  |
""                                                                     '-'/    \
""
"" This is the meat and potatoes of vim.
"" 
"" Stop being compatible with the 1960's
"" This must be first, because it changes other options as a side effect.
"" Avoid side effects when it was already reset." Avoid side-effects by
if &compatible
  set nocompatible
endif
"" When I close a buffer _ACTUALLY_ close it
set nohidden
""Show (partial) command in the last line of the screen
set showcmd
"" Smarc case writting! Case insensitive unless /C or a capital letter in
"" search :)
set ignorecase
set smartcase
"" Don't wrap goddamn lines of text
set nowrap
"" Easily find your line
set cursorline
"" Nicer wildmenu
set wildmode=list:longest,full
"" Folding!
"" By default, fold through indents
"" But set the default foldlevel to 99, so we don't start with everything
"" hidden away
"" (Treesitter later changes this. But I'm unsure how happy I am about
"" that...)
set foldmethod=indent
"" Note that later on we reset this with treesitter
set foldlevel=99
"" Tell the preview menu to bugger off
set completeopt=menu,menuone,noselect,noinsert,popup
"" Autoload file changes.
set autoread
"" Save undo changes somewhere on /tmp
set undofile
if has('nvim')
  "" Set the swap files to the vim default
  "" Why the hell would they be stored in this ghasthly directory:
  "" $XDG_DATA_HOME/nvim/swap/
  set directory=.,~/tmp,/var/tmp,/tmp
endif
"" MORE UPDATES YO
set updatetime=100
"" Tells me when I'm quitting unsaved files in a nicer way
"" really useful with `qall`
set confirm
"" No more silly guessword! `8j` is now visually represented!!! This shit's
"" bananas. I love it
set relativenumber
"Show line numbers (next to relativenumber)
set number
"" Set the standard yank register to the godsdamned normal clipboard
"" set clipboard=unnamedplus
"" Make tabs look like 4 spaces visually
set tabstop=4
" Always allow me to see the dang ruler
set laststatus=2
" Search goodness!
" Top tip - press "*" to search for the word under the cursor! Incredible
set incsearch "search as you type
" Highlight Search
set hlsearch  
" Show file stats
set ruler
" Blink cursor on error instead of beeping (grr)
set visualbell
set encoding=utf-8
" set t_Co=256
set background=dark
"" Set ripgrep as the default vimgrep
"" and make it SANE
"" TODO(Joaquim): Credit the source of this, I forgot where it came from.
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ -g\ \'!.git\/'
  set grepformat=%f:%l:%c:%m,%f:%l:%m

  function! Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
  endfunction


  command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
  command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

  cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
  cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

  augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
  augroup END
endif
if has("nvim")
  set inccommand=nosplit
  "" Assume I'm using a modern terminal lol
  "" use `:checkhealth` to setup proper terminal colors
  "" See: https://github.com/termstandard/colors
  set termguicolors
endif

""  ______________________________________________________________________
"" /                                                                      \
"" |                                 Lets                                 |
"" \________________________________________________________________  __'\
""                                                                  |/   \\
""                                                                   \    \\  .
""                                                                        |\\/|
""                                                                        / " '\
""                                                                        . .   .
""                                                                       /    ) |
""                                                                      '  _.'  |
""                                                                      '-'/    \
"" <Leader> is now <Space>
let mapleader = " "
"" GENERAL CONFIGURATION
" Hit `%` on `if` to jump to `else`.
runtime macros/matchit.vim
" let matchit handle it
let c_no_curly_error=1
let c_no_bracket_error=1
" Enable bash aliases!
let $BASH_ENV = "~/.bash_aliases"

filetype plugin indent on
if ! has('nvim')
  syntax enable
endif

""  ______________________________________________________________________
"" /                                                                      \
"" |                          MAPS AND COMMANDS                           |
"" \________________________________________________________________  __'\
""                                                                  |/   \\
""                                                                   \    \\  .
""                                                                        |\\/|
""                                                                        / " '\
""                                                                        . .   .
""                                                                       /    ) |
""                                                                      '  _.'  |
""                                                                      '-'/    \

"" open help in a new tab
cabbrev thelp tab help
"" Open netrw/oil on the right with Ctrl-E
map <C-e> :Vex!<CR>
" Break insert change when making a new line.
" That way each inserted line is a different change that you can undo, without
" loosing all the lines typed before the last one.
inoremap <cr> <c-]><c-g>u<cr>
"" I prefer keeping the vim clipboard separate
vnoremap <Leader>y "+y:echom 'Yanked to clipboard'<ENTER>
vnoremap <C-C> "+y:echom 'Yanked to clipboard'<ENTER>

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
"" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" dont loose selection on indenting
xnoremap > >gv
xnoremap < <gv

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

if ! has('nvim')
  "" These boys come by default in NVIM but vim doesn't have them!
  "" From nvim's defaults

  "" use gQ instead. Such a promiment key for such a minor feature is a pain in the ass.
  "" In neovim Q repears the last recorded register
  map Q <Nop>

  "" & repeats the last substitution
  nnoremap & :&&<CR>
  nnoremap [q :cprevious
  nnoremap ]q :cnext
  nnoremap [l :lprevious
  nnoremap ]l :lnext
endif


command! MakeTags !ctags -R --exclude=node_modules  --exclude=__pycache__ --exclude=.mypy_cache --exclude=*.json .
command! OpenVimRc :tabnew ~/.vimrc
command! OpenLspRc :tabnew ~/Projects/dotfiles/nvim/lua/lsp-config.lua
command! ClearColumn :set colorcolumn&
command! AddColumn :set colorcolumn=80,120
command! ToggleSmartCase :set smartcase!
if executable('shfmt')
  command! Shfmt !shfmt -w -i 2 -ci -bn %
endif
command! CopyFileName let @+ = expand('%')
command! CopyFileNameWithLineNumber let @+ = expand('%') . ':' . line('.')
"" Stands for buffer delete
"" Deletes all buffers and then re-opens the one you were using before
"" Use with confirm so you don't lose your work!
command! Bd :%bd | e#
"" Command I kept forgetting
"" For future reference: <C-W> T
command! MoveToTab :wincmd T
" See the difference between the current buffer and the original file
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis

"" nvim (SUPPOSEDLY) does this by default - but it doesn't actually
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" redirect any vim command output using Redir command.
" Particularly useful for external commands
" Usage:
" Redir !pylint %
" Redir :messages
"
command! -nargs=1 Redir call Redir(<f-args>)
function! Redir(cmd)
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

command! GetHighlightAtCursor call GetHighlightAtCursor()
function! GetHighlightAtCursor()
  echo synIDattr(synID(line("."), col("."), 1), "name")
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

"
" Stolen from https://stackoverflow.com/a/72220548/6595024
" Invoke `ToggleResizeModel` and then press the arrow keys
"
command! ToggleResizeMode call ToggleResizeMode()

function! ToggleResizeMode()
  if s:KeyResizeEnabled
    call NormalArrowKeys()
    let s:KeyResizeEnabled = 0
  else
    call ResizeArrowKeys()
    let s:KeyResizeEnabled = 1
  endif
endfunction

function! NormalArrowKeys()
  " unmap arrow keys
  echom 'normal arrow keys'
  nunmap <Up>
  nunmap <Down>
  nunmap <Left>
  nunmap <Right>
endfunction

function! ResizeArrowKeys()
  " Remap arrow keys to resize window
  echom 'Resize window with arrow keys'
  nnoremap <Up>    :resize +2<CR>
  nnoremap <Down>  :resize -2<CR>
  nnoremap <Left>  :vertical resize -2<CR>
  nnoremap <Right> :vertical resize +2<CR>
endfunction

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

" When using `dd` in the quickfix list, remove the item from the quickfix list.
" Only works with a _real_ quickfix list like the one `:make` does
" Neovims diagnostic crap is (of course) more of a PITA to handle
" TODO(Joaquim): Add an enhancement so that this works for neovims
" `Diagnostics` too
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  copen
endfunction
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
autocmd FileType qf map <buffer> dd :call RemoveQFItem()<cr>

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

" Note that if we're copying this over to some new location that doesn't have
" `plugged` then all we godda do is comment all lines bellow
" Vim should still work as up until this stage everything was "normal"
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
"" Use :UndotreeToggle to check out what's on your undotree!
"" You could also just do g- and g+ (but that's jank)
Plug 'mbbill/undotree'
"" A simple plugin that persists the words added with zG and zW to a spellfile specific to the current file or directory.
"" (zG - mark good; zW - mark bad)
"" You can also add a file called .dialectmain to a directory and all files in its subdirectories will use the spellfile there.
Plug 'dbmrq/vim-dialect'
"" `:Ditto` highlights the most frequent word in the current file or in the current visual selection
"" `:NoDitto` clears them
"" (Useful when we're writting text and don't want to look ike a baboon"
Plug 'dbmrq/vim-ditto'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
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
" CSV
" Main thing is: :RainbowAlign and :RainbowShrink
Plug 'mechatroner/rainbow_csv'
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
"" Cute little visual things on marks!
Plug 'kshenoy/vim-signature'
"" TPOPE GOD
"" TODO(Joaquim): Add dispatch back for `Make`
"" Surround words and stuff
Plug 'tpope/vim-surround'
"" :Git is good
Plug 'tpope/vim-fugitive'
"" Automatic indent rules
Plug 'tpope/vim-sleuth'
"" Invoke `:Make` for async making!
"" Open it with `:Copen`
"" Godlike plugin
Plug 'tpope/vim-dispatch'

"" Fancy way to do search
"" `:%Subvert/facilit{y,ies}/building{,s}/g`
Plug 'tpope/vim-abolish'
"" Move things!
"" Usage:
"" <A-k>   Move current line/selection up
"" <A-j>   Move current line/selection down
"" <A-h>   Move current character/selection left
"" <A-l>   Move current character/selection right
"" Works best with visual mode
Plug 'matze/vim-move'
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
"" Quality of like. <Ctrl-w>z to toggle zoom on windows
Plug 'dhruvasagar/vim-zoom'
"" Start with `:RainbowParenthesesToggle`
"" nvim solution's with tree sitter are dogshit
Plug 'kien/rainbow_parentheses.vim'
" Press <Leader><Leader>F, go flying!
Plug 'easymotion/vim-easymotion'
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
" Git gutters! Tells me when a line has changed according to git diff
" top tip: jump in between 'hunk's with [c and ]c
function! NoAutoGutter(info)
  "" Makes it so auto gutter doesn't run every other time
  autocmd! gitgutter CursorHold,CursorHoldI
  "" Add new git diffs on save
  autocmd BufWritePost * GitGutter
endfunction
Plug 'airblade/vim-gitgutter', { 'do': function('NoAutoGutter') }
"" Use fuzzy search!
"" https://github.com/junegunn/fzf.vim
if executable('fzf')
  Plug '$HOME/.fzf'
  Plug 'junegunn/fzf.vim'
endif

if ! has('nvim')
  "" LSP but for vim.
  "" It's the good shit! Although it takes some configuring
  let ale_compatible = [ 'sh', 'css', 'sh', 'yaml' ]
  Plug 'dense-analysis/ale', { 'for': ale_compatible  } 
  "" Comment with gc
  "" nvim has this by default
  Plug 'tpope/vim-commentary'

endif

if executable('cargo') && has('nvim')
  function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
      if has('nvim')
        !cargo build --release --locked
      else
        !cargo build --release --locked --no-default-features --features json-rpc
      endif
    endif
  endfunction
  Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
endif

"" NVIM ONLY PLUGINS

if has("nvim")
  "" Select some text and type `:Refactor` and then tab complete
  "" (Doesn't work very well sadly, but it's close enough sometimes)
  Plug 'ThePrimeagen/refactoring.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
  "" Use :CoAuthor when editing a commit message
  Plug '2kabhishek/co-author.nvim'
  Plug 'RRethy/nvim-base16'
  "" Draw pictures!
  "" TODO(Joaquim): Add a little explanation here
  Plug 'jbyuki/venn.nvim'
  "" Oil is like NERDTREE but good
  Plug 'stevearc/oil.nvim'
  Plug 'neovim/nvim-lspconfig'
  "" Plug 'ray-x/lsp_signature.nvim'
  Plug 'kosayoda/nvim-lightbulb'
  "" Not updated in years :((((
  "" It was the best...(I'll consider forking this shit)
  "" Plug 'gfanto/fzf-lsp.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  "" Fixes treesitters recent bullshit
  Plug 'MeanderingProgrammer/treesitter-modules.nvim'
  "" Abuses tree sitter for pretty context colors
  "" There's a weird bug with this one.
  "" TODO: See if it's fixed in the future
  "" Plug 'lukas-reineke/indent-blankline.nvim'
  "" auto-complete + snippets
  "" main one
  "" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  "" 9000+ Snippets
  "" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
  " lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
  "" Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
  Plug 'mfussenegger/nvim-jdtls'
  "" Abuses tree sitter for pretty context colors
  Plug 'lukas-reineke/indent-blankline.nvim' 
endif
call plug#end()

"" Fix the colors on ShowMarks so they don't look like a bloody disaster
highlight SignColumn     ctermfg=239 ctermbg=235
highlight SignatureMarkText ctermfg=Red ctermbg=235

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



if PlugLoaded('gruvbox') && has('nvim')
  function! FixGruvColors()
    "" Tweaks to the coloring
    hi! link @constant GruvBoxPurple
    hi! link @constant.builtin GruvboxPurple
    hi! link @constructor GruvboxGreen
    hi! link @field GruvboxAqua
    hi! link @function GruvboxYellow
    hi! link @function.call GruvboxYellow
    hi! link @function.method.call GruvboxYellow
    hi! link @identifier GruvboxAqua
    hi! link @include GruvboxRed
    hi! link @keyword.return GruvBoxPurple
    hi! link @method GruvboxYellow
    hi! link @punctuation.delimiter Noise
    hi! link @special GruvboxGreen
    hi! link @string GruvboxOrange
    hi! link @string.regex GruvBoxRed 
    hi! link @string.regexp GruvBoxRed
    hi! link @tag.attribute.javascript GruvboxAqua
    hi! link @tag.attribute.tsx GruvboxAqua
    hi! link @type GruvboxGreen
    hi! link @variable GruvboxBlue
    "" TODO: https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
    "" Simply type `:Inspect` and then see what your LSP tells you
    hi! link @lsp.type.parameter GruvBoxPurple
    hi! link @lsp.type.function.javascript GruvboxYellow
    hi! link @lsp.typemod.variable.readonly GruvBoxBlueBold
    hi! link @lsp.typemod.variable.defaultLibrary GruvBoxAqua
    " Importantly this will _not_ match a member of some defaultLibrary
    hi! link @lsp.typemod.function.defaultLibrary GruvBoxAqua
  endfunction

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
" Note: The `lsp-config` will warn me if I'm using these as they _should_ be a
" bad habit
if PlugLoaded("nvim-lspconfig")
  nnoremap <Leader>d :LspDetail<CR>
  nnoremap <Leader>h :LspHover<CR>
  nnoremap <Leader>H <C-W>}<CR>
  "" Follow  vim convention instead of <leader>gg
  "" Remember - <C-o> to go back! I always forget lol

  nnoremap <Leader>gg :LspDef<CR>
  nnoremap <Leader>f :LspFormatting<CR>
  "" navigation
  nnoremap <Leader>gn :LspDiagNext<CR>
  nnoremap <Leader>gp :LspDiagPrev<CR>
  nnoremap <Leader>gr :LspFindReferences<CR>
  nnoremap <Leader>l :LspLocList<CR>

  nnoremap <leader>rn :LspRename<CR>

  "" Also fixes simple errors inline!
  nnoremap <Leader>ra  :LspCodeAction<CR>
  nnoremap <Leader>rr  :LspRestart<CR>
endif

if PlugLoaded('vim-zoom')
  silent! unmap <C-w>m
  nmap <C-w>z <Plug>(zoom-toggle)
endif

"" We have LSP at home
"" (Except, in some ways it was even better lol)
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

  nnoremap <Leader>d :ALEDetail<CR>
  "" By default, lints only on save
  "" but we can call the linter again
  nnoremap <Leader>l :ALELint<CR>

  nnoremap <Leader>f :ALEFix<CR>
  nnoremap <Leader>F :ALEFixSuggest<CR>

  nnoremap <Leader>h :ALEHover<CR>
  nnoremap <Leader>gg :ALEGoToDefinition -tab<CR>
  "   "" Follow  vim convention instead of <leader>gg
  "   "" Remember - <C-o> to go back! I always forget lol
  autocmd FileType typescript map <buffer> <c-]> :ALEGoToDefinition<CR>
  autocmd FileType typescriptreact map <buffer> <c-]> :ALEGoToDefinition<CR>

  "   "" navigation
  nnoremap <Leader>gf :ALEFirst<CR>
  nnoremap <Leader>gn :ALENext<CR>
  nnoremap <Leader>gp :ALEPrevious<CR>
  nnoremap <silent> gr :ALEFindReferences<CR>

  nnoremap <leader>rn :ALERename<CR>

  "" Refactor :)
  ""     TOP TIP: use 'V' to select the whole line and then apply the
  ""     refactor
  vnoremap <Leader>r  :ALECodeAction<CR>
  "" Also fixes simple errors inline!
  nnoremap <Leader>r  :ALECodeAction<CR>
endif
