return {
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        event = "BufWinEnter",
        dependencies = {
            {
                "p00f/nvim-ts-rainbow",
            },
            {
                "nvim-treesitter/nvim-treesitter-refactor",
            },
            {
                "windwp/nvim-ts-autotag",
                event = "InsertEnter",
            },
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                rainbow = {
                    enable = true,
                    extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                    max_file_lines = nil,  -- Do not enable for files with more than n lines, int
                },
                autopairs = {
                    enable = true,
                },
                autotag = {
                    enable = true,
                },
                refactor = {
                    highlight_definitions = {
                        enable = true,
                    },
                    highlight_current_scope = {
                        enable = true,
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
                context_commentstring = {
                    enable = true,
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                    disable = {},
                },
                indent = {
                    enable = true,
                    disable = {},
                },
                ensure_installed = {
                    "python",
                    "lua",
                    "comment",
                    "json",
                    "php",
                    "typescript",
                    "vue",
                    "css",
                    "regex",
                    "gomod",
                    "bash",
                    "yaml",
                    "vim",
                    "html",
                    "javascript",
                    "go",
                    "fish",
                    "dockerfile",
                    "rust",
                    "toml",
                    "graphql",
                    "scss",
                    "hcl",
                    "markdown",
                    "markdown_inline",
                },
                sync_install = false,
            })
        end
    },
    {
        "terrortylor/nvim-comment",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                after = "nvim-treesitter",
            },
        },
        config = function()
            require("nvim_comment").setup({
                -- Linters prefer comment and line to have a space in between markers
                marker_padding = true,
                -- should comment out empty or whitespace only lines
                comment_empty = false,
                -- Should key mappings be created
                create_mappings = true,
                -- Normal mode mapping left hand side
                line_mapping = "gcc",
                -- Visual/Operator mapping left hand side
                operator_mapping = "gc",
                -- Hook function to call before commenting takes place
                hook = function()
                    require("ts_context_commentstring.internal").update_commentstring({})
                end,
            })

            vim.cmd([[
augroup set-commentstring-ag
autocmd!
autocmd BufEnter *.fish :lua vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
autocmd BufFilePost *.fish :lua vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
augroup END
]])
        end
    },
    {
        "glepnir/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            local saga = require("lspsaga")

            saga.setup({
                outline = {
                    auto_preview = false,
                    keys = {
                        expand_or_jump = "<cr>",
                    },
                },
                finder = {
                    max_height = 0.5,
                    min_width = 30,
                    force_max_height = false,
                    keys = {
                        expand_or_jump = "<cr>",
                    },
                },
            })

            -- Lsp finder find the symbol definition implement reference
            -- if there is no implement it will hide
            -- when you use action in finder like open vsplit then you can
            -- use <C-t> to jump back
            vim.keymap.set("n", "gd", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

            -- Code action
            vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })

            -- Rename
            vim.keymap.set("n", "<leader>gr", "<cmd>Lspsaga rename<CR>", { silent = true })
            vim.keymap.set({ "n", "t" }, "<leader>d", "<cmd>Lspsaga term_toggle<CR>")

            -- Peek Definition
            -- you can edit the definition file in this flaotwindow
            -- also support open/vsplit/etc operation check definition_action_keys
            -- support tagstack C-t jump back
            vim.keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

            -- Show line diagnostics
            vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

            -- Show cursor diagnostics
            vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

            -- Diagnostic jump can use `<c-o>` to jump back
            vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
            vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

            -- Only jump to error
            vim.keymap.set("n", "[D", function()
                require("lspsaga.diagnostic").goto_prev({
                    severity = vim.diagnostic.severity.ERROR,
                })
            end, { silent = true })

            vim.keymap.set("n", "]D", function()
                require("lspsaga.diagnostic").goto_next({
                    severity = vim.diagnostic.severity.ERROR,
                })
            end, { silent = true })

            -- Outline
            -- @todo https://github.com/glepnir/lspsaga.nvim/issues/648
            vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { silent = true })

            -- Call hierarchy
            vim.keymap.set("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
            vim.keymap.set("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

            -- Hover Doc
            vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
            -- api.nvim_create_autocmd("LspAttach", {
            -- 	callback = function(args)
            -- 		keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
            -- 	end,
            -- })

            vim.keymap.set("n", "<F6>", "<cmd>LspInfo<cr>", { silent = true })
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            --Please make sure you install markdown and markdown_inline parser
            { "nvim-treesitter/nvim-treesitter" }
        }
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        config = function()
            local lsp = require('lsp-zero').preset({})

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
            end)

            -- (Optional) Configure lua language server for neovim
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

            lsp.setup({
                set_lsp_keymaps = {
                    preserve_mappings = false,
                    omit = {},
                },
            })
            lsp.format_on_save({
                format_opts = {
                    timeout_ms = 10000,
                },
                servers = {
                    ['lua_ls'] = { 'lua' },
                    ['rust_analyzer'] = { 'rust' },
                }
            })

            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                {
                    underline = true,
                    virtual_text = {
                        spacing = 5,
                        severity_limit = "Warning",
                    },
                    update_in_insert = true,
                }
            )

            local cmp = require('cmp')
            local cmp_action = require('lsp-zero').cmp_action()

            cmp.setup({
                -- preselect first item in autocomplete
                -- preselect = 'item',
                -- completion = {
                --     completeopt = 'menu,menuone,noinsert'
                -- },
                mapping = {
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
                    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    -- ['<Tab>'] = cmp_action.luasnip_supertab(),
                    -- ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),

                    ['<Tab>'] = cmp_action.tab_complete(),
                    ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
                    -- ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    -- ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                }
            })
        end,
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },      -- Required
            { 'hrsh7th/cmp-nvim-lsp' },  -- Required
            { 'L3MON4D3/LuaSnip' },      -- Required
        },
    },
    {
        -- Optional
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('mason').setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "tsserver",
                    "eslint",
                    "astro",
                    "dockerls",
                    "docker_compose_language_service",
                    "gopls",
                    "graphql",
                    "html",
                    "helm_ls",
                    "jsonls",
                    "intelephense",
                    "ruff_lsp",
                    -- "pyright",
                    "sqlls",
                    "terraformls",
                    "volar",
                    "vuels",
                    "yamlls",
                    "lemminx",
                    "cssls",
                    -- "cssmodules_ls",
                    -- "tflint",
                },
                automatic_installation = true,
            })
        end,
        dependencies = {
            'williamboman/mason.nvim',
        },
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup({
                enable_check_bracket_line = true, -- Don't add pairs if it already have a close pairs in same line
                disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
                enable_afterquote = false,        -- add bracket pairs after quote
                enable_moveright = true,
            })

            if vim.o.ft == "clap_input" and vim.o.ft == "guihua" and vim.o.ft == "guihua_rust" then
                require("cmp").setup.buffer({
                    completion = {
                        enable = false,
                    },
                })
            end

            -- If you want insert `(` after select function or method item
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            local Rule = require("nvim-autopairs.rule")

            npairs.add_rules({
                -- before   insert  after
                --  (|)     ( |)	( | )
                Rule(" ", " "):with_pair(function(opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    return vim.tbl_contains({ "()", "[]", "{}" }, pair)
                end),
                Rule("( ", " )")
                    :with_pair(function()
                        return false
                    end)
                    :with_move(function(opts)
                        return opts.prev_char:match(".%)") ~= nil
                    end)
                    :use_key(")"),
                Rule("{ ", " }")
                    :with_pair(function()
                        return false
                    end)
                    :with_move(function(opts)
                        return opts.prev_char:match(".%}") ~= nil
                    end)
                    :use_key("}"),
                Rule("[ ", " ]")
                    :with_pair(function()
                        return false
                    end)
                    :with_move(function(opts)
                        return opts.prev_char:match(".%]") ~= nil
                    end)
                    :use_key("]"),
                --[===[
    arrow key on javascript
        Before 	Insert    After
        (item)= 	> 	    (item)=> { }
    --]===]
                Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript" })
                    :use_regex(true)
                    :set_end_pair_length(2),
            })
        end
    }
}
