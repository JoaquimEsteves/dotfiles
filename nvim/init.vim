set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc


"" NVIM PLUGIN CONFIGURATION

"" Requires to be called before plug#end...

"" After we've done all of our pluggin' installing
if PlugLoaded("nvim-lspconfig")
  "" treesitter is also here for conveniences' sake
  lua require("lsp-config") 
endif

lua require('misc-config')
