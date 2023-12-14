return {
    {
        "loctvl842/monokai-pro.nvim",
        name = "monokai-pro",
        priority = 1000,
        lazy = false,
        config = function()
            require("monokai-pro").setup({
                transparent_background = true,
            })
            vim.cmd([[colorscheme monokai-pro]])
        end
    }
}
