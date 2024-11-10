local function isModuleAvailable(name)
	if package.loaded[name] then
		return true
	else
		for _, searcher in ipairs(package.searchers or package.loaders) do
			local loader = searcher(name)
			if type(loader) == "function" then
				package.preload[name] = loader
				return true
			end
		end
		return false
	end
end

local ma = isModuleAvailable

-- https://github.com/kosayoda/nvim-lightbulb
if ma("nvim-lightbulb") then
	-- Modifies the lightbulb plugin to show up as virtual text _only_
	function _G.LightBulbFunc()
		require("nvim-lightbulb").update_lightbulb({
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
		})
	end

	vim.cmd([[autocmd CursorHold,CursorHoldI * lua LightBulbFunc()]])
end

-- https://github.com/lukas-reineke/indent-blankline.nvim
if ma("indent_blankline") then
	require("ibl").setup({ scope = { show_end = false } })
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
			-- "icon",
			"size",
			"mtime",
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
			["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
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
	})

	vim.cmd [[

function! SexyOil(bang, rest)
  if a:bang
    " Foo! behavior
    topleft split
  else
    botright split
  endif
  execute 'Oil' a:rest
endfunction


function! SexyVertOil(bang, rest)
  if a:bang
    " Foo! behavior
    vert botright split
  else
    vert topleft split
  endif
  execute 'Oil' a:rest
endfunction

"" Make the default Netrw commands available
command! -bang -nargs=* -complete=dir Sex call SexyOil(<bang>0, <q-args>)
command! -bang -nargs=* -complete=dir Vex call SexyVertOil(<bang>0, <q-args>)
command! -bang -nargs=* -complete=dir Ex :Oil --float <args>
]]
end
