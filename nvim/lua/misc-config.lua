-- # vim: shiftwidth=4 expandtab:

local ma = require("module_available")

-- https://github.com/kosayoda/nvim-lightbulb
if ma("nvim-lightbulb") then
    -- Modifies the lightbulb plugin to show up as virtual text _only_
    local function LightBulbFunc()
        require("nvim-lightbulb").update_lightbulb({
            sign = {
                enabled = false,
            },
            -- See: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeActionKind
            -- We want everything EXCEPT source | source.fixAll
            -- Otherwise we get a stupid lightbult everywhere
            action_kinds = {
                "quickfix",
                "refactor",
                "refactor.extract",
                "refactor.inline",
            },
            virtual_text = {
                enabled = true,
                -- Text to show at virtual text
                text = "💡",
                -- see :help nvim_buf_set_extmark() for reference
                hl_mode = "combine",
            },
        })
    end

    vim.api.nvim_create_autocmd({'CursorHold','CursorHoldI'}, {
        desc = 'Prettier Lightbulb',
        callback = LightBulbFunc
    })
end

-- Draw pretty diagrams with arrow keys
if ma("venn") then
    local function Toggle_venn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
            vim.b.venn_enabled = true
            vim.cmd([[setlocal ve=all]])
            -- draw a line on HJKL keystokes
            vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
            -- draw a box by pressing "f" with visual selection
            vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
        else
            vim.cmd([[setlocal ve=]])
            vim.api.nvim_buf_del_keymap(0, "n", "J")
            vim.api.nvim_buf_del_keymap(0, "n", "K")
            vim.api.nvim_buf_del_keymap(0, "n", "L")
            vim.api.nvim_buf_del_keymap(0, "n", "H")
            vim.api.nvim_buf_del_keymap(0, "v", "f")
            vim.b.venn_enabled = nil
        end
    end

    local function Toggle_venn_double()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
            vim.b.venn_enabled = true
            vim.api.nvim_set_option_value('ve', 'all', { scope = 'local' })
            vim.cmd([[setlocal ve=all]])
            -- draw a line on HJKL keystokes
            vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBoxD<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBoxD<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBoxD<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBoxD<CR>", { noremap = true })
            -- draw a box by pressing "f" with visual selection
            vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
        else
            vim.api.nvim_set_option_value('ve', '', { scope = 'local' })
            -- vim.cmd([[setlocal ve=]])
            vim.api.nvim_buf_del_keymap(0, "n", "J")
            vim.api.nvim_buf_del_keymap(0, "n", "K")
            vim.api.nvim_buf_del_keymap(0, "n", "L")
            vim.api.nvim_buf_del_keymap(0, "n", "H")
            vim.api.nvim_buf_del_keymap(0, "v", "f")
            vim.b.venn_enabled = nil
        end
    end

    vim.api.nvim_create_user_command('ToggleVen', Toggle_venn, { desc = "pretty drawing" })
    vim.api.nvim_create_user_command('ToggleVenDouble', Toggle_venn_double,
        { desc = "pretty drawing, but with double-lines!" })
end

-- https://github.com/lukas-reineke/indent-blankline.nvim
if ma("indent_blankline") then
    require("ibl").setup({ scope = { enabled = false } })
end

