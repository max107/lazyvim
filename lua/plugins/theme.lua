return {
    -- {
    --     "roobert/palette.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require("palette").setup({
    --             palettes = {
    --                 -- built in colorscheme: grey
    --                 main = "dust_dusk",
    --                 -- built in accents: pastel, bright, dark
    --                 accent = "pastel",
    --                 state = "pastel",
    --             },
    --
    --             italics = true,
    --             transparent_background = true,
    --
    --             custom_palettes = {
    --                 main = {
    --                     dust_dusk = {
    --                         color0 = "#121527",
    --                         color1 = "#1A1E39",
    --                         color2 = "#232A4D",
    --                         color3 = "#3E4D89",
    --                         color4 = "#687BBA",
    --                         color5 = "#A4B1D6",
    --                         color6 = "#bdbfc9",
    --                         color7 = "#DFE5F1",
    --                         color8 = "#e9e9ed",
    --                     },
    --                 },
    --             },
    --             accent = {},
    --             state = {},
    --         })
    --         vim.cmd.colorscheme "palette"
    --     end,
    -- },
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
