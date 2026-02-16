function isModuleAvailable(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

-- https://github.com/kosayoda/nvim-lightbulb
if isModuleAvailable('nvim-lightbulb') then
    -- Modifies the lightbulb plugin to show up as virtual text _only_
    function _G.LightBulbFunc()
        require("nvim-lightbulb").update_lightbulb {
            sign = {
                enabled = false,
            },
            virtual_text = {
                enabled = true,
                -- Text to show at virtual text
                text = "💡",
                -- see :help nvim_buf_set_extmark() for reference
                hl_mode = "combine",
            },
        }
    end

    vim.cmd [[autocmd CursorHold,CursorHoldI * lua LightBulbFunc()]]
end

-- https://github.com/lukas-reineke/indent-blankline.nvim
if isModuleAvailable("indent_blankline") then
    require("indent_blankline").setup {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
    }
end

if isModuleAvailable('venn') then
    function _G.Toggle_venn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
            vim.b.venn_enabled = true
            vim.cmd [[setlocal ve=all]]
            -- draw a line on HJKL keystokes
            vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
            vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
            -- draw a box by pressing "f" with visual selection
            vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
        else
            vim.cmd [[setlocal ve=]]
            vim.api.nvim_buf_del_keymap(0, "n", "J")
            vim.api.nvim_buf_del_keymap(0, "n", "K")
            vim.api.nvim_buf_del_keymap(0, "n", "L")
            vim.api.nvim_buf_del_keymap(0, "n", "H")
            vim.api.nvim_buf_del_keymap(0, "v", "f")
            vim.b.venn_enabled = nil
        end
    end
end

