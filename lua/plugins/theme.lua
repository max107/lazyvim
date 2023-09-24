return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = false,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    lsp_saga = true,
                    neotree = true
                },
                background = {
                    light = "latte",
                    dark = "mocha",
                },
            })

            vim.cmd.colorscheme "catppuccin"
        end,
    },
}