if ma("oil") then
    local oil = require("oil")
    oil.setup({
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
        default_file_explorer = true,
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
            "size",
        },
        -- Buffer-local options to use for oil buffers
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = false,
        -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
        -- (:help prompt_save_on_select_new_entry)
        prompt_save_on_select_new_entry = true,
        -- Oil will automatically delete hidden buffers after this delay
        -- You can set the delay to false to disable cleanup entirely
        -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
        cleanup_delay_ms = 500,
        -- Constrain the cursor to the editable parts of the oil buffer
        -- Set to `false` to disable, or "name" to keep it on the file names
        constrain_cursor = "editable",
        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = false,
        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
        -- Additionally, if it is a string that matches "actions.<name>",
        -- it will use the mapping at require("oil.actions").<name>
        -- Set to `false` to remove a keymap
        -- See :help oil-actions for a list of all available actions
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
            ["<C-h>"] = {
                "actions.select",
                opts = { horizontal = true },
                desc = "Open the entry in a horizontal split",
            },
            ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
            ["<C-r>"] = "actions.preview",
            ["<C-c>"] = "actions.close",
            ["<C-l>"] = "actions.refresh",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["`"] = "actions.cd",
            ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory", mode = "n" },
            ["gs"] = "actions.change_sort",
            ["gx"] = "actions.open_external",
            ["g."] = "actions.toggle_hidden",
            ["g\\"] = "actions.toggle_trash",
        },
        -- Use only the ones defined above
        use_default_keymaps = false,
        view_options = { show_hidden = true },

        -- Doesn't seem to work
        -- git = {
        --     -- Return true to automatically git add/mv/rm files
        --     add = function(path)
        --         return true
        --     end,
        --     mv = function(src_path, dest_path)
        --         return true
        --     end,
        --     rm = function(path)
        --         return true
        --     end,
        -- },
    })

    vim.cmd([[
        function! SexyOil(bang, rest)
          if a:bang
            " Foo! behavior
            top split
          else
            bot split
          endif
          execute 'Oil' a:rest
        endfunction


        function! SexyVertOil(bang, rest)
          if a:bang
            " Foo! behavior
            vert split
            wincmd l
          else
            vert split
          endif
          execute 'Oil' a:rest
        endfunction

        "" Make the default Netrw commands available
        command! -bang -nargs=* -complete=dir Sex call SexyOil(<bang>0, <q-args>)
        command! -bang -nargs=* -complete=dir Vex call SexyVertOil(<bang>0, <q-args>)
        command! -bang -nargs=* -complete=dir Ex :Oil <args>
    ]])
end

-- from $VIMRUNTIME/example_init.lua
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    callback = function()
        vim.hl.on_yank()
    end,
})

local function reload_colorscheme()
    local current_color = vim.g.colors_name or 'default'
    print("Reloading " .. current_color)
    vim.cmd.colorscheme(current_color)
end

vim.keymap.set("n", "<F2>", reload_colorscheme, {})


---@return fun(): integer?
-- Usage:
-- ```lua
-- -- Assume there's 5 tabs and we're at tab 2
-- for tab in tab_order() do
--   -- tab = 2, 1, 3, 4, 5 ...
-- end
--
-- ```
local function tab_order()
    local n = vim.fn.tabpagenr('$')
    local current = vim.fn.tabpagenr()
    return coroutine.wrap(function()
        coroutine.yield(current)
        local left = current - 1
        local right = current + 1
        while left >= 1 or right <= n do
            if left >= 1 then
                coroutine.yield(left)
                left = left - 1
            end
            if right <= n then
                coroutine.yield(right)
                right = right + 1
            end
        end
    end)
end

