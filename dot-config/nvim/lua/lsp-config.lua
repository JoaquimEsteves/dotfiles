-- # vim: shiftwidth=4 expandtab:
-- Badly hacked together LSP setup.
-- Don't copy this, it's a mess.

-- IN CASE SOMETHING BREAKS
-- Then checkout `:LspLog`
-- vim.lsp.set_log_level("TRACE")
--
--
local ma = require("module_available")

-- vim.lsp.log.set_level("OFF")

local default_diagnostic_config = {
    source = true,
    signs = false,
    -- Removes ugly 'E:X W:Y' from the statusline
    status = {
        format = function() return '' end,
    },
    severity_sort = true,
    -- Only update on InsertLeave
    update_in_insert = false,
}

vim.diagnostic.config(default_diagnostic_config)

local definition = vim.lsp.buf.definition
local references = vim.lsp.buf.references
local implementation = vim.lsp.buf.implementation
local code_action = vim.lsp.buf.code_action
local type_definition = vim.lsp.buf.type_definition

if ma("fzf_lsp") then
    -- When using my own commands we use the fzf ones
    -- That way we get to keep the good-stuff, while only using the old ones
    local fzf_lsp = require("fzf_lsp")
    definition = fzf_lsp.definition
    references = fzf_lsp.references
    implementation = fzf_lsp.implementation
    code_action = fzf_lsp.code_action
    type_definition = fzf_lsp.type_definition
end

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
            print("Virtual Lines are OFF")
            vim.diagnostic.config({ virtual_lines = false })
            return
        end
        if full then
            print("Virtual Lines are HELLA ON")
            vim.diagnostic.config({ virtual_lines = true })
        else
            -- just for the current line
            --
            print("Virtual Lines are ON")
            vim.diagnostic.config({ virtual_lines = { current_line = true } })
        end
    end
end

vim.keymap.set("n", "<leader>v", toggle_virtual_line(), {})
vim.keymap.set("n", "<leader>V", toggle_virtual_line(true), {})

