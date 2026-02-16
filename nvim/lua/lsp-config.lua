-- # vim: shiftwidth=4 expandtab:
-- Badly hacked together LSP setup.
-- Don't copy this, it's a mess.

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
-- It's a LUA only thing
-- require("neodev").setup({})
-- require('lazydev')

-- local nvim_lsp = require("lspconfig")
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


---@param full boolean?
local function toggle_virtual_line(full)
    return function()
        -- show up as a virtual line under the error
        -- Something like:
        -- ```python
        -- foo += 1
        --  └──── reportOperatorIssue: Operator "+=" not supported for types ...
        -- ```
        -- virtual_lines = true,
        -- It's very cute, but it looks ghastly
        -- If turned on by default
        -- So we use `<leader>v` and `<leader>V` to toggle it on and off
        if vim.diagnostic.config().virtual_lines then
            vim.diagnostic.config({ virtual_lines = false })
        else
            if full then
                vim.diagnostic.config({ virtual_lines = true })
            else
                -- just for the current line
                vim.diagnostic.config({ virtual_lines = { current_line = true } })
            end
        end
    end
end

vim.keymap.set("n", "<leader>v", toggle_virtual_line(), {})
vim.keymap.set("n", "<leader>V", toggle_virtual_line(true), {})

-- The Keybindings themselves are set-up through the init.vim
-- I did it this way because ALE was a treat and it JUST WORKED
--
-- But now I'm training myself to use the default nvim ones
-- (UNTIL THEY CHANGE AGAIN NO DOUBT!)
---@param ev vim.api.keyset.create_autocmd.callback_args
local function setUpLspCommands(ev)
    -- require("lsp_signature").on_attach({
    -- 	bind = false,
    -- 	hint_prefix = "",
    -- 	floating_window = false,
    -- })
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- use lsp for folding if it's supported by the server
    if client and client:supports_method("textDocument/foldingRange") then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    local command = function(what, func)
        vim.api.nvim_create_user_command(what, func, { nargs = 0 })
    end

    command("LspDef", function()
        print('Bad habit! Use the default |CTRL-]"|CTRL-]|, |CTRL-W_]|')
        vim.lsp.buf.definition()
    end)

    command("LspHover", function()
        print("Bad habit! Use K")
        vim.lsp.buf.hover()
    end)

    command("LspFindReferences", function()
        print("Bad habit! Use grr")
        vim.lsp.buf.references()
    end)

    command("LspImplementation", function()
        print("Bad habit! Use gri")
        vim.lsp.buf.implementation()
    end)

    command("LspCodeAction", function()
        print("Bad habit! Use gra")
        vim.lsp.buf.code_action()
    end)

    command("LspRename", function()
        print("Bad habit! Use grn")
        vim.lsp.buf.rename()
    end)

    command("LspTypeDef", function()
        print("Bad habit! Use grt")
        vim.lsp.buf.type_definition()
    end)

    command("LspDiagNext", function()
        print("Bad habit! Use ]d")
        vim.diagnostic.jump({ count = 1, float = true })
        -- VERY SANE API AS OPPOSED TO THE ONE BELLOW
        -- THANKS NEOVIM
        -- vim.diagnostic.goto_next()
    end)

    command("LspDiagPrev", function()
        print("Bad habit! Use [d")
        vim.diagnostic.jump({ count = -1, float = true })
        -- vim.diagnostic.goto_prev()
    end)

    -- We define these nerds since if I'm using `ALE` in standard VIM
    -- We still want to have them defined
    vim.cmd([[
        command! LspFormatting lua vim.lsp.buf.format()
        "" DIAGNOSTICS
        command! LspDetail lua vim.diagnostic.open_float({scope="line"})
        command! LspLocList lua vim.diagnostic.setloclist()

        "" TODO(Joaquim): Add this as a function only if pyright is connected
        "" Adds a python comment that shuts pyright up
        function! Stfupyright()
          "" Open the window that shows all of pyrights' errors on the current line
          lua vim.diagnostic.open_float({scope="line"})
          "" Change your cursor to go inside said window
          lua vim.diagnostic.open_float({scope="line"})
          let t=[]
          "" Add every submatch over to the list t
          %s#\[report.*\]#\=add(t,submatch(0))#gn
          "" Exit LSP window
          norm wq
          let t = uniq(sort(t))
          let @s = join(map(t, 'v:val[1:-2]'), ', ')
          norm $
          norm a  # pyright: ignore[
          norm "sp
          norm a]
        endfunction

        command! Stfupyright :call Stfupyright()
    ]])
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = setUpLspCommands,
    -- We just need to set up the commands once
    once = true,
})

vim.lsp.config("*", {
    on_attach = function(client, bufnr)
        -- Without this `CTRL-Y` won't auto import or do other lsp side-effecty
        -- things
        vim.lsp.completion.enable(true, client.id, bufnr)
    end,
})


-- Doesn't work because I have to set it up
-- But omni-func works just fine (???)
vim.keymap.set('i', '<c-space>', function()
  vim.lsp.completion.get()
end)

