return {
    {
        "sainnhe/sonokai",
        config = function()
            vim.cmd([[ colorscheme sonokai ]])

            -- remove background
            -- vim.cmd([[
            --   au ColorScheme * hi Normal ctermbg=none guibg=none
            --   au ColorScheme myspecialcolors hi Normal ctermbg=red guibg=red
            -- ]])
        end,
    }
}
