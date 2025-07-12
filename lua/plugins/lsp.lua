return {
    {
        "xzbdmw/colorful-menu.nvim",
        config = function()
            -- You don't need to set these options.
            require("colorful-menu").setup({
                ls = {
                    lua_ls = {
                        -- Maybe you want to dim arguments a bit.
                        arguments_hl = "@comment",
                    },
                    gopls = {
                        -- By default, we render variable/function's type in the right most side,
                        -- to make them not to crowd together with the original label.

                        -- when true:
                        -- foo             *Foo
                        -- ast         "go/ast"

                        -- when false:
                        -- foo *Foo
                        -- ast "go/ast"
                        align_type_to_right = true,
                        -- When true, label for field and variable will format like "foo: Foo"
                        -- instead of go's original syntax "foo Foo". If align_type_to_right is
                        -- true, this option has no effect.
                        add_colon_before_type = false,
                        -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
                        preserve_type_when_truncate = true,
                    },
                    -- for lsp_config or typescript-tools
                    ts_ls = {
                        -- false means do not include any extra info,
                        -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
                        extra_info_hl = "@comment",
                    },
                    vtsls = {
                        -- false means do not include any extra info,
                        -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
                        extra_info_hl = "@comment",
                    },
                    ["rust-analyzer"] = {
                        -- Such as (as Iterator), (use std::io).
                        extra_info_hl = "@comment",
                        -- Similar to the same setting of gopls.
                        align_type_to_right = true,
                        -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
                        preserve_type_when_truncate = true,
                    },
                    clangd = {
                        -- Such as "From <stdio.h>".
                        extra_info_hl = "@comment",
                        -- Similar to the same setting of gopls.
                        align_type_to_right = true,
                        -- the hl group of leading dot of "•std::filesystem::permissions(..)"
                        import_dot_hl = "@comment",
                        -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
                        preserve_type_when_truncate = true,
                    },
                    zls = {
                        -- Similar to the same setting of gopls.
                        align_type_to_right = true,
                    },
                    roslyn = {
                        extra_info_hl = "@comment",
                    },
                    dartls = {
                        extra_info_hl = "@comment",
                    },
                    -- The same applies to pyright/pylance
                    basedpyright = {
                        -- It is usually import path such as "os"
                        extra_info_hl = "@comment",
                    },
                    pylsp = {
                        extra_info_hl = "@comment",
                        -- Dim the function argument area, which is the main
                        -- difference with pyright.
                        arguments_hl = "@comment",
                    },
                    -- If true, try to highlight "not supported" languages.
                    fallback = true,
                    -- this will be applied to label description for unsupport languages
                    fallback_extra_info_hl = "@comment",
                },
                -- If the built-in logic fails to find a suitable highlight group for a label,
                -- this highlight is applied to the label.
                fallback_highlight = "@variable",
                -- If provided, the plugin truncates the final displayed text to
                -- this width (measured in display cells). Any highlights that extend
                -- beyond the truncation point are ignored. When set to a float
                -- between 0 and 1, it'll be treated as percentage of the width of
                -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
                -- Default 60.
                max_width = 60,
            })
        end,
    },
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',
        opts = {
            keymap = {
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-e>'] = { 'hide', 'fallback' },

                ['<Enter>'] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    'snippet_forward',
                    'fallback'
                },
                ['<Tab>'] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    'snippet_forward',
                    'fallback'
                },
                ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },
                ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
                ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

                ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
            },
            appearance = {
            },
            signature = { enabled = true },
            completion = {
                documentation = { auto_show = false },
                ghost_text = {
                    enabled = false,
                },
                menu = {
                    auto_show = true,
                    draw = {
                        -- We don't need label_description now because label and label_description are already
                        -- combined together in label by colorful-menu.nvim.
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },

                },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = {
                textDocument = {
                    semanticTokens = {
                        multilineTokenSupport = true
                    },
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true
                    }

                }
            }

            vim.lsp.config("*", {
                capabilities = require('blink.cmp').get_lsp_capabilities(capabilities),
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

                    -- vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    -- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    -- vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    -- vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    -- vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    -- vim.keymap.set({ 'n', 'x' }, '<leader>cf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

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
}
