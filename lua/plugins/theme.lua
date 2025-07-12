return {
    {
        "projekt0n/github-nvim-theme",
        lazy = false,
        priority = 1000,
        config = function()
            require('github-theme').setup({
                options = {
                    transparent = true,
                }
            })

            vim.cmd('colorscheme github_dark')

            vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
        end
    },
    -- {
    --     'echasnovski/mini.tabline',
    --     version = '*',
    --     opts = {
    --         show_icons = false,
    --     }
    -- },
    -- {
    --     'akinsho/bufferline.nvim',
    --     version = "*",
    --     dependencies = 'nvim-tree/nvim-web-devicons',
    --     opts = {
    --         options = {
    --             diagnostics = "nvim_lsp",
    --             separator_style = { "", "" },
    --             modified_icon = '!',
    --             show_close_icon = false,
    --             show_buffer_close_icons = false,
    --         }
    --
    --     }
    -- },
}
