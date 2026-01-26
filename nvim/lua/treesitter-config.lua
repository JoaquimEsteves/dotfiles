-- It's shit for python
-- require("treesitter-context").setup({
--   max_lines = 3,
--   separator = '-',
--   min_window_height = 20,
--   line_numbers = true,
-- })

require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    textobjects = {
      move = {
        enable = true,
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      },
    },
    -- ensure_installed = {'typescript', 'javascript'},
    -- rainbow = {
    --   enable = true,
    --   extended_mode = true,
    --   -- max_file_lines = 1000
    -- }
}



vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    if require("nvim-treesitter.parsers").has_parser() then
      vim.opt.foldmethod = "expr"
      -- Don't get the difference between these two lol
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      -- Display the correct fold text according to treesitter
      -- (WITH COLORS!!!)

      -- opt, wo, etc weren't working
      vim.cmd([[
        set foldtext="v:lua.vim.treesitter.foldtext()"
      ]])
      -- vim.wo.foldtext = "v:lua.vim.treesitter.foldtext()"
    else
      vim.opt.foldmethod = "indent"
    end
  end,
})

vim.cmd[[
  set indentexpr=nvim_treesitter#indent()
]]
