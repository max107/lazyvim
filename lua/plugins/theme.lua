return {
    -- {
    --     "nyoom-engineering/oxocarbon.nvim",
    --     config = function()
    --         vim.cmd.colorscheme "oxocarbon"
    --
    --         vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --         vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    --     end
    -- },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = true,
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
