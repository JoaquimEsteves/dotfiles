"" Allows me to re-use the vim plugins
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
"" Let tree-sitter handle it
"" Note that this goes in the end since
"" SOME plugin appears to set syntax to `enable`
syntax off

if PlugLoaded('vim-fugitive')
  "" UNLESS we open fugitive
  autocmd FileType fugitive syntax enable
endif


"  _____________________________________________________________________
" /                                                                     \
" |                       NVIM SPECIFIC PLUGINS                         |
" |                                                                     |
" |                 Needs to be called after plug#end                   |
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
 

"" After we've done all of our pluggin' installing
if PlugLoaded("nvim-lspconfig")
  lua require("lsp-config") 
endif

if PlugLoaded("nvim-treesitter")
"  "" treesitter is also here for conveniences' sake
  lua require("treesitter-config") 
endif

"" Configs that don't require their own fancy file
lua require('misc-config')
