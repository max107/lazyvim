return {
    {
        'neovim/nvim-lspconfig',
        config = function()
            -- disable semantic token flickering after
            -- file save
            -- https://www.reddit.com/r/neovim/comments/zjqquc/how_do_i_turn_off_semantic_tokens/
            -- vim.api.nvim_create_autocmd("LspAttach", {
            --     callback = function(args)
            --         local client = vim.lsp.get_client_by_id(args.data.client_id)
            --         client.server_capabilities.semanticTokensProvider = nil
            --     end,
            -- });

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    -- lsp.buffer_autoformat()

                    local opts = { buffer = event.buf }

                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)

                    -- vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>Lspsaga finder<CR>', opts)

                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

                    vim.keymap.set('n', '<leader>a', '<cmd>Lspsaga code_action<CR>', opts)
                    -- vim.keymap.set('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

                    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
                    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
                end
            })

            -- vim.api.nvim_create_autocmd("BufWritePost", {
            --     pattern = "*",
            --     callback = function()
            --         vim.lsp.buf.format()
            --     end,
            -- })

            local lspconfig = require('lspconfig')

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            vim.api.nvim_create_autocmd("BufWritePre", {
                -- buffer = buffer,
                callback = function()
                    vim.lsp.buf.format { async = false }
                end
            })

            local on_attach = function(client, bufnr)
                vim.keymap.set('n', '<leader>w', function()
                    local params = vim.lsp.util.make_formatting_params({})
                    local handler = function(err, result)
                        if not result then return end

                        vim.lsp.util.apply_text_edits(result, bufnr, client.offset_encoding)
                        -- vim.lsp.buf.format()
                        vim.cmd('write')
                    end

                    client.request('textDocument/formatting', params, handler, bufnr)
                end, { buffer = bufnr })
            end

            local language_servers = {
                'ts_ls',
                'terraformls',
                'astro',
                'dockerls',
                'gopls',
                'graphql',
                'protols',
                'lua_ls',
                'bufls',
                'docker_compose_language_service',
            }

            for _, ls in ipairs(language_servers) do
                if ls == "graphql" then
                    lspconfig[ls].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        root_dir = lspconfig.util.root_pattern("graphql.config.yml"),
                        flags = {
                            debounce_text_changes = 150,
                        },
                    })
                elseif ls == "lua_ls" then
                    lspconfig[ls].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        -- you can add other fields for setting up lsp server in this table
                        on_init = function(client)
                            local path = client.workspace_folders[1].name
                            if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                                return
                            end

                            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                                runtime = {
                                    -- Tell the language server which version of Lua you're using
                                    -- (most likely LuaJIT in the case of Neovim)
                                    version = 'LuaJIT'
                                },
                                -- Make the server aware of Neovim runtime files
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME
                                        -- Depending on the usage, you might want to add additional paths here.
                                        -- "${3rd}/luv/library"
                                        -- "${3rd}/busted/library",
                                    }
                                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                    -- library = vim.api.nvim_get_runtime_file("", true)
                                }
                            })
                        end,
                        settings = {
                            Lua = {}
                        }
                    })
                else
                    lspconfig[ls].setup({
                        capabilities = capabilities
                        -- you can add other fields for setting up lsp server in this table
                    })
                end
            end
        end
    },
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({
                ui = {
                    code_action = ''
                },
                symbol_in_winbar = {
                    enable = false
                },
                finder = {
                    default = 'ref+imp+def+tyd',
                    methods = {
                        tyd = "textDocument/typeDefinition"
                    },
                    keys = {
                        toggle_or_open = '<cr>'
                    }
                },
                outline = {
                    keys = {
                        toggle_or_jump = '<cr>'
                    }
                }
            })
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons'      -- optional
        }
    },
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = { -- these are the default options
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo
                        .commentstring
                end,
                mappings = {
                    -- Toggle comment (like `gcip` - comment inner paragraph) for both
                    -- Normal and Visual modes
                    comment = 'gc',

                    -- Toggle comment on current line
                    comment_line = 'gmc',

                    -- Toggle comment on visual selection
                    comment_visual = 'gc',

                    -- Define 'comment' textobject (like `dgc` - delete whole comment block)
                    -- Works also in Visual mode if mapping differs from `comment_visual`
                    textobject = 'gc',
                },
            },
        },
    },
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup({
                silent = false,    -- less notifications
                term = "terminal", -- a terminal to run ("terminal"|"toggleterm")
                lsp_inlay_hints = {
                    enable = true
                },
                termOpts = {
                    direction = "vertical", -- terminal's direction ("horizontal"|"vertical"|"float")
                    width = 96,             -- terminal's width (for vertical|float)
                    height = 24,            -- terminal's height (for horizontal|float)
                    go_back = false,        -- return focus to original window after executing
                    stopinsert = "auto",    -- exit from insert mode (true|false|"auto")
                    keep_one = true,        -- keep only one terminal for testing
                },
            })

            vim.keymap.set("n", "<leader>tf", ":GoTestFile<CR>", { remap = false })
            vim.keymap.set("n", "<leader>tt", ":GoTestFunc<CR>", { remap = false })
            vim.keymap.set("n", "<leader>tp", ":GoTestPkg<CR>", { remap = false })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    -- {
    --     'windwp/nvim-autopairs',
    --     event = "InsertEnter",
    --     opts = {
    --         disable_filetype = { "TelescopePrompt", "vim" },
    --     },
    --     config = function()
    --         -- If you want insert `(` after select function or method item
    --         local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    --         local cmp = require('cmp')
    --         cmp.event:on(
    --             'confirm_done',
    --             cmp_autopairs.on_confirm_done()
    --         )
    --     end
    -- },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufWinEnter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-refactor",
            'JoosepAlviste/nvim-ts-context-commentstring',
            {
                "windwp/nvim-ts-autotag",
                event = "InsertEnter",
            },
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                -- autopairs = {
                --     enable = false,
                -- },
                autotag = {
                    enable = true,
                },
                refactor = {
                    highlight_definitions = {
                        enable = true,
                    },
                    highlight_current_scope = {
                        enable = false,
                    },
                    smart_rename = {
                        enable = true,
                        keymaps = {
                            smart_rename = "grr",
                        },
                    },
                    navigation = {
                        enable = false,
                        -- enable = true,
                        -- keymaps = {
                        --   goto_definition = "gd",
                        --   list_definitions = "gD",
                        --   list_definitions_toc = "gO",
                        --   goto_next_usage = "<a-*>",
                        --   goto_previous_usage = "<a-#>",
                        -- },
                    },
                },
                highlight = {
                    enable = true,
                    disable = {},
                },
                indent = {
                    enable = true,
                    disable = {},
                },
                ensure_installed = {
                    "lua",
                    "json",
                    "astro",
                    "typescript",
                    "css",
                    "sql",
                    "proto",
                    "bash",
                    "yaml",
                    "html",
                    "javascript",
                    "go",
                    "terraform",
                    "fish",
                    "dockerfile",
                    "toml",
                    "graphql",
                    "scss",
                    "hcl",
                    "markdown",
                    "nix",
                },
                sync_install = false,
            })
        end
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
}
