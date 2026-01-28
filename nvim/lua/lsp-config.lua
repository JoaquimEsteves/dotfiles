-- Badly hacked together LSP setup.
-- Don't copy this, it's a mess.

local nvim_lsp = require("lspconfig")
vim.lsp.set_log_level("error")
local coq = require("coq")

require("lsp_signature").on_attach()

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Typescript only organise Imports function
local function ts_organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

-- on_attach defined here. With the maps being defined in .vimrc
local on_attach = function(client, bufnr)
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
	vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
	vim.cmd("command! -range LspCodeRangeAction <line1>,<line2>lua vim.lsp.buf.range_code_action()")
	vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
	vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
	vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
	vim.cmd("command! LspOrganize lua lsp_organize_imports()")
	vim.cmd("command! LspFindReferences lua vim.lsp.buf.references()")
	vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
	vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
	-- DIAGNOSTICS
	vim.cmd("command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()")
	vim.cmd("command! LspDiagNext lua vim.lsp.diagnostic.goto_next()")
	vim.cmd("command! LspDetail lua vim.lsp.diagnostic.show_line_diagnostics()")
	vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
	vim.cmd("command! LspHelp lua vim.lsp.diagnostic.set_loclist()")
end

-- PRETTYNESS
if vim.fn.executable("fzf") then
	require("fzf_lsp").setup()
end

local filetypes = {
	javascript = "eslint",
	javascriptreact = "eslint",
	typescript = "eslint",
	typescriptreact = "eslint",
	vue = "eslint",
	python = "python",
	-- lua = "lua",
	sh = "shellcheck",
}

local formatFiletypes = {
	javascript = "prettier",
	javascriptreact = "prettier",
	typescript = "prettier",
	typescriptreact = "prettier",
	vue = "prettier",
	-- yaml = "prettier",
	json = "prettier",
	sh = "shfmt",
	python = "black",
	-- python = "ruff_format",
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
	ruff_format = { command = "ruff", args = { "format", "--quiet", "-" } },
	black = { command = "python3", args = { "-m", "black", "--quiet", "-" } },
	isort = {
		command = "isort",
		args = { "--quiet", "-" },
	},
	shfmt = { command = "shfmt", args = { "-filename", "%filepath", "-i", "2", "-ci", "-bn" } },
	-- stylua = {
	-- 	command = "stylua",
	-- 	args = { "-" },
	-- },
}

nvim_lsp.diagnosticls.setup({
	on_attach = on_attach,
	filetypes = vim.tbl_keys(filetypes),
	init_options = {
		filetypes = filetypes,
		linters = linters,
		formatters = formatters,
		formatFiletypes = formatFiletypes,
	},
})

nvim_lsp.gopls.setup({ on_attach = on_attach })

nvim_lsp.tsserver.setup(coq.lsp_ensure_capabilities({
	on_attach = function(client)
		client.resolved_capabilities.document_formatting = false
		on_attach(client)
	end,
	commands = {
		LspOrganizeImports = {
			ts_organize_imports,
			description = "Organize Imports Through tsserver!",
		},
	},
}))

-- HTML + CSS
nvim_lsp.html.setup(coq.lsp_ensure_capabilities({ capabilities = capabilities }))
nvim_lsp.cssls.setup(coq.lsp_ensure_capabilities({ capabilities = capabilities }))

-- Python
nvim_lsp.pyright.setup({ on_attach = on_attach })
-- lua
-- Doesn't work with my version...
-- nvim_lsp.lua_ls.setup({ on_attach = on_attach })


nvim_lsp.serve_d.setup({
	cmd = { "serve-d", "--loglevel", "trace", "--logfile", "/tmp/log_d" },
	on_attach = on_attach,

	settings = {
		dfmt = {
			braceStyle = "stroustrup",

			-- disableOrganizeImports  = true,
		},
		d = {
			enableDMDImportTiming = true,
			dubPath = "/usr/bin/dub"
		},
	},
})

nvim_lsp.volar.setup({ on_attach = on_attach, cmd = { "vue-language-server", "--stdio" } })
-- nvim_lsp.jdtls.setup({ on_attach = on_attach })

-- LUA LSP
-- COMPLETELY USELESS IN NEWER VERSIONS

local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'

local lua_root_files = {
	'.luarc.json',
	'.luarc.jsonc',
	'.luacheckrc',
	'.stylua.toml',
	'stylua.toml',
	'selene.toml',
	'selene.yml',
}

if not configs.lua_ls then
	configs.lua_ls = {
		default_config = {
			cmd = { 'lua-language-server' },
			filetypes = { 'lua' },
			root_dir = function(fname)
				local root = util.root_pattern(unpack(lua_root_files))(fname)
				if root and root ~= vim.env.HOME then
					return root
				end
				root = util.root_pattern 'lua/' (fname)
				if root then
					return root
				end
				return util.find_git_ancestor(fname)
			end,
			single_file_support = true,
			log_level = vim.lsp.protocol.MessageType.Warning,
		},
	}