---@return string
function _G.CustomTabLine_I_Hate_Lua()
    ---@type table<integer, string[]>
    local res = { [9999999] = {} }
    ---@type table<integer, string>
    --- Buffers always have the same name
    local all_buffer_to_name = {}

    local visible_chars = 0
    local col_size = vim.o.columns
    local number_of_tabs = vim.fn.tabpagenr('$')
    local cwd = vim.fn.getcwd()


    ---@param s string
    --- Removes all of the cruft with some JANK regex.
    local function visible_len(s)
        return #(s:gsub('%%#[^#]*#', ''):gsub('%%%d*T', ''):gsub('%%=', ''))
    end

    ---@param items string[]
    ---@param tab_nr integer
    ---@param force boolean?
    local function append(items, tab_nr, force)
        local tmp_vis = visible_chars
        for _, item in ipairs(items) do
            tmp_vis = tmp_vis + visible_len(item)
        end
        if force or tmp_vis < col_size then
            visible_chars = tmp_vis
            vim.list_extend(res[tab_nr], items)
        else
            visible_chars = visible_chars + 3
            vim.list_extend(res[tab_nr], { "..." })
        end
    end

    append({
        -- Default-highlighting for the tab. highlight-groups are denoted with %#hl-GroupName#%
        '%#TabLineFill#%T',
        -- Pushes the CWD to the right
        -- And then sets the color to `TAG`
        '%=%#Tag#',
        vim.fn.fnamemodify(cwd, ':~'),
    }, 9999999, true)

    local function get_buf_name(buffer_nr)
        if all_buffer_to_name[buffer_nr] ~= nil then
            return all_buffer_to_name[buffer_nr]
        end

        local buff_type = vim.fn.getbufvar(buffer_nr, '&buftype')

        if buff_type == 'quickfix' then
            return ''
        end

        if buff_type == 'terminal' then
            local cmd = vim.fn.matchstr(vim.fn.bufname(buffer_nr), '[^:]*$')
            return table.concat({ 'term[', buffer_nr, ']<', (cmd ~= '' and cmd or '?'), '>' }, '')
        end

        if buff_type == 'help' then
            return table.concat({ 'help<', vim.fn.fnamemodify(vim.fn.bufname(buffer_nr), ':t'), '>' }, '')
        end

        local buffer_name = vim.fn.fnamemodify(vim.fn.bufname(buffer_nr), ':~:.')

        if buffer_name == '' then
            return '[No Name]'
        end

        return buffer_name
    end


    ---@param buffer_nr integer
    ---@param selected_highlight string
    ---@param current_tab_buffer_to_name table<integer, string>
    ---@return string
    local function get_buf_display(buffer_nr, selected_highlight, current_tab_buffer_to_name)
        if current_tab_buffer_to_name[buffer_nr] ~= nil then
            return current_tab_buffer_to_name[buffer_nr]
        end
        local buffer_name = get_buf_name(buffer_nr)
        all_buffer_to_name[buffer_nr] = buffer_name

        if vim.fn.getbufvar(buffer_nr, '&modified') == 1 then
            return table.concat({ '%#WarningMsg#[', buffer_nr, ']', selected_highlight, buffer_name, ' ' }, '')
        end

        return table.concat({ '[', buffer_nr, ']', buffer_name, ' ' }, '')
    end

    ---@param tab_index integer
    --- It's its own function so we can do early returns
    local function do_the_thing(tab_index)
        -- for tab_index = 1, number_of_tabs do
        ---@type table<integer, string>
        local current_buffer_to_name = {}
        res[tab_index] = {}

        append({
            '%#TabLine#',
            '%' .. tab_index .. 'T',
            number_of_tabs ~= 1 and ('%#Directory#' .. tab_index .. ':%#TabLine#') or '',
        }, tab_index, true)


        if visible_chars > col_size then
            -- Append empty so we get the ellipsis anyway
            append({}, tab_index)
            return
        end

        ---@type string
        local selected_highlight = tab_index == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#'

        for _, b in ipairs(vim.fn.tabpagebuflist(tab_index)) do
            current_buffer_to_name[b] = get_buf_display(b, selected_highlight, current_buffer_to_name)
        end

        append({
            selected_highlight,
            table.concat(vim.tbl_values(current_buffer_to_name), ' '),
            '%#TabLine#',
        }, tab_index)
    end

    -- vim.iter(tab_order()):each(do_the_thing)
    for tab_index in tab_order() do
        do_the_thing(tab_index)
    end

    local real_res = {}
    for _, v in vim.spairs(res) do
        real_res[#real_res + 1] = table.concat(v, '')
    end

    return table.concat(real_res, '')
end

vim.go.tabline = '%!v:lua.CustomTabLine_I_Hate_Lua()'
