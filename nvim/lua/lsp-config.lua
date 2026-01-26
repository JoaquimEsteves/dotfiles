-- Badly hacked together LSP setup.
-- Don't copy this, it's a mess.


local nvim_lsp = require("lspconfig")
--
-- IN CASE SOMETHING BREAKS
-- Then checkout `:LspLog`
-- vim.lsp.set_log_level("TRACE")
-- vim.lsp.set_log_level("OFF")

vim.diagnostic.config({
	source = true,
})




-- The Keybindings themselves are set-up through the init.vim
-- Don't ask me why I did it this way
--
-- SEE: help lspconfig-keybindings
local function setUpLspCommands(ev)
	-- require("lsp_signature").on_attach({
	-- 	bind = false,
	-- 	hint_prefix = "",
	-- 	floating_window = false,
	-- })
	-- Enable completion triggered by <c-x><c-o>
	vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	  vim.lsp.handlers.hover, {
		-- Use a sharp border with `FloatBorder` highlights
		border = "single",
	  }
	)

	vim.cmd("command! LspDef lua vim.lsp.buf.definition()")

	if vim.fn.has('nvim-0.8') == 1 then
		vim.cmd("command! LspFormatting lua vim.lsp.buf.format()")
		vim.cmd("command! -range LspCodeRangeAction <line1>,<line2>lua vim.lsp.buf.code_action()")
	else
		vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
		vim.cmd("command! -range LspCodeRangeAction <line1>,<line2>lua vim.lsp.buf.range_code_action()")
	end

	vim.cmd("nnoremap <Leader>o :lua vim.lsp.buf.document_symbol()<CR>")
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
--                              Typescript + JS                              --
--                                                                           --
-------------------------------------------------------------------------------

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = ""
	}
	vim.lsp.buf.execute_command(params)
end

nvim_lsp.tsserver.setup({
	commands = {
		OrganizeImports = {
			organize_imports,
			description = "Organize Imports"
		}
	}
})

-------------------------------------------------------------------------------
--                                                                           --
--                                HTML + CSS                                 --
--                        vscode-langservers-extracted                       --
--                                                                           --
-------------------------------------------------------------------------------
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- I don't think I actually have these ones...
nvim_lsp.html.setup({ capabilities = capabilities , init_options = {
		provideFormatter = false 
	}
})
nvim_lsp.cssls.setup({ capabilities = capabilities })


-------------------------------------------------------------------------------
--                                                                           --
--                                   JSON                                    --
--
--                        vscode-langservers-extracted                       --
-------------------------------------------------------------------------------

nvim_lsp.jsonls.setup {
	capabilities = capabilities,
	settings = {
		json = {
			-- Schemas https://www.schemastore.org
			schemas = {
				-- {
				-- 	fileMatch = { "angular.json" },
				-- 	url = "https://raw.githubusercontent.com/angular/angular-cli/master/packages/angular/cli/lib/config/workspace-schema.json",
				-- },
				{
					fileMatch = { "package.json" },
					url = "https://json.schemastore.org/package.json"
				},
				{
					fileMatch = { "tsconfig*.json" },
					url = "https://json.schemastore.org/tsconfig.json"
				},
				{
					fileMatch = {
						".prettierrc",
						".prettierrc.json",
						"prettier.config.json"
					},
					url = "https://json.schemastore.org/prettierrc.json"
				},
				{
					fileMatch = { ".eslintrc", ".eslintrc.json" },
					url = "https://json.schemastore.org/eslintrc.json"
				},
				{
					fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
					url = "https://json.schemastore.org/babelrc.json"
				},
				{
					fileMatch = { "lerna.json" },
					url = "https://json.schemastore.org/lerna.json"
				},
				{
					fileMatch = { "now.json", "vercel.json" },
					url = "https://json.schemastore.org/now.json"
				},
				{
					fileMatch = {
						".stylelintrc",
						".stylelintrc.json",
						"stylelint.config.json"
					},
					url = "http://json.schemastore.org/stylelintrc.json"
				}
			}
		}
	}
}

-------------------------------------------------------------------------------
--                                                                           --
--                                  Angular                                  --
--                                                                           --
-------------------------------------------------------------------------------

-- Requires that the "@angular/language-server" be a dependency on package.json
nvim_lsp.angularls.setup {
	filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular", "angular" }
}


-------------------------------------------------------------------------------
--                                                                           --
--                                    LUA                                    --
--                                                                           --
-------------------------------------------------------------------------------

