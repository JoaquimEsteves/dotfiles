-- Badly hacked together LSP setup.
-- Don't copy this, it's a mess.

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
-- It's a LUA only thing
require("neodev").setup({})

local nvim_lsp = require("lspconfig")
-- Doesn't work anymore
-- local coq = require("coq")
--
-- IN CASE SOMETHING BREAKS
-- Then checkout `:LspLog`
-- vim.lsp.set_log_level("TRACE")
vim.lsp.set_log_level("OFF")

vim.diagnostic.config({
	source = true,
})

-- The Keybindings themselves are set-up through the init.vim
-- Don't ask me why I did it this way
--
-- SEE: help lspconfig-keybindings
local function setUpLspCommands(ev)
	require("lsp_signature").on_attach({
		bind = false,
		hint_prefix = "",
		floating_window = false,
	})
	-- Enable completion triggered by <c-x><c-o>
	vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

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
		vim.cmd("command! LspLocList lua vim.diagnostic.setloclist()")
	else
		vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
		vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
		vim.cmd("command! LspDetail lua vim.lsp.diagnostic.show_line_diagnostics()")
		vim.cmd("command! LspLocList lua vim.lsp.diagnostic.set_loclist()")
	end
end

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = setUpLspCommands,
	-- We just need to set up the commands once
	once = true,
})

-- PRETTYNESS
if vim.fn.executable("fzf") then
	require("fzf_lsp").setup()
end

-------------------------------------------------------------------------------
--                                                                           --
--                                  GOLANG                                   --
--                                                                           --
-------------------------------------------------------------------------------
nvim_lsp.gopls.setup({})
-------------------------------------------------------------------------------
--                                                                           --
--                              Typescript + JS                              --
--                                                                           --
-------------------------------------------------------------------------------
nvim_lsp.ts_ls.setup({
	on_attach = function(client)
		client.resolved_capabilities.document_formatting = false
	end,
})
-------------------------------------------------------------------------------
--                                                                           --
--                                HTML + CSS                                 --
--                                                                           --
-------------------------------------------------------------------------------
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- I don't think I actually have these ones...
nvim_lsp.html.setup({ capabilities = capabilities })
nvim_lsp.cssls.setup({ capabilities = capabilities })
-------------------------------------------------------------------------------
--                                                                           --
--                                    Lua                                    --
--                                                                           --
-------------------------------------------------------------------------------
nvim_lsp.lua_ls.setup({})
----------------------------------------------------------------------------------------------------
--                                              JAVA                                              --
--                           https://github.com/mfussenegger/nvim-jdtls                           --
--                      On their README they recommend placing this stuff on                      --
--That wasn't working since we need the plug.vim to get all of our plugins So it's an auto command--
----------------------------------------------------------------------------------------------------
local function startJDTLS()
	require('jdtls').start_or_attach({
		-- This is a binary
		-- It _must_ be on the path!
		cmd = { 'jdtls' },
		root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
	})
end

vim.api.nvim_create_autocmd('FileType', {
	desc = 'Start jdtls on java files',
	pattern = 'java',
	group = vim.api.nvim_create_augroup('jdtls_lsp', { clear = true }),
	callback = startJDTLS,
})