local no_format = { ts_ls = true, sqls = true }
-- The Keybindings themselves are set-up through the init.vim
-- I did it this way because ALE was a treat and it JUST WORKED
--
-- But now I'm training myself to use the default nvim ones
-- (UNTIL THEY CHANGE AGAIN NO DOUBT!)
---@param ev vim.api.keyset.create_autocmd.callback_args
---@diagnostic disable-next-line: unused-local
local function setUpLspCommands(ev)
    -- require("lsp_signature").on_attach({
    -- 	bind = false,
    -- 	hint_prefix = "",
    -- 	floating_window = false,
    -- })
    -- Enable completion triggered by <c-x><c-o>
    -- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local command = function(what, func)
        vim.api.nvim_create_user_command(what, func, { nargs = 0 })
    end

    command('LspLog', function()
        vim.cmd('split ' .. vim.lsp.log.get_filename())
    end)

    command("LspDef", function()
        vim.notify('Bad habit! Use the default |CTRL-]"|CTRL-]|, |CTRL-W_i]|', 4)
        definition()
    end)

    command("LspHover", function()
        vim.notify("Bad habit! Use K", 4)
        vim.lsp.buf.hover()
    end)

    command("LspHighlight", function()
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
    end)

    command("LspFindReferences", function()
        vim.notify("Bad habit! Use grr", 4)
        references()
    end)

    command("LspImplementation", function()
        vim.notify("Bad habit! Use gri", 4)
        implementation()
    end)

    command("LspCodeAction", function()
        vim.notify("Bad habit! Use gra", 4)
        code_action()
    end)

    command("LspRename", function()
        vim.notify("Bad habit! Use grn", 4)
        vim.lsp.buf.rename()
    end)

    command("LspTypeDef", function()
        vim.notify("Bad habit! Use grt", 4)
        type_definition()
    end)

    command("LspDiagNext", function()
        vim.notify("Bad habit! Use ]d", 4)
        vim.diagnostic.jump({ count = 1, float = true })
        -- VERY SANE API AS OPPOSED TO THE ONE BELLOW
        -- THANKS NEOVIM
        -- vim.diagnostic.goto_next()
    end)

    command("LspDiagPrev", function()
        vim.notify("Bad habit! Use [d", 3)
        vim.diagnostic.jump({ count = -1, float = true })
        -- vim.diagnostic.goto_prev()
    end)

    command('LspFormatting', function()
        vim.lsp.buf.format({
            --- Never format nerds that are on that list (namely, typescript and SQLS)
            filter = function(client) return no_format[client.name] == nil end
        })
    end)
    command('LspDetail', function() vim.diagnostic.open_float({ scope = "line" }) end)
    command('LspLocList', vim.diagnostic.setloclist)

    --
    -- We define these nerds since if I'm using `ALE` in standard VIM
    -- We still want to have them defined
    vim.cmd([[
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

local group_config_id = vim.api.nvim_create_augroup("UserLspConfig", {})
vim.api.nvim_create_autocmd("LspAttach", {
    group = group_config_id,
    callback = setUpLspCommands,
    -- We just need to set up the commands once
    once = true,
})



vim.lsp.config("*", {
    on_attach = function(client, bufnr)
        if client:supports_method("textDocument/completion") then
            -- Without this `CTRL-Y` won't auto import or do other lsp side-effecty
            -- things
            vim.lsp.completion.enable(true, client.id, bufnr)
        end

        if client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            --- Equivalent to `like ':setlocal foldexpr=v:lua.vim.lsp.foldexpr()`
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end

        --- Is this even necessary? It appears lie this is fine
        if client:supports_method('textDocument/documentColor') then
            vim.lsp.document_color.enable(true, { client_id = client.id })
        end

        if no_format[client.name] then
            -- DOES NOT WORK FOR SQLS
            -- I HATE THAT SILLY THING
            -- I had to `:checkhealth lsp` and then edit the
            -- plugin manually
            -- Very, very silly!
            client.server_capabilities.documentFormattingProvider = false
        end
    end,
})

-- Doesn't work because I have to set it up
-- But omni-func works just fine (???)
vim.keymap.set("i", "<c-space>", function()
    vim.lsp.completion.get()
end)

---@param prog string
local which = function(prog)
    return vim.fn.executable(prog) == 1
end

-------------------------------------------------------------------------------
--                                                                           --
--                                  GOLANG                                   --
--                                                                           --
-------------------------------------------------------------------------------

if which("gopls") then
    -- go install golang.org/x/tools/gopls@latest
    vim.lsp.enable("gopls")
end
-------------------------------------------------------------------------------
--                                                                           --
--                              Typescript + JS                              --
--                                                                           --
-------------------------------------------------------------------------------
if which("typescript-language-server") then
    -- npm install -g typescript typescript-language-server
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

if which('ngserver') then
    vim.lsp.enable('angularls')
end
-------------------------------------------------------------------------------
--                                                                           --
--                                HTML + CSS                                 --
--                                                                           --
-------------------------------------------------------------------------------
if which("vscode-html-language-server") then
    -- npm i -g vscode-langservers-extracted
    vim.lsp.enable({ "html", "cssls" })
end
-------------------------------------------------------------------------------
--                                                                           --
--                                    Lua                                    --
--                                                                           --
-------------------------------------------------------------------------------
if which("lua-language-server") then
    -- https://luals.github.io/#neovim-install

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

if which("jdtls") then
    -- https://github.com/eclipse-jdtls/eclipse.jdt.ls#installation
    -- Apparently `vim.fs.find` crashes out if we're in some weird temporary dir
    local ok, markers = pcall(vim.fs.find, { 'gradlew', '.git', 'mvnw', 'pom.xml' }, { upward = true })
    local root_dir = ok and vim.fs.dirname(markers[1])

    vim.lsp.config('jdtls', {
        cmd = {
            'jdtls',
            -- REPLACE THIS WITH WHEREVER YOU LEFT LOMBOK
            '--jvm-arg=-javaagent:/Users/jesteves/.local/share/lombok/lombok.jar',
            '--java-executable=/opt/homebrew/opt/openjdk/bin/java',
        },
        root_dir = root_dir

    })
    vim.lsp.enable("jdtls")
end

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

if which("basedpyright") then
    -- npm install -i basedpyright
    -- (or uv)
    vim.lsp.enable("basedpyright")
end

if which("ruff") then
    -- uv tool install ruff
    vim.lsp.enable("ruff")
end

-------------------------------------------------------------------------------
--                                                                           --
--                                   CLANG                                   --
--                                                                           --
-------------------------------------------------------------------------------

if which("clangd") then
    -- https://clangd.llvm.org/installation
    -- (Most likely use the scripts or your systems' package manager)
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

if which("diagnostic-languageserver") then
    -- npm install -g diagnostic-languageserver
    local filetypes = {
        json = "eslint",
        yaml = "eslint",
        typescriptreact = 'eslint',
    }

    local formatFiletypes = {
        yaml = "prettier",
        typescriptreact = 'prettier',
        json = "prettier",
        sh = "shfmt",
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
        shfmt = { command = "shfmt", args = { "-filename", "%filepath", "-i", "4", "-ci", "-bn" } },
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

if which("vim-language-server") then
    -- npm install -g vim-language-server
    vim.lsp.enable("vimls")
end

if which("asm-lsp") then
    -- cargo install asm-lsp
    -- (Or download the binary from https://github.com/bergercookie/asm-lsp)
    vim.lsp.config('asm_lsp', {
        filetypes = {
            "asm", "s", "S"
        }
    })
    vim.lsp.enable("asm_lsp")
end

if which('docker-language-server') then
    -- go install github.com/docker/docker-language-server/cmd/docker-language-server@latest
    vim.lsp.enable('docker_language_server')
end

if which('bash-language-server') then
    -- npm i -g bash-language-server
    -- It's a bit ass doe
    vim.lsp.enable('bashls')
end

if which('tombi') then
    -- uv tool install tombi
    vim.lsp.enable('tombi')
end

-- This one is kind of shit
if which('sqls') then
    -- go install github.com/sqls-server/sqls@latest
    -- This little guy requires some boilerplate (and is goddamn finicky as well....)
    -- First, it requires the `sqls.nvim` package
    -- It then requires a config, and it's a PITA to switch in between sqlite dbs
    -- See: .bash_functions@set_as_current_db
    vim.lsp.enable('sqls')
end

-- FUCK!
-- IT'S SO GOOD ACTUALLY
-- FINALLY
if which('sqruff') then
    -- uv tool install sqruff
    vim.lsp.enable('sqruff')
end
