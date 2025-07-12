return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.semanticTokens.multilineTokenSupport = true
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }

            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            vim.lsp.config("lua_ls", {
                cmd = { 'lua-language-server' },
                filetypes = { 'lua' },
                root_markers = { '.luarc.json', '.luarc.jsonc' },
                settings = {
                    Lua = {
                        runtime = { version = 'Lua 5.1' },
                        diagnostics = {
                            globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
                        },
                    },
                },
            })

            vim.lsp.config("vtsls", {
                cmd = { "vtsls", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
                root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
                settings = {
                    vtsls = {
                        tsserver = {
                            globalPlugins = {
                                {
                                    name = '@vue/typescript-plugin',
                                    location = '/Users/max/.bun/install/global/node_modules/@vue/language-server',
                                    languages = { 'vue' },
                                    configNamespace = 'typescript',
                                },
                            },
                        },
                    },
                },
            })

            vim.lsp.enable({
                "lua_ls",
                "gopls",
                "vtsls",
                "vue_ls",
            })

            vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = "*",
                callback = function()
                    vim.lsp.buf.format()
                end,
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
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
                    vim.keymap.set('n', '<leader>co', '<cmd>Lspsaga outline<CR>', opts)
                    -- vim.keymap.set('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

                    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
                    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
                end
            })
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
    -- {
    --     "ray-x/go.nvim",
    --     dependencies = { -- optional packages
    --         "ray-x/guihua.lua",
    --         "neovim/nvim-lspconfig",
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --     config = function()
    --         require("go").setup({
    --             silent = false,    -- less notifications
    --             term = "terminal", -- a terminal to run ("terminal"|"toggleterm")
    --             lsp_inlay_hints = {
    --                 enable = true
    --             },
    --             termOpts = {
    --                 direction = "vertical", -- terminal's direction ("horizontal"|"vertical"|"float")
    --                 width = 96,             -- terminal's width (for vertical|float)
    --                 height = 24,            -- terminal's height (for horizontal|float)
    --                 go_back = false,        -- return focus to original window after executing
    --                 stopinsert = "auto",    -- exit from insert mode (true|false|"auto")
    --                 keep_one = true,        -- keep only one terminal for testing
    --             },
    --         })
    --
    --         vim.keymap.set("n", "<leader>tf", ":GoTestFile<CR>", { remap = false })
    --         vim.keymap.set("n", "<leader>tt", ":GoTestFunc<CR>", { remap = false })
    --         vim.keymap.set("n", "<leader>tp", ":GoTestPkg<CR>", { remap = false })
    --     end,
    --     event = { "CmdlineEnter" },
    --     ft = { "go", 'gomod' },
    --     build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
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
            })
        end
    },
    -- {
    --     "folke/trouble.nvim",
    --     opts = {},
    --     cmd = "Trouble",
    --     keys = {
    --         {
    --             "<leader>xx",
    --             "<cmd>Trouble diagnostics toggle<cr>",
    --             desc = "Diagnostics (Trouble)",
    --         },
    --         {
    --             "<leader>xb",
    --             "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    --             desc = "Buffer Diagnostics (Trouble)",
    --         },
    --     },
    -- },
}
