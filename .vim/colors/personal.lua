local pallete = {
	--       =   1           2          3          4          5          6          7          8          9         10
	blueGray = { '#F8FAFC', '#F1F5F9', '#E2E8F0', '#CBD5E1', '#94A3B8', '#64748B', '#475569', '#334155', '#1E293B', '#0F172A', },
	coolGray = { '#F9FAFB', '#F3F4F6', '#E5E7EB', '#D1D5DB', '#9CA3AF', '#6B7280', '#4B5563', '#374151', '#1F2937', '#111827', },
	gray     = { '#FAFAFA', '#F4F4F5', '#E4E4E7', '#D4D4D8', '#A1A1AA', '#71717A', '#52525B', '#3F3F46', '#27272A', '#18181B', },
	trueGray = { '#FAFAFA', '#F5F5F5', '#E5E5E5', '#D4D4D4', '#A3A3A3', '#737373', '#525252', '#404040', '#262626', '#171717', },
	warmGray = { '#FAFAF9', '#F5F5F4', '#E7E5E4', '#D6D3D1', '#A8A29E', '#78716C', '#57534E', '#44403C', '#292524', '#1C1917', },
	red      = { '#FEF2F2', '#FEE2E2', '#FECACA', '#FCA5A5', '#F87171', '#EF4444', '#DC2626', '#B91C1C', '#991B1B', '#7F1D1D', },
	orange   = { '#FFF7ED', '#FFEDD5', '#FED7AA', '#FDBA74', '#FB923C', '#F97316', '#EA580C', '#C2410C', '#9A3412', '#7C2D12', },
	amber    = { '#FFFBEB', '#FEF3C7', '#FDE68A', '#FCD34D', '#FBBF24', '#F59E0B', '#D97706', '#B45309', '#92400E', '#78350F', },
	yellow   = { '#FEFCE8', '#FEF9C3', '#FEF08A', '#FDE047', '#FACC15', '#EAB308', '#CA8A04', '#A16207', '#854D0E', '#713F12', },
	lime     = { '#F7FEE7', '#ECFCCB', '#D9F99D', '#BEF264', '#A3E635', '#84CC16', '#65A30D', '#4D7C0F', '#3F6212', '#365314', },
	green    = { '#F0FDF4', '#DCFCE7', '#BBF7D0', '#86EFAC', '#4ADE80', '#22C55E', '#16A34A', '#15803D', '#166534', '#14532D', },
	emerald  = { '#ECFDF5', '#D1FAE5', '#A7F3D0', '#6EE7B7', '#34D399', '#10B981', '#059669', '#047857', '#065F46', '#064E3B', },
	teal     = { '#F0FDFA', '#CCFBF1', '#99F6E4', '#5EEAD4', '#2DD4BF', '#14B8A6', '#0D9488', '#0F766E', '#115E59', '#134E4A', },
	cyan     = { '#ECFEFF', '#CFFAFE', '#A5F3FC', '#67E8F9', '#22D3EE', '#06B6D4', '#0891B2', '#0E7490', '#155E75', '#164E63', },
	sky      = { '#F0F9FF', '#E0F2FE', '#BAE6FD', '#7DD3FC', '#38BDF8', '#0EA5E9', '#0284C7', '#0369A1', '#075985', '#0C4A6E', },
	blue     = { '#EFF6FF', '#DBEAFE', '#BFDBFE', '#93C5FD', '#60A5FA', '#3B82F6', '#2563EB', '#1D4ED8', '#1E40AF', '#1E3A8A', },
	indigo   = { '#EEF2FF', '#E0E7FF', '#C7D2FE', '#A5B4FC', '#818CF8', '#6366F1', '#4F46E5', '#4338CA', '#3730A3', '#312E81', },
	violet   = { '#F5F3FF', '#EDE9FE', '#DDD6FE', '#C4B5FD', '#A78BFA', '#8B5CF6', '#7C3AED', '#6D28D9', '#5B21B6', '#4C1D95', },
	purple   = { '#FAF5FF', '#F3E8FF', '#E9D5FF', '#D8B4FE', '#C084FC', '#A855F7', '#9333EA', '#7E22CE', '#6B21A8', '#581C87', },
	fuchsia  = { '#FDF4FF', '#FAE8FF', '#F5D0FE', '#F0ABFC', '#E879F9', '#D946EF', '#C026D3', '#A21CAF', '#86198F', '#701A75', },
	pink     = { '#FDF2F8', '#FCE7F3', '#FBCFE8', '#F9A8D4', '#F472B6', '#EC4899', '#DB2777', '#BE185D', '#9D174D', '#831843', },
	rose     = { '#FFF1F2', '#FFE4E6', '#FECDD3', '#FDA4AF', '#FB7185', '#F43F5E', '#E11D48', '#BE123C', '#9F1239', '#881337', },
	--       =   1           2          3          4          5          6          7          8          9         10
}

vim.cmd.highlight('clear')
vim.g.colors_name = 'personal'

--- @param name string
--- @param val vim.api.keyset.highlight
local hi = function(name, val)
	val.force = true
	val.cterm = val.cterm or {}
	vim.api.nvim_set_hl(0, name, val)
end


local which_gray = pallete.warmGray

local normal = { fg = which_gray[3], bg = which_gray[9] }
-- We let the background come from the terminal itself
-- We just assume that it's dark
-- normal = {
-- 	fg = '#D7D7D7',
-- 	-- What apple's color picker says is the color
-- 	-- But...it's actually slightly off!
-- 	-- bg = '#1E1E1E'
-- }

hi('Normal', normal)
hi('CursorLine', { bg = which_gray[8] })
hi('MatchParen', { reverse = true })

hi('Statement', { fg = pallete.red[5] })

hi('Identifier', { link = 'Normal' })

hi('Constant', { fg = pallete.indigo[4] })
hi('Type', { fg = pallete.teal[5], })

hi('Boolean', { fg = pallete.pink[3] })

hi('Comment', { dim = true })
hi('String', { fg = pallete.emerald[6], })


hi('Number', { link = 'Normal' })

hi('Operator', { fg = pallete.orange[4], bold = true })
hi('Delimiter', { fg = pallete.orange[3], bold = true })
hi('Function', { fg = pallete.yellow[3] })

hi('PreProc', { fg = pallete.red[6], italic = true, })
hi('Special', { fg = pallete.red[4], })
hi('Tag', { fg = pallete.purple[5], italic = true })
hi('Underlined', { underline = true, })
hi('Added', { fg = pallete.green[4], })
hi('Changed', { fg = pallete.yellow[4], })
hi('Removed', { fg = pallete.red[4], })
hi('Error', { fg = pallete.red[1], bg = pallete.red[4], })
hi('Todo', { fg = pallete.yellow[5], bg = pallete.yellow[2], })

hi('TabLineSel', { link = 'Special' })

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

-- LANGUAGE SPECIFIC
hi("@css.units", { link = "Special" })
hi("@property.css", { fg=normal.fg, bg=normal.bg, italic = true })

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
