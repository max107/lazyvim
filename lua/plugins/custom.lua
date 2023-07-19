return {
    {
        "taybart/b64.nvim",
        config = function()
            -- vnoremap <silent> <leader>be :<c-u>lua require("b64").encode()<cr>
            -- vnoremap <silent> <leader>bd :<c-u>lua require("b64").decode()<cr>
        end
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
        'echasnovski/mini.pairs',
        version = false,
        config = function()
            require('mini.pairs').setup()
        end
    },
}