-- This is _mostly_ for just editing NEOVIM
-- nvim_lsp.lua_ls.setup {
-- 	on_init = function(client)
-- 		if client.workspace_folders then
-- 			local path = client.workspace_folders[1].name
-- 			-- No idea what this does
-- 			if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
-- 				return
-- 			end
-- 		end

-- 		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
-- 			runtime = {
-- 				-- Tell the language server which version of Lua you're using
-- 				-- (most likely LuaJIT in the case of Neovim)
-- 				version = 'LuaJIT'
-- 			},
-- 			-- Make the server aware of Neovim runtime files
-- 			workspace = {
-- 				checkThirdParty = false,
-- 				library = {
-- 					vim.env.VIMRUNTIME
-- 					-- Depending on the usage, you might want to add additional paths here.
-- 					-- "${3rd}/luv/library"
-- 					-- "${3rd}/busted/library",
-- 				}
-- 				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
-- 				-- library = vim.api.nvim_get_runtime_file("", true)
-- 			}
-- 		})
-- 	end,
-- 	settings = {
-- 		Lua = {}
-- 	}
-- }

-------------------------------------------------------------------------------
--                                                                           --
--                                  Python                                   --
--                                                                           --
-------------------------------------------------------------------------------

nvim_lsp.basedpyright.setup({
	-- basedpyright
	-- on_attach = function(client)
	-- 	print("xD")
	-- 	if client.name == 'basedpyright' then
	-- 		-- Disable hover in favor of Pyright
	-- 		client.server_capabilities.hoverProvider = false
	-- 	end
	-- end,
	basedpyright = {
		disableOrganizeImports = true,
		analysis = {
			inlayHints = {
				variableTypes = false,
				callArgumentNames = false,
				functionReturnTypes = false,
			},
		}
	}
})


local function endswith(string, suffix)
	return string:sub(- #suffix) == suffix
end



-- Consider adding this to the general ones
local function fix_all()
	if not endswith(vim.api.nvim_buf_get_name(0), '.py') then
		return
	end
	-- TODO: Inform upstream that this type is incorrect
	vim.lsp.buf.code_action({ context = { only = { 'source.fixAll' } }, apply = true })
	vim.lsp.buf.format()
end

nvim_lsp.ruff.setup {
	on_attach = function(client)
		if client.name == 'ruff' then
			-- Disable hover in favor of Pyright
			client.server_capabilities.hoverProvider = false
		end
	end,
	commands = {
		FixAll = {
			fix_all,
			description = "Fix all Code Action"
		}
	}
}

nvim_lsp.robotframework_ls.setup({})

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
	htmlangular = "eslint",
	angular = "eslint",
	javascript = "eslint",
	javascriptreact = "eslint",
	typescript = "eslint",
	typescriptreact = "eslint",
	-- json = "eslint",
	-- jsonc = "eslint",
	sh = "shellcheck",
	bash = "shellcheck",
}

local formatFiletypes = {
	htmlangular = "prettier",
	html = "prettier",
	angular = "prettier",
	javascript = "prettier",
	javascriptreact = "prettier",
	typescript = "prettier",
	typescriptreact = "prettier",
	yaml = "prettier",
	json = "prettier",
	jsonc = "prettier",
	bash = "shfmt",
	sh = "shfmt",
	sql = "sqlfluff"
}

local linters = {
	phpCsFixer = {},
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
	prettier = { command = "npx", args = { "prettier", "--stdin-filepath", "%filepath" } },
	shfmt = { command = "shfmt", args = { "-filename", "%filepath", "-i", "0", "-ci", "-bn" } },
	-- sqlfluff fix --dialect postgres %
	sqlfluff = { command = "sqlfluff", args = { "fix", "--quiet","--dialect", "postgres", '-' } },

}

nvim_lsp.diagnosticls.setup({
	filetypes = vim.tbl_keys(formatFiletypes),
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
--                                  DOCKER                                   --
--                                                                           --
-------------------------------------------------------------------------------


nvim_lsp.dockerls.setup({})
-- TODO
nvim_lsp.docker_compose_language_service.setup({})



-------------------------------------------------------------------------------
--                                                                           --
--                                  C-Lang                                   --
--                                                                           --
-------------------------------------------------------------------------------
nvim_lsp.clangd.setup {
	cmd = { 'clangd', '--background-index', '--clang-tidy' },
}
