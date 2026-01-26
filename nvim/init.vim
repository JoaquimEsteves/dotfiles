"" let treesitter handle it
"" Turn it back on only when needed
syntax off

if has('vim_starting')
  setglobal nohidden
endif

set undofile
set number
set relativenumber


" Break insert change when making a new line.
" That way each inserted line is a different change that you can undo, without
" loosing all the lines typed before the last one.
inoremap <cr> <c-]><c-g>u<cr>

"" Somehow - it just looks better 🤷
set notermguicolors

set tabstop=4 softtabstop=0
set expandtab
" set tw=99
"
"" open help in a new tab
cabbrev thelp tab help

"" Show trailling whitespaces
" set list
"" Show tabs with >- and trailing whitespace with that little ball
set listchars=tab:>-,trail:∙
" set listchars=trail:∙
"" See: :help fo-table
" set formatoptions+=w

"" Make underscores demark a different word
"" Good for python
" set iskeyword-=_
let g:underscore_is_different_word = 0


nnoremap <F2> <CMD>call ToggleUnderscoreDifferentWord()<cr>
inoremap <F2> <CMD>call ToggleUnderscoreDifferentWord()<cr>


"" Resize windows
nnoremap <silent> <C-Down> :resize +1<CR>
nnoremap <silent> <C-Up> :resize -1<CR>
nnoremap <silent> <C-Right> :vertical resize -1<CR>
nnoremap <silent> <C-Left> :vertical resize +1<CR>

function! Rm()
  !mkdir -p /tmp/vim_trash
  echom 'Moved file ' . shellescape(expand('%')) . 'over to /tmp/vim_trash'
  call system("mv " .  shellescape(expand('%')) . ' /tmp/vim_trash')
  bd
endfunction

function! File_and_line()
  call setreg('*', expand('%') . ':' . line('.'))
  echom 'Placed ' . getreg('*') . ' in your clipboard'
endfunction

command! FileWithLine :call File_and_line()

function! FileName()
  call setreg('*', expand('%'))
  echom 'Placed ' . getreg('*') . ' in your clipboard'
endfunction

command! FileName :call FileName()

function! Stfupyright()

  "" Open the window that shows all of pyrights' errors on the current line
  lua vim.diagnostic.open_float({scope="line"})
  "" Change your cursor to go inside said window
  lua vim.diagnostic.open_float({scope="line"})

  let t=[]
  "" Add every submatch over to the list t
  %s#\[report.*\]#\=add(t,submatch(0))#gn
  "" Exit LSP window
  norm wq

  let t = uniq(sort(t))
  let @s = join(map(t, 'v:val[1:-2]'), ', ')


  norm $
  norm a  # pyright: ignore[
  norm "sp
  norm a]

endfunction

command! Stfupyright :call Stfupyright()

" When using `dd` in the quickfix list, remove the item from the quickfix list.
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction
:command! RemoveQFItem :call RemoveQFItem()
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>

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


function! ToggleUnderscoreDifferentWord()
    "" TODO THIS IS NOT REFLECTED ON EVERY BUFFER FOR SOME REASON - only
    "" sometimes
    if g:underscore_is_different_word
        echom 'Underscore is now NOT a different word'
        let g:underscore_is_different_word = 0
        set iskeyword+=_
    else
        echom 'Underscore is a different word'
        let g:underscore_is_different_word = 1
        set iskeyword-=_
    endif
endfunction