end
nvim_lsp.lua_ls.setup({ on_attach = on_attach })

-- END LUA LSP

-- JAVA LSP
-- COMPLETELY USELESS IN NEWER VERSIONS
--
local handlers = require 'vim.lsp.handlers'

local env = {
	HOME = vim.loop.os_homedir(),
	XDG_CACHE_HOME = os.getenv 'XDG_CACHE_HOME',
	JDTLS_JVM_ARGS = os.getenv 'JDTLS_JVM_ARGS',
}

local function get_cache_dir()
	return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or util.path.join(env.HOME, '.cache')
end

local function get_jdtls_cache_dir()
	return util.path.join(get_cache_dir(), 'jdtls')
end

local function get_jdtls_config_dir()
	return util.path.join(get_jdtls_cache_dir(), 'config')
end

local function get_jdtls_workspace_dir()
	return util.path.join(get_jdtls_cache_dir(), 'workspace')
end

local function get_jdtls_jvm_args()
	local args = {}
	for a in string.gmatch((env.JDTLS_JVM_ARGS or ''), '%S+') do
		local arg = string.format('--jvm-arg=%s', a)
		table.insert(args, arg)
	end
	return unpack(args)
end

-- TextDocument version is reported as 0, override with nil so that
-- the client doesn't think the document is newer and refuses to update
-- See: https://github.com/eclipse/eclipse.jdt.ls/issues/1695
local function fix_zero_version(workspace_edit)
	if workspace_edit and workspace_edit.documentChanges then
		for _, change in pairs(workspace_edit.documentChanges) do
			local text_document = change.textDocument
			if text_document and text_document.version and text_document.version == 0 then
				text_document.version = nil
			end
		end
	end
	return workspace_edit
end

local function on_textdocument_codeaction(err, actions, ctx)
	for _, action in ipairs(actions) do
		-- TODO: (steelsojka) Handle more than one edit?
		if action.command == 'java.apply.workspaceEdit' then                                     -- 'action' is Command in java format
			action.edit = fix_zero_version(action.edit or action.arguments[1])
		elseif type(action.command) == 'table' and action.command.command == 'java.apply.workspaceEdit' then -- 'action' is CodeAction in java format
			action.edit = fix_zero_version(action.edit or action.command.arguments[1])
		end
	end

	handlers[ctx.method](err, actions, ctx)
end

local function on_textdocument_rename(err, workspace_edit, ctx)
	handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end

local function on_workspace_applyedit(err, workspace_edit, ctx)
	handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end

-- Non-standard notification that can be used to display progress
local function on_language_status(_, result)
	local command = vim.api.nvim_command
	command 'echohl ModeMsg'
	command(string.format('echo "%s"', result.message))
	command 'echohl None'
end

local root_files = {
	-- Single-module projects
	{
		'build.xml', -- Ant
		'pom.xml', -- Maven
		'settings.gradle', -- Gradle
		'settings.gradle.kts', -- Gradle
	},
	-- Multi-module projects
	{ 'build.gradle', 'build.gradle.kts' },
}

if not configs.jdtls then
	configs.jdtls = {
		default_config = {
			cmd = {
				'jdtls',
				'-configuration',
				get_jdtls_config_dir(),
				'-data',
				get_jdtls_workspace_dir(),
				get_jdtls_jvm_args(),
			},
			filetypes = { 'java' },
			root_dir = function(fname)
				for _, patterns in ipairs(root_files) do
					local root = util.root_pattern(unpack(patterns))(fname)
					if root then
						return root
					end
				end
			end,
			single_file_support = true,
			init_options = {
				workspace = get_jdtls_workspace_dir(),
				jvm_args = {},
				os_config = nil,
			},
			handlers = {
				-- Due to an invalid protocol implementation in the jdtls we have to conform these to be spec compliant.
				-- https://github.com/eclipse/eclipse.jdt.ls/issues/376
				['textDocument/codeAction'] = on_textdocument_codeaction,
				['textDocument/rename'] = on_textdocument_rename,
				['workspace/applyEdit'] = on_workspace_applyedit,
				['language/status'] = vim.schedule_wrap(on_language_status),
			},
		},
		docs = {
			default_config = {
				root_dir = [[{
        -- Single-module projects
        {
          'build.xml', -- Ant
          'pom.xml', -- Maven
          'settings.gradle', -- Gradle
          'settings.gradle.kts', -- Gradle
        },
        -- Multi-module projects
        { 'build.gradle', 'build.gradle.kts' },
      } or vim.fn.getcwd()]],
			},
		},
	}
end
nvim_lsp.jdtls.setup({
	on_attach = on_attach,
	java = {
		settings = {
			format = {
				profile = "GoogleStyle"
			}
		}
	}

})

-- END JAVA LSP

