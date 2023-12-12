-- Badly hacked together LSP setup.
-- Don't copy this, it's a mess.

local nvim_lsp = require("lspconfig")
-- Doesn't work anymore
-- local coq = require("coq")

vim.diagnostic.config({
	source = true,

})

-- on_attach defined here. With the maps being defined in .vimrc
local on_attach = function(client, bufnr)
	-- SEE: help lspconfig-keybindings
	local buf_map = vim.api.nvim_buf_set_keymap
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end
	require("lsp_signature").on_attach({
		bind = false,
		hint_prefix = "",
		floating_window = false,
	})

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	-- COMMANDS
	vim.cmd("command! LspDef lua vim.lsp.buf.definition()")

	if vim.fn.has('nvim-0.8') == 1 then
		vim.cmd("command! LspFormatting lua vim.lsp.buf.format()")
		vim.cmd("command! -range LspCodeRangeAction <line1>,<line2>lua vim.lsp.buf.code_action()")
	else
		vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
		vim.cmd("command! -range LspCodeRangeAction <line1>,<line2>lua vim.lsp.buf.range_code_action()")
	end
	vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
	vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
	vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
	vim.cmd("command! LspFindReferences lua vim.lsp.buf.references()")
	vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
	vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
	vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
	-- DIAGNOSTICS
	if vim.fn.has('nvim-0.8') == 1 then
		vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
		vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
		vim.cmd('command! LspDetail lua vim.diagnostic.open_float({scope="line"})')
		vim.cmd("command! LspHelp lua vim.diagnostic.setloclist()")
	else
		vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
		vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
		vim.cmd("command! LspDetail lua vim.lsp.diagnostic.show_line_diagnostics()")
		vim.cmd("command! LspHelp lua vim.lsp.diagnostic.set_loclist()")
	end
end

-- PRETTYNESS
if vim.fn.executable("fzf") then
	require("fzf_lsp").setup()
end

-------------------------------------------------------------------------------
--                                                                           --
--                               Diagnostic LS                               --
--                                                                           --
-------------------------------------------------------------------------------
--
-- See: https://github.com/iamcco/diagnostic-languageserver

local filetypes = {
	javascript = "eslint",
	javascriptreact = "eslint",
	typescript = "eslint",
	typescriptreact = "eslint",
	-- Consider adding: https://github.com/astral-sh/ruff
	python = { "flake8", "mypy" },
	lua,
	json = "eslint",
	sh = "shellcheck",
}

local formatFiletypes = {
	javascript = "prettier",
	javascriptreact = "prettier",
	typescript = "prettier",
	typescriptreact = "prettier",
	-- yaml = "prettier",
	json = "prettier",
	sh = "shfmt",
	python = { "black", "isort" },
	lua = "stylua",
}

local linters = {
	eslint = {
		sourceName = "eslint",
		-- Slightly faster than eslint as it keeps a server running
		command = "eslint_d",
		rootPatterns = { ".eslintrc.js", "package.json", ".eslintrc.json" },
		debounce = 100,
		args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
		parseJson = {
			errorsRoot = "[0].messages",
			line = "line",
			column = "column",
			endLine = "endLine",
			endColumn = "endColumn",
			message = "🔥 ${message} [${ruleId}]",
			security = "severity",
		},
		securities = { [2] = "error", [1] = "warning" },
	},
	flake8 = {
		command = "flake8",
		args = { "--format=%(row)d,%(col)d,%(code).1s,%(code)s: Flake8 %(text)s", "-" },
		debounce = 100,
		rootPatterns = { ".flake8", "setup.cfg", "tox.ini" },
		offsetLine = 0,
		offsetColumn = 0,
		sourceName = "flake8",
		formatLines = 1,
		formatPattern = {
			"(\\d+),(\\d+),([A-Z]),(.*)(\\r|\\n)*$",
			{
				line = 1,
				column = 2,
				security = 3,
				message = 4,
			},
		},
		securities = {
			W = "warning",
			E = "error",
			F = "error",
			C = "error",
			N = "error",
		},
	},
	mypy = {
		command = "mypy",
		args = {
			"--follow-imports=silent",
			"--hide-error-codes",
			"--hide-error-context",
			"--no-color-output",
			"--no-error-summary",
			"--no-pretty",
			"--show-column-numbers",
			"%file",
		},
		rootPatterns = { "mypy.ini", ".mypy.ini", "pyproject.toml", "setup.cfg" },
		formatPattern = {
			"^.*:(\\d+?):(\\d+?): ([a-z]+?): mypy (.*)$",
			{
				line = 1,
				column = 2,
				security = 3,
				message = 4,
			},
		},
		securities = {
			error = "error",
		},
	},
	shellcheck = {
		command = "shellcheck",
		debounce = 100,
		args = { "--format=gcc", "-" },
		offsetLine = 0,
		offsetColumn = 0,
		sourceName = "shellcheck",
		formatLines = 1,
		formatPattern = {
			"^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
			{
				line = 1,
				column = 2,
				message = 4,
				security = 3,
			},
		},
		securities = {
			error = "error",
			warning = "warning",
			note = "info",
		},
	},
}

local formatters = {
	prettier = { command = "prettier", args = { "--stdin-filepath", "%filepath" } },
	black = { command = "python3", args = { "-m", "black", "--quiet", "-" } },
	isort = {
		command = "isort",
		args = { "--quiet", "-" },
	},
	shfmt = { command = "shfmt", args = { "-filename", "%filepath", "-i", "2", "-ci", "-bn" } },
	stylua = {
		command = "stylua",
		args = { "-" },
	},
}

nvim_lsp.diagnosticls.setup({
	on_attach = on_attach,
	filetypes = vim.tbl_keys(filetypes),
	init_options = {
		source = true,
		filetypes = filetypes,
		linters = linters,
		formatters = formatters,
		formatFiletypes = formatFiletypes,
	},
})

-------------------------------------------------------------------------------
--                                                                           --
--                                 Other LS                                  --
--                                                                           --
-------------------------------------------------------------------------------

-- Consider https://github.com/mtshiba/pylyzer
-- nvim_lsp.pylyzer.setup({ on_attach = on_attach })
nvim_lsp.pyright.setup({ on_attach = on_attach })
nvim_lsp.gopls.setup({ on_attach = on_attach })

nvim_lsp.tsserver.setup({
	on_attach = function(client)
		client.resolved_capabilities.document_formatting = false
		on_attach(client)
	end,
})

-- HTML + CSS

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.html.setup({ capabilities = capabilities })
nvim_lsp.cssls.setup({ capabilities = capabilities })
