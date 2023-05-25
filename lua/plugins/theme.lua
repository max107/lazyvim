return {
    -- {
    --     "sainnhe/sonokai",
    --     config = function()
    --         vim.cmd([[ colorscheme sonokai ]])
    --     end,
    -- },
    -- {
    --     "savq/melange-nvim",
    --     config = function()
    --         vim.cmd([[ colorscheme melange ]])
    --     end,
    -- },
    {
        "doums/darcula",
        config = function()
            vim.cmd([[ colorscheme darcula ]])
        end,
    },
    -- {
    --     "EdenEast/nightfox.nvim",
    --     config = function()
    --         require('nightfox').setup({
    --             options = {
    --                 transparent = false,
    --                 terminal_colors = true,
    --             },
    --             palettes = {},
    --             specs = {},
    --             groups = {},
    --         })
    --         vim.cmd([[ colorscheme carbonfox ]])
    --         -- vim.cmd([[ colorscheme dayfox ]])
    --     end,
    -- }
}
