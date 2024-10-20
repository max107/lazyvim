return {
    -- {
    --     "ellisonleao/gruvbox.nvim",
    --     priority = 1000,
    --     opt = {
    --         transparent = true,
    --         styles = {
    --             sidebars = "transparent",
    --             float = "transparent",
    --         },
    --     },
    --     config = function()
    --         vim.cmd('colorscheme gruvbox')
    --     end
    -- },
    {
        "projekt0n/github-nvim-theme",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd('colorscheme github_dark')

            vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
            vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
        end
    },
}
