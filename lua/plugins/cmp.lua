return {
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            { 'VonHeikemen/lsp-zero.nvim' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
            -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

            require('lsp-zero.cmp').extend()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = require('lsp-zero.cmp').action()

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'cmp_tabnine' },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
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
    },
}
