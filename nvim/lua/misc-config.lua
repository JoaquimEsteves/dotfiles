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

