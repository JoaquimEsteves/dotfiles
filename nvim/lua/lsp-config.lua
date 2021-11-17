-- Includes both lsp and tree-sitter config
-- They go well together :)

local nvim_lsp = require('lspconfig')
require('lsp_signature').on_attach()

-- Typescript only organise Imports function
local function ts_organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

 -- on_attach defined here. With the maps being defined elsewhere
local on_attach = function(client, bufnr)
    local buf_map = vim.api.nvim_buf_set_keymap
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end
    require'lsp_signature'.on_attach({
        bind = false,
        hint_prefix = "",
        floating_window = false,
    })

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
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
    vim.cmd(
        "command! LspDetail lua vim.lsp.diagnostic.show_line_diagnostics()")
    vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
    vim.cmd("command! LspHelp lua vim.lsp.diagnostic.set_loclist()")
end


-- PRETTYNESS
if vim.fn.executable('fzf') then
  require'fzf_lsp'.setup()
end

local filetypes = {
    javascript = "eslint",
    javascriptreact = "eslint",
    typescript = "eslint",
    typescriptreact = "eslint",
    -- json = "eslint",
    -- sh = "shellcheck",
}

local formatFiletypes = {
    javascript = "prettier",
    javascriptreact = "prettier",
    typescript = "prettier",
    typescriptreact = "prettier",
    -- yaml = "prettier",
    -- json = "prettier",
    -- sh = "shfmt",
}



local linters = {
    eslint = {
        sourceName = "eslint",
        -- Slightly faster than eslint as it keeps a server running
        command = "eslint_d",
        rootPatterns = {".eslintrc.js", "package.json", ".eslintrc.json"},
        debounce = 100,
        args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
        parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "🔥 ${message} [${ruleId}]",
            security = "severity"
        },
        securities = {[2] = "error", [1] = "warning"}
    }
}

local formatters = {
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}},
    -- shfmt = {command = "shfmt", args = {"-filename", "%filepath", '-i','2','-ci','-bn' }}
}

nvim_lsp.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}

nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end,
    commands = {
        LspOrganizeImports = {
          ts_organize_imports,
          description = "Organize Imports Through tsserver!"
        }
    }
}

