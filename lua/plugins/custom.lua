return {
    {
        "rfratto/vim-river",
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            -- options
        },
    },
    "Joorem/vim-haproxy",
    "imsnif/kdl.vim",
    {
        'echasnovski/mini.nvim',
        version = '*',
        config = function()
            require('mini.ai').setup()
        end
    },
}