"" requires `aiksaurus`!
func Thesaur(findstart, base)
  if a:findstart
    "" TODO(Go to the end of the word...)
    return searchpos('\<', 'bnW', line('.'))[1] - 1
  endif
  let res = []
  let h = ''
  let not_found_emoj = "🤷"
  for l in systemlist('aiksaurus ' .. shellescape(a:base))
    if l[:3] == '=== '
      let h = '(' .. substitute(l[4:], ' =*$', ')', '')
    elseif l ==# 'Alphabetically similar known words are: '
      "" It's this emoji
      "" 🔮
      let h = not_found_emoj
    elseif l[0] =~ '\a' || (h ==# not_found_emoj && l[0] ==# "\t")
      call extend(res, map(split(substitute(l, '^\t', '', ''), ', '), {_, val -> {'word': val, 'menu': h}}))
    endif
  endfor
  return res
endfunc

if exists('+thesaurusfunc')
  set thesaurusfunc=Thesaur
endif

" Enable bash aliases!
" let $BASH_ENV = "~/.bash_aliases"

"" use gQ instead. Such a promiment key for such a minor feature is a pain in the ass.
" map Q <Nop>


"" Mappings!

"" set <Leader> to <Space>
let mapleader = " "

" Normal (must follow with an operator)
nnoremap <M-S-c> "+y

" wtf
nnoremap <Leader>y "+y
" Visual
xnoremap <M-S-c> "+y

" wtf
xmap <Leader>y "+y:echom 'Yanked to clipboard'<ENTER>

"" Paste
nnoremap <Leader>p "+p
xnoremap <Leader>p "+p  



"" Close the damn buffer
"" Have having stuff open
nmap <Leader>q :bd


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
" Open VIM, in VIM-Command mode. Short cut is now the same as in bash
cnoremap <C-x><C-e> <C-f>

" Clear highlighting by mashing escape in normal mode
nnoremap <silent><esc> :noh<return><esc>
nnoremap <silent><esc>^[ <esc>^[

" Hit `%` on `if` to jump to `else`.
runtime macros/matchit.vim


set showcmd
"" Allow virtual editing in Visual block mode.
"" Virtual editing means that the cursor can be positioned where there is
"" no actual character.  This can be halfway into a tab or beyond the end
"" of the line.  Useful for selecting a rectangle in Visual mode and
"" editing a table.
set virtualedit=block

set nohidden  " doesn't seem to bloody work!

"" Smarc case writting! Case insensitive unless /C or a capital letter in
"" search :)
set ignorecase
set smartcase

"" Folding!
"" By default, fold through indents
set foldmethod=indent  " treesitter will override this
set foldlevel=999  " Don't fold anything at the start
set foldcolumn=0  " set to 1-9 to see the folds on the left (looks kind fugly)

"" Tell the preview menu to bugger off
set completeopt=menu,menuone,noselect,noinsert,popup
"" Don't search all open files
set complete-=i
"" tell the pop-up menu to have the height of like 10 lines
set pumheight=10
"" Autoload file changes.
set autoread

"" MORE UPDATES YO
set updatetime=100
"" Tells me when I'm quitting unsaved files in a nicer way
"" really useful with `qall`
set confirm

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


filetype plugin indent on

" dont loose selection on indenting
xnoremap > >gv
xnoremap < <gv

" select the text that was last edited/pastededited/pasted
" nnoremap gV `[v`]

" https://fosstodon.org/@yaeunerd/109828668917540080
" Auto resizes windows when vim's size changes
autocmd VimResized * wincmd =

command! MakeTags !ctags -R --exclude=node_modules .
command! OpenVimRc :tabnew $MYVIMRC
command! OpenLspRc :tabnew $HOME/.config/nvim/lua/lsp-config.lua
"" For future reference: <C-W> T
command! MoveToTab :wincmd T
"" TODO: Add the band with different utilities
command! Ex :Oil
command! Exx :Oil --float
command! Vex :vsplit | :wincmd l | :Oil
command! Vexx :vsplit | :Oil
command! Sex :split | :wincmd j | :Oil
command! Sexx :split | :Oil


command! ListStashes :Gclog -g stash
command! TitleCaseLine :s/\v<(.)(\w*)/\u\1\L\2/g


lua <<EOF
local function preview_location_callback(_, result, method, _)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, 'No location found')
    return nil
  end
  local res = vim.tbl_islist(result) and result[1] or result
  print(vim.inspect(res))

  local uri = res.uri:gsub("file://", "")

  print("pedit +" .. res.range.start.line .. " " .. uri)
  vim.cmd("pedit +" .. ( res.range.start.line + 1) .. " " .. uri)
  vim.cmd("normal zt")

  return nil
end

function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

function how_about()
  vim.lsp.buf.hover()
  vim.lsp.buf.hover()
  vim.cmd("pedit")
end

EOF


nnoremap <silent> <c-w>} <cmd>lua peek_definition()<CR>
nnoremap <silent> <c-w>{ <cmd>lua how_about()<CR>


" command! -nargs=+ -bang PrettyBox :r! echo split(<q-args>, ' ')[0]




" See the difference between the current buffer and the original file
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
command! FollowSymLink execute "file " . resolve(expand("%")) | edit
"" Close all buffers. Re-open last edited one
command! CloseAllOtherBuffers :%bd|e#
command! CloseTabsRight :.+1,$tabdo :bd

"" Neovim will then reset this
colorscheme darkblue
hi! String ctermfg=red

"" READONLY and paramaters should be "constants"
hi! link @lsp.typemod.variable.readonly Constant
hi! link @lsp.type.parameter Constant


let g:loaded_matchparen=1

"" NETRW crap
"" See the way DOOM does it: https://github.com/doom-neovim/doom-nvim/blob/main/lua/doom/modules/features/netrw/init.lua
" Keeps the current directory and the browsing directory synced.
" Supposedly, This helps you avoid the move files error.
" It just keeps messing me up doe.
" Like when I open and close folders I want to then just press % and it _just
" works_
" so I leave it at the default 1
" let g:netrw_keepdir=0

" List style
" Remember you can cycle between whem with `i`
let g:netrw_liststyle=3


"" Set ripgrep as the default vimgrep
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

call plug#begin()


"" Use with
"" `:compiler pytest`
"" You can then invoke `:make` and run some pytests, getting back the errors
"" You can use it with vim-dispatch and pass flags to it, for example:
"" `:Make! -m 'not slow'`
Plug 'tartansandal/vim-compiler-pytest'

"" Use :UndotreeToggle to check out what's on your undotree!
"" You could also just do g- and g+
Plug 'mbbill/undotree'

"" Edit registers with
"" :Regedit
"" IT'S JANK - Just use
"" :let @<your-register='whatever you want'
" Plug 'jmattaa/regedit.vim'

"" Draw boxes with :VBox
"" Remember to set `set virtualedit=all`
"" (And then put it back with  `set virtualedit=block`
Plug 'jbyuki/venn.nvim'

"" Main thing is: :RainbowAlign and :RainbowShrink
"" Provide SELECT and UPDATE queries in RBQL: SQL-like transprogramming query language.
Plug 'mechatroner/rainbow_csv'
" Bbye gives you :Bdelete and :Bwipeout commands that behave like well designed citizens:
" 
"     Close and remove the buffer. Show another file in that window. Show an empty file if you've got no other files open.
" 
Plug 'moll/vim-bbye'
Plug 'stevearc/oil.nvim'
Plug 'dstein64/vim-startuptime'


Plug 'romainl/vim-devdocs'

"" use `:Redact` to redact text. Use `:Redact!` to clear
Plug 'dbmrq/vim-redacted'
"" A simple plugin that persists the words added with zG and zW to a spellfile specific to the current file or directory.
"" (zG - mark good; zW - mark bad)
"" You can also add a file called .dialectmain to a directory and all files in its subdirectories will use the spellfile there.
Plug 'dbmrq/vim-dialect'
"" `:Ditto` highlights the most frequent word in the current file or in the current visual selection
"" `:NoDitto` clears them
Plug 'dbmrq/vim-ditto'
Plug 'Mofiqul/vscode.nvim'
Plug '2kabhishek/co-author.nvim'
"" Use :CoAuthor when editing a commit message
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
" Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'dlvandenberg/tree-sitter-angular'
" Plug 'nvim-treesitter/nvim-treesitter-angular'
"" Move shit with alt
"" <A-k>   Move current line/selection up
"" <A-j>   Move current line/selection down
"" <A-h>   Move current character/selection left
"" <A-l>   Move current character/selection right
Plug 'matze/vim-move' 
"" An indent level object!
"" Usage:
"" <verb>ai 	An Indentation level and line above.
"" <verb>aI 	An Indentation level and lines above/below.
"" <verb>ii 	Inner Indentation level (no line above).
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
"" TPOPE GOD
""
"" :DB postgresql://etc
Plug 'tpope/vim-dadbod'
"" Surround words and stuff
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
"" Automatic indent rules
Plug 'tpope/vim-sleuth'
" ╭─────────────────────────────────────────────────────────────────────────────╮
" │                                                                             │
" │                            FUGITIVE AND PLUGINS                             │
" │                                                                             │
" ╰─────────────────────────────────────────────────────────────────────────────╯
"
"" :Git is good
Plug 'tpope/vim-fugitive'
"" Use :GV to browse commits
"" :GV! will only list commits that affected the current file
"" :GV? fills the location list with the revisions of the current file
"" :GV or :GV? can be used in visual mode to track the changes in the selected lines.
Plug 'junegunn/gv.vim'
"" it shows the first line of the commit message for the commit under the cursor in a :Gblame window.
Plug 'tommcdo/vim-fugitive-blame-ext'
"" Unlocks :GBrowse
"" Doesn't fucking work lol
"" Plug 'cedarbaum/fugitive-azure-devops.vim'



"" Comment with gc
Plug 'tpope/vim-commentary'
"" Fancy way to do search
"" `:%Subvert/facilit{y,ies}/building{,s}/g`
""
"" ALSO CONVERTS TO SNAKE CASE
"" using the cr mapping (mnemonic: CoeRce) followed by one of the following
"" characters:
"" 
""   c:       camelCase
""   p:       PascalCase
""   m:       MixedCase (aka PascalCase)
""   _:       snake_case
""   s:       snake_case
""   u:       SNAKE_UPPERCASE
""   U:       SNAKE_UPPERCASE
""   k:       kebab-case (not usually reversible; see |abolish-coercion-reversible|)
""   -:       dash-case (aka kebab-case)
""   .:       dot.case (not usually reversible; see |abolish-coercion-reversible|)
"" ALSO DOES COOL GREPPING
"" :S /box{,es}
Plug 'tpope/vim-abolish' 
"" Invoke `:Make` for async making!
"" Open it with `:Copen`
Plug 'tpope/vim-dispatch'
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

"" Quality of like. <Ctrl-w>z to toggle zoom on windows
Plug 'dhruvasagar/vim-zoom'

Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'gfanto/fzf-lsp.nvim'
"" HOLY FUCKING SHIT THIS ONE IS GOOD
"" Refactor TypeScript, JavaScript, Lua, C/C++, Golang, Python, Java, PHP, Ruby, C#
"" just type <leader>rf and then select using FZF
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'hiphish/rainbow-delimiters.nvim'
Plug 'nvim-treesitter/playground'
"" Abuses tree sitter for pretty context colors
Plug 'lukas-reineke/indent-blankline.nvim'

"" pretty tabs?
"" IT'S SHIT
" Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

call plug#end()


function! FixGruvColors()
  set notermguicolors

  " hi! DiffAdd        ctermfg=231 ctermbg=65 guifg=#ffffff guibg=#5f875f
  " hi! DiffChange     ctermfg=231 ctermbg=67 guifg=#ffffff guibg=#5f87af
  " hi! DiffDelete     ctermfg=231 ctermbg=133 guifg=#ffffff guibg=#af5faf
  " hi! DiffText       ctermfg=16 ctermbg=251 guifg=#000000 guibg=#c6c6c6
  highlight DiffAdd  guibg=#4b5632
  highlight DiffChange guibg=#4b1818
  highlight DiffDelete guibg=#6f1313
  highlight DiffText  guibg=#6f1313


  "" Tweaks to the coloring
  if has("nvim-0.8")
    hi! link @tag @constant
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
    hi! link @lsp.typemod.variable.readonly.typescript GruvBoxPurple
    " Importantly this will _not_ match a member of some defaultLibrary
    hi! link @lsp.typemod.function.defaultLibrary GruvBoxAqua
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



"" colorscheme retrobox
"" call FixGruvColors()

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
"" Doesn't work for some reason
" nnoremap <C-G> :GFiles<CR>
"" Search _all_ files with fuzzy search
nnoremap <C-P> :GFiles<CR>

inoremap <expr> <c-t> fzf#vim#complete#path('rg --files')

"" Requires to be called before plug#end...

"" After we've done all of our pluggin' installing
lua require("lsp-config") 

lua require("treesitter-config") 

"" Configs that don't require their own fancy file
lua require('misc-config')



" JUST CALL `norm @<macro-reg>`
" function! ExecuteMacroOverVisualRange()
"   echo "@".getcmdline()
"   execute ":'<,'>normal @".nr2char(getchar())
" endfunction

" xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR> 

set inccommand=nosplit

function! PlugLoaded(name)
    return has_key(g:plugs, a:name)
endfunction

if PlugLoaded('rainbow_csv')
  autocmd BufNewFile,BufRead *.csv   set filetype=csv_semicolon
endif


if PlugLoaded('vim-devdocs')
  let g:devdocs_open_command = "/mnt/c/Windows/SysWOW64/cmd.exe /c start /b"
endif

command! -nargs=1 Browse silent execute '!/mnt/c/Windows/SysWOW64/cmd.exe /c start /b' shellescape(<q-args>,1)

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

if PlugLoaded('nvim-ts-rainbow')
  hi! rainbowcol1 ctermfg=1 
  hi! rainbowcol2 ctermfg=2 
  hi! rainbowcol3 ctermfg=3 
  hi! rainbowcol4 ctermfg=4 
  hi! rainbowcol5 ctermfg=5
  hi! rainbowcol6 ctermfg=6
  hi! rainbowcol7 ctermfg=7
endif

if PlugLoaded('gruvbox')
  colorscheme gruvbox
  call FixGruvColors()
endif

"" echo resolve(expand('%:p'))
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
  nnoremap <Leader>l :LspLocList<CR>

  nnoremap <leader>rn :LspRename<CR>

  nnoremap <leader>rr :LspRestart<CR>

  "" Refactor :)
  ""     TOP TIP: use 'V' to select the whole line and then apply the
  ""     refactor
  vnoremap <Leader>a  :LspCodeRangeAction<CR>
  "" Also fixes simple errors inline!
  nnoremap <Leader>a  :LspCodeAction<CR>
endif

if PlugLoaded('vim-zoom')
   silent! unmap <C-w>m
   nmap <C-w>z <Plug>(zoom-toggle)
endif

autocmd BufNewFile,BufRead *.component.html set filetype=angular

function! s:SetDiffHighlights()
  if &background == "dark"
    highlight DiffAdd gui=bold guifg=none guibg=#2e4b2e 
    highlight DiffDelete gui=bold guifg=none guibg=#4c1e15 
    highlight DiffChange gui=bold guifg=none guibg=#45565c 
    highlight DiffText gui=bold guifg=none guibg=#996d74
  else 
    highlight DiffAdd gui=bold guifg=none guibg=palegreen 
    highlight DiffDelete gui=bold guifg=none guibg=tomato 
    highlight DiffChange gui=bold guifg=none guibg=lightblue 
    highlight DiffText gui=bold guifg=none guibg=lightpink
  endif
endfunction



augroup diffcolors
  autocmd!
  autocmd Colorscheme * call s:SetDiffHighlights()
augroup END

map Q <Nop>
