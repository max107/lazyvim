return {
    {
        "luukvbaal/statuscol.nvim",
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup({
                segments = {
                    {
                        sign = {
                            name = { "Diagnostic" },
                            auto = true
                        },
                        click = "v:lua.ScSa"
                    },
                    {
                        text = { builtin.foldfunc },
                        click = "v:lua.ScFa",
                    },
                    {
                        text = { builtin.lnumfunc },
                        click = "v:lua.ScLa",
                        sign = {
                            maxwidth = 4,
                            auto = true
                        },
                    },
                    {
                        sign = {
                            name = { ".*" },
                            maxwidth = 2,
                            colwidth = 1,
                            wrap = true,
                        },
                        click = "v:lua.ScSa"
                    },
                }
            })
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
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
