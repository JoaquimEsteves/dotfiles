require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    incremental_selection = {
        enable = false,
    },
    ensure_installed = {'typescript', 'javascript'},
    -- rainbow = {
    --   enable = true,
    --   extended_mode = true,
    --   max_file_lines = 1000
    -- }
}


