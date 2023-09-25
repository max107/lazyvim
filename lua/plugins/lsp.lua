return {
    -- LSP Support
    {
        'neovim/nvim-lspconfig',
        cmd = 'LspInfo',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'williamboman/mason-lspconfig.nvim',
            {
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
        },
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            local lsp = require('lsp-zero').preset({})
            lsp.setup({
                inlay_hints = {
                    enabled = false
                },
                set_lsp_keymaps = {
                    preserve_mappings = false,
                    omit = {},
                },
            })

            local lspconfig = require('lspconfig')

            lsp.set_server_config({
                on_init = function(client)
                    -- if this is not working, move to on_attach
                    -- https://github.com/williamboman/mason-lspconfig.nvim/issues/211
                    client.server_capabilities.semanticTokensProvider = nil
                end,
            })

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
            end)

            -- (Optional) Configure lua language server for neovim
            lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    -- lsp.buffer_autoformat()

                    local opts = { buffer = event.buf }

                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    vim.keymap.set('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

                    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
                    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
                    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
                end
            })

            lsp.format_on_save({
                format_opts = {
                    timeout_ms = 10000,
                },
                servers = {
                    -- ['terraformls'] = { 'tf' },
                    ['gopls'] = { 'go' },
                    ['astro'] = { 'astro' },
                    ['prettier'] = { 'scss' },
                    ['lua_ls'] = { 'lua' },
                    ['rust_analyzer'] = { 'rust' },
                }
            })

            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                {
                    underline = true,
                    virtual_text = {
                        spacing = 3,
                        severity_limit = "Warning",
                    },
                    update_in_insert = true,
                }
            )
        end
    },
    {
        -- Optional
        'williamboman/mason-lspconfig.nvim',
        config = function()
            local lsp_zero = require('lsp-zero')

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "tsserver",
                    "astro",
                    "dockerls",
                    "docker_compose_language_service",
                    "gopls",
                    "html",
                    "jsonls",
                    "intelephense",
                    "terraformls",
                    "cssls",
                },
                -- automatic_installation = true,
                handlers = {
                    lsp_zero.default_setup,
                }
            })
        end,
        dependencies = {
            {
                "williamboman/mason.nvim",
                build = ":MasonUpdate",
                config = function()
                    require("mason").setup({
                        ui = {
                            icons = {
                                package_installed = "✓",
                                package_pending = "➜",
                                package_uninstalled = "✗"
                            }
                        }
                    })
                end
            },
        },
    },
}
