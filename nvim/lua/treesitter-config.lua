-- # vim: shiftwidth=4 expandtab:
--
-- TREE SITTER IS A PITA
-- THE NEW TREE-SITTER-CLI REQUIRES A GLIBC VERSION THAT IS YOUNG AS FUCK
-- OR YOU JUST SPEND HALF AN HOUR COMPILING IT YOURSELF
--
local ma = require('module_available')

if not ma('nvim-treesitter') then
    -- just use normal regex
    vim.cmd [[syntax enable]]
    return
end

if ma('treesitter-modules') then
    -- The nvimtreesitter boys IN THEIR INFINITE WISDOWM
    -- Decided to remove `incremental_selection`
    -- They also made the configuration complete bullshit, but I don't want to
    -- be relying on this `treesitter-modules` too much
    local treesitter = require('treesitter-modules')
    treesitter.setup({
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<bs>",
            },
        }
    })
end

-- COMPARE THE OLD - SANE SOLUTION WITH THIS NONSENSE
-- Honestly this is the worst thing about nvim.
-- I undertand that treesitter ie eXpErImEnTaL
-- But it's been experimental for 6 fucking years.
-- Every major release of nvim involves feeding this stupid fucking tamagochi
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter.setup', {}),

    -- Stolen from https://github.com/MeanderingProgrammer/treesitter-modules.nvim
    callback = function(args)
        local buf = args.buf
        local filetype = args.match
        -- you need some mechanism to avoid running on buffers that do not
        -- correspond to a language (like oil.nvim buffers), this implementation
        -- checks if a parser exists for the current language
        local language = vim.treesitter.language.get_lang(filetype) or filetype
        if not vim.treesitter.language.add(language) then
            return
        end

        -- replicate `fold = { enable = true }`
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- replicate `highlight = { enable = true }`
        vim.treesitter.start(buf, language)

    end,
})

if ma('nvim-treesitter-textobjects') then
    -- configuration
    -- Another thing that used to _JUST WORK_
    require("nvim-treesitter-textobjects").setup {
        select = {
            lookahead = true,
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V',  -- linewise
                -- ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = false,
        },
        move = {
            -- whether to set jumps in the jumplist
            set_jumps = true,
        },
    }

    -- operator pending is for `delete{motion}` (for example)
    local operator_pending_and_visual = { "x", "o" }

    local select = require("nvim-treesitter-textobjects.select")

    -- TODO(Joaquim): UNSURE how happy I am about defining maps in here...
    -- Ideally all maps would just be on my `.vimrc` under some `PlugLoaded` thing
    vim.keymap.set(operator_pending_and_visual, "af", function()
        select.select_textobject("@function.outer", "textobjects")
    end)
    vim.keymap.set(operator_pending_and_visual, "if", function()
        select.select_textobject("@function.inner", "textobjects")
    end)
    vim.keymap.set(operator_pending_and_visual, "ac", function()
        select.select_textobject("@class.outer", "textobjects")
    end)
    vim.keymap.set(operator_pending_and_visual, "ic", function()
        select.select_textobject("@class.inner", "textobjects")
    end)


    -- The goddamn lua-api is so shit that I legitimately prefer vim-script syntax
    -- It's dogshit, don't do this
    -- vim.cmd[[
    -- command! SwapInnerParam :lua require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
    -- command! SwapOuterParam :lua require("nvim-treesitter-textobjects.swap").swap_next "@parameter.outer"
    -- ]]


    local normal_and_operator_pending_and_visual = { "x", "o", 'n' }
    local move = require("nvim-treesitter-textobjects.move")
    -- Functions
    -- Remaps `]f` - which is just the same as `gf` (ie: goto file)
    vim.keymap.set(normal_and_operator_pending_and_visual, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
    end)
    vim.keymap.set(normal_and_operator_pending_and_visual, "]F", function()
        move.goto_next_end("@function.outer", "textobjects")
    end)
    vim.keymap.set(normal_and_operator_pending_and_visual, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
    end)
    vim.keymap.set(normal_and_operator_pending_and_visual, "[F", function()
        move.goto_previous_end("@function.outer", "textobjects")
    end)

    -- K is for KLASS
    vim.keymap.set(normal_and_operator_pending_and_visual, "]k", function()
        move.goto_next_start("@class.outer", "textobjects")
    end)
    vim.keymap.set(normal_and_operator_pending_and_visual, "]K", function()
        move.goto_next_end("@class.outer", "textobjects")
    end)
    vim.keymap.set(normal_and_operator_pending_and_visual, "[k", function()
        move.goto_previous_start("@class.outer", "textobjects")
    end)
    vim.keymap.set(normal_and_operator_pending_and_visual, "[K", function()
        move.goto_previous_end("@class.outer", "textobjects")
    end)
    -- ]o for `lOOp`. ]l is already for the location list
    vim.keymap.set(normal_and_operator_pending_and_visual, "]o", function()
        move.goto_next_start({ "@loop.inner" }, "textobjects")
    end)
    vim.keymap.set(normal_and_operator_pending_and_visual, "[o", function()
        move.goto_previous_start({ "@loop.inner" }, "textobjects")
    end)
end