---@param prog string
local has = function(prog)
    return vim.fn.executable(prog) == 1
end

-- PRETTYNESS
-- Doesn't work anymore :(((
-- All the nerds now use telescope...which is just 20 times worse
-- if vim.fn.executable("fzf") then
-- 	require("fzf_lsp").setup()
-- end

-------------------------------------------------------------------------------
--                                                                           --
--                                  GOLANG                                   --
--                                                                           --
-------------------------------------------------------------------------------

if has("gopls") then
    vim.lsp.enable("gopls")
end
-------------------------------------------------------------------------------
--                                                                           --
--                              Typescript + JS                              --
--                                                                           --
-------------------------------------------------------------------------------
if has("typescript-language-server") then
    vim.lsp.config("ts_ls", {
        --- Doesn't fekin work
        --- param client vim.lsp.Client
        -- on_attach = function(client)
        --     -- TODO(Joaquim): THIS IS UNTESTED!!
        --     client.capabilities.textDocument.formatting = nil
        -- end,
    })
    vim.lsp.enable("ts_ls")
end
-------------------------------------------------------------------------------
--                                                                           --
--                                HTML + CSS                                 --
--                                                                           --
-------------------------------------------------------------------------------
if has("vscode-html-language-server") == 1 then
    vim.lsp.enable({ "html", "cssls" })
end
-------------------------------------------------------------------------------
--                                                                           --
--                                    Lua                                    --
--                                                                           --
-------------------------------------------------------------------------------
if has("lua-language-server") then
    --- @param client vim.lsp.Client
    local on_init = function(client)
        if not client.workspace_folders then
            return
        end

        local path = client.workspace_folders[1].name
        ---@diagnostic disable-next-line: undefined-field
        if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
            -- Don't do anything if we're in a normal lua project
            return
        end

        ---@diagnostic disable-next-line: param-type-mismatch
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths
                    -- here.
                    -- '${3rd}/luv/library',
                    -- '${3rd}/busted/library',
                },
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = vim.api.nvim_get_runtime_file('', true),
            },
        })
    end

    vim.lsp.config("lua_ls", {
        on_init = on_init,
        settings = {
            Lua = {
                codeLens = {
                    enable = false,
                },
                hint = {
                    enable = true,
                    semicolon = "Disable",
                },
                format = {
                    enable = true,
                    -- Put format options here
                    -- NOTE: the value should be STRING!!
                    defaultConfig = {
                        indent_style = "space",
                        indent_size = "2",
                    },
                },
            },
        },
    })
    vim.lsp.enable("lua_ls")
end
----------------------------------------------------------------------------------------------------
--                                              JAVA                                              --
--                           https://github.com/mfussenegger/nvim-jdtls                           --
--                      On their README they recommend placing this stuff on                      --
--That wasn't working since we need the plug.vim to get all of our plugins So it's an auto command--
----------------------------------------------------------------------------------------------------
-- local function startJDTLS()
-- 	require('jdtls').start_or_attach({
-- 		-- This is a binary
-- 		-- It _must_ be on the path!
-- 		cmd = { 'jdtls' },
-- 		root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
-- 	})
-- end

-- vim.api.nvim_create_autocmd('FileType', {
-- 	desc = 'Start jdtls on java files',
-- 	pattern = 'java',
-- 	group = vim.api.nvim_create_augroup('jdtls_lsp', { clear = true }),
-- 	callback = startJDTLS,
-- })

-------------------------------------------------------------------------------
--                                                                           --
--                                    PHP                                    --
--                                                                           --
-------------------------------------------------------------------------------
-- nvim_lsp.phpactor.setup({})
-------------------------------------------------------------------------------
--                                                                           --
--                                  Python                                   --
--                                                                           --
-------------------------------------------------------------------------------
--
-- Consider https://github.com/mtshiba/pylyzer
-- nvim_lsp.pylyzer.setup({})
-- See: https://github.com/DetachHead/basedpyright

if has("basedpyright") then
    vim.lsp.enable("basedpyright")
end

if has("ruff") then
    vim.lsp.enable("ruff")
end

-------------------------------------------------------------------------------
--                                                                           --
--                                   CLANG                                   --
--                                                                           --
-------------------------------------------------------------------------------

if has("clangd") then
    vim.lsp.enable("clangd")
end
-------------------------------------------------------------------------------
--                                                                           --
--                               Diagnostic LS                               --
--                                                                           --
-------------------------------------------------------------------------------
--
-- See: https://github.com/iamcco/diagnostic-languageserver
--
--

if has("diagnostic-languageserver") then
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
            args = {
                "--call-parentheses",
                "Always",
                "--indent-type",
                "Spaces",
                "-",
            },
        },
    }

    vim.lsp.config("diagnosticls", {
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
    vim.lsp.enable("diagnosticls")
end

if has("vim-language-server") then
    vim.lsp.enable("vimls")
end
