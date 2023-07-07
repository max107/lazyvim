return {
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            char = "»",
            show_trailing_blankline_indent = false,
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = false,
                component_separators = "|",
                section_separators = "",
            },
            sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1,
                    }
                },
                lualine_x = {
                    -- {
                    --     function() return [[DEBUG: ]] .. require('dap').status() end,
                    --     cond = function() return string.len(require('dap').status()) ~= 0 end,
                    --     color = "WarningMsg"
                    -- },
                    { "encoding" },
                    { "fileformat" },
                    { "filetype" },
                }
            }
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup {}
        end
    },
    {
        'echasnovski/mini.pairs',
        version = false,
        config = function()
            require('mini.pairs').setup()
        end
    },
}
