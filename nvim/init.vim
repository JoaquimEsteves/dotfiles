set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc


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
 

"" Requires to be called before plug#end...

"" After we've done all of our pluggin' installing
if PlugLoaded("nvim-lspconfig")
  "" treesitter is also here for conveniences' sake
  lua require("lsp-config") 
endif

"" After we've done all of our pluggin' installing
if PlugLoaded("nvim-treesitter")
  "" treesitter is also here for conveniences' sake
  lua require("treesitter-config") 
endif

"" Configs that don't require their own fancy file
lua require('misc-config')
