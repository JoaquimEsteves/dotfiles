-- Reasonable Colors v0.4.0 — https://github.com/matthewhowell/reasonable-colors
-- A translation to nvim-lua
-- TODO(Joaquim): I HATE THIS

local pallete = {
	gray       = { '#f6f6f6', '#e2e2e2', '#8b8b8b', '#6f6f6f', '#3e3e3e', '#222222' },
	rose       = { '#fff7f9', '#ffdce5', '#ff3b8d', '#db0072', '#800040', '#4c0023' },
	raspberry  = { '#fff8f8', '#ffdddf', '#ff426c', '#de0051', '#82002c', '#510018' },
	red        = { '#fff8f6', '#ffddd8', '#ff4647', '#e0002b', '#830014', '#530003' },
	orange     = { '#fff8f5', '#ffded1', '#fd4d00', '#cd3c00', '#752100', '#401600' },
	cinnamon   = { '#fff8f3', '#ffdfc6', '#d57300', '#ac5c00', '#633300', '#371d00' },
	amber      = { '#fff8ef', '#ffe0b2', '#b98300', '#926700', '#523800', '#302100' },
	yellow     = { '#fff9e5', '#ffe53e', '#9c8b00', '#7d6f00', '#463d00', '#292300' },
	lime       = { '#f7ffac', '#d5f200', '#819300', '#677600', '#394100', '#222600' },
	chartreuse = { '#e5ffc3', '#98fb00', '#5c9b00', '#497c00', '#264500', '#182600' },
	green      = { '#e0ffd9', '#72ff6c', '#00a21f', '#008217', '#004908', '#062800' },
	emerald    = { '#dcffe6', '#5dffa2', '#00a05a', '#008147', '#004825', '#002812' },
	aquamarine = { '#daffef', '#42ffc6', '#009f78', '#007f5f', '#004734', '#00281b' },
	teal       = { '#d7fff7', '#00ffe4', '#009e8c', '#007c6e', '#00443c', '#002722' },
	cyan       = { '#c4fffe', '#00fafb', '#00999a', '#007a7b', '#004344', '#002525' },
	powder     = { '#dafaff', '#8df0ff', '#0098a9', '#007987', '#004048', '#002227' },
	sky        = { '#e3f7ff', '#aee9ff', '#0094b4', '#007590', '#00404f', '#001f28' },
	cerulean   = { '#e8f6ff', '#b9e3ff', '#0092c5', '#00749d', '#003c54', '#001d2a' },
	azure      = { '#e8f2ff', '#c6e0ff', '#008fdb', '#0071af', '#003b5e', '#001c30' },
	blue       = { '#f0f4ff', '#d4e0ff', '#0089fc', '#006dca', '#00386d', '#001a39' },
	indigo     = { '#f3f3ff', '#deddff', '#657eff', '#0061fc', '#00328a', '#001649' },
	violet     = { '#f7f1ff', '#e8daff', '#9b70ff', '#794aff', '#2d0fbf', '#0b0074' },
	purple     = { '#fdf4ff', '#f7d9ff', '#d150ff', '#b01fe3', '#660087', '#3a004f' },
	magenta    = { '#fff3fc', '#ffd7f6', '#f911e0', '#ca00b6', '#740068', '#44003c' },
	pink       = { '#fff7fb', '#ffdcec', '#ff2fb2', '#d2008f', '#790051', '#4b0030' },
}

vim.cmd.highlight('default')
vim.g.colors_name = 'reasonable_colours'

--- @param name string
--- @param val vim.api.keyset.highlight
local hi = function(name, val)
	val.force = true
	val.cterm = val.cterm or {}
	vim.api.nvim_set_hl(0, name, val)
end

-- --- @param orig table
-- --- @param new table
-- local extend = function(orig, new)
-- 	return vim.tbl_extend('force', orig, new)
-- end

local normal = { fg = pallete.gray[1], bg = pallete.gray[6], ctermfg = 'Grey' }

hi('Normal', normal)
hi('CursorLine', { bg = pallete.gray[5] })
hi('Constant', { italic = true })

hi('Comment', { fg = pallete.gray[3], ctermfg = 'Grey' })
hi('String', { fg = pallete.chartreuse[2], ctermfg = 'LightGreen' })
hi('Identifier', { link = 'Normal' })
hi('Function', { fg = pallete.yellow[2] })
-- hi('Keyword', {})
hi('Statement',
	{ fg = pallete.raspberry[3], bold = true, ctermfg = 'LightMagenta', cterm = { bold = true } })
hi('PreProc', { fg = pallete.raspberry[3], italic = true, ctermfg = 'LightRed' })
hi('Type',
	{ fg = pallete.indigo[2], ctermfg = 'LightBlue' })
hi('Special', { fg = pallete.cinnamon[3], ctermfg = 'LightRed' })
hi('Underlined',
	{ fg = pallete.indigo[3], underline = true, ctermfg = 'LightBlue', cterm = { underline = true } })
hi('Added', { fg = pallete.emerald[3], ctermfg = 'LightGreen' })
hi('Changed', { fg = pallete.azure[3], ctermfg = 'LightBlue' })
hi('Removed', { fg = pallete.red[3], ctermfg = 'LightRed' })
hi('Error', { fg = pallete.red[1], bg = pallete.red[4], ctermfg = 'White', ctermbg = 'DarkRed' })
hi('Todo', { fg = pallete.yellow[5], bg = pallete.yellow[2], ctermfg = 'Black', ctermbg = 'Yellow' })


hi('Operator', { link = 'Statement' })
hi('diffAdded', { link = 'Added' })
hi('diffRemoved', { link = 'Removed' })

hi('DiagnosticUnderlineWarn', { link = 'SpellCap' })
hi('DiagnosticUnderlineError', { link = 'SpellBad' })

-- Treesitter crap
hi('@string.documentation', { link = 'Comment' })

for _, i in ipairs({ 'regexp', 'escape', 'special' }) do
	hi('@string.' .. i, { link = 'SpecialChar' })
end

hi('@string.special.path', { link = 'Underlined' })
hi('@string.special.url', { link = 'Underlined' })

hi('@variable', { link = 'Identifier' })
hi('@property', { italic = true })
-- In toml everything is a property, so we don't want the italic then
hi('@property.toml', {})


-- LSP
hi('@lsp.type.parameter', { link = 'Constant' })
hi('@lsp.type.macro', { link = 'Macro' })
hi('@lsp.type.modifier', { link = 'Macro' })

hi('@lsp.type.namespace', { italic = true })
hi('@lsp.mod.deprecated', { strikethrough = true })
hi('@lsp.mod.readonly', { link = 'Constant' })

-- We have to do this _twice_, once to unlink whatever it had lying around
-- And THEN to actually set it to italic
-- For SOME reason - it just doesn't work out of the box and requires that I do it twice???

hi('@lsp.mod.builtin', { italic = true })

hi('@function.builtin', { italic = true })
hi('@type.builtin', { italic = true })
hi('@module', {})

local group = vim.api.nvim_create_augroup('personal_colors_group', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
	pattern = vim.g.colors_name,
	group = group,
	callback = function()
		-- FOR SOME REASON
		-- I need to do this with a timeout since the docs APPEAR TO BE LYING
		vim.defer_fn(function()
			hi('@lsp.mod.builtin', { italic = true })
		end, 1000)
	end
})