-------------------------------------------------------------------------------
--                                                                           --
--                                    PHP                                    --
--                                                                           --
-------------------------------------------------------------------------------
nvim_lsp.phpactor.setup({})
-------------------------------------------------------------------------------
--                                                                           --
--                                  Python                                   --
--                                                                           --
-------------------------------------------------------------------------------
--
-- Consider https://github.com/mtshiba/pylyzer
-- nvim_lsp.pylyzer.setup({})
-- See: https://github.com/DetachHead/basedpyright
local function setup_based_pyright()
	local util = require 'lspconfig.util'

	local root_files = {
		'pyproject.toml',
		'setup.py',
		'setup.cfg',
		'requirements.txt',
		'Pipfile',
		'pyrightconfig.json',
		'.git',
	}

	local function organize_imports()
		local params = {
			command = 'basedpyright.organizeimports',
			arguments = { vim.uri_from_bufnr(0) },
		}

		local clients = vim.lsp.get_active_clients {
			bufnr = vim.api.nvim_get_current_buf(),
			name = 'basedpyright',
		}
		for _, client in ipairs(clients) do
			client.request('workspace/executeCommand', params, nil, 0)
		end
	end

	local function set_python_path(path)
		local clients = vim.lsp.get_active_clients {
			bufnr = vim.api.nvim_get_current_buf(),
			name = 'basedpyright',
		}
		for _, client in ipairs(clients) do
			if client.settings then
				client.settings.python = vim.tbl_deep_extend('force', client.settings.python or {}, { pythonPath = path })
			else
				client.config.settings = vim.tbl_deep_extend('force', client.config.settings,
					{ python = { pythonPath = path } })
			end
			client.notify('workspace/didChangeConfiguration', { settings = nil })
		end
	end

	return {
		default_config = {
			cmd = { 'basedpyright-langserver', '--stdio' },
			filetypes = { 'python' },
			root_dir = function(fname)
				return util.root_pattern(unpack(root_files))(fname)
			end,
			single_file_support = true,
			settings = {
				basedpyright = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = 'openFilesOnly',
					},
				},
			},
		},
		commands = {
			PyrightOrganizeImports = {
				organize_imports,
				description = 'Organize Imports',
			},
			PyrightSetPythonPath = {
				set_python_path,
				description = 'Reconfigure basedpyright with the provided python path',
				nargs = 1,
				complete = 'file',
			},
		},
		docs = {
			description = [[
https://detachhead.github.io/basedpyright

`basedpyright`, a static type checker and language server for python
]],
		},
	}
end

local configs = require 'lspconfig.configs'
-- tweak this to just use the one defined in the server_configurations when you
-- inevitably upgrade nvim
if not configs.basedpyright then
	configs.basedpyright = setup_based_pyright()
end
nvim_lsp.basedpyright.setup({})

local function setup_ruff_lsp()
	local util = require 'lspconfig.util'

	local root_files = {
		'pyproject.toml',
		'ruff.toml',
	}

	return {
		default_config = {
			cmd = { 'ruff-lsp' },
			filetypes = { 'python' },
			root_dir = util.root_pattern(unpack(root_files)) or util.find_git_ancestor(),
			single_file_support = true,
			settings = {},
		},
		docs = {
			description = [[
https://github.com/astral-sh/ruff-lsp

A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code transformation tool, written in Rust. It can be installed via pip.

```sh
pip install ruff-lsp
```

Extra CLI arguments for `ruff` can be provided via

```lua
require'lspconfig'.ruff_lsp.setup{
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}
```

  ]],
			root_dir = [[root_pattern("pyproject.toml", "ruff.toml", ".git")]],
		},
	}
end

if not configs.ruff_lsp then
	configs.ruff_lsp = setup_ruff_lsp()
end
nvim_lsp.ruff_lsp.setup({})



-------------------------------------------------------------------------------
--                                                                           --
--                                   CLANG                                   --
--                                                                           --
-------------------------------------------------------------------------------
nvim_lsp.clangd.setup({})
-------------------------------------------------------------------------------
--                                                                           --
--                               Diagnostic LS                               --
--                                                                           --
-------------------------------------------------------------------------------
--
-- See: https://github.com/iamcco/diagnostic-languageserver
--
--

local filetypes = {
	javascript = "eslint",
	javascriptreact = "eslint",
	typescript = "eslint",
	typescriptreact = "eslint",
	-- Now using ruff-lsp
	-- python = { "flake8", "mypy" },
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
	-- python = { "black", "isort" },
	-- lua = "stylua",
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
}

nvim_lsp.diagnosticls.setup({
	filetypes = vim.tbl_keys(filetypes),
	init_options = {
		source = true,
		-- WARNING!
		-- This is __NOT__ Javascript!
		-- Previously I had:
		--
		-- ```lua
		-- init_options = {
		--     source = true,
		--     filetypes,
		--     linters,
		--     formatters,
		--     formatFiletypes,
		-- }
		-- ```
		-- This is equivalent to:

		-- ```lua
		-- init_options = {
		--     source = true,
		--     [1] = filetypes,
		--     [2] = linters,
		--     [3] = formatters,
		--     [4] = formatFiletypes,
		-- }
		-- ```
		-- So TYPE IT OUT
		filetypes = filetypes,
		linters = linters,
		formatters = formatters,
		formatFiletypes = formatFiletypes,
	},
})
