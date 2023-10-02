return {
    "Joorem/vim-haproxy",
    {
        'echasnovski/mini.nvim',
        version = '*',
        config = function()
            require('mini.ai').setup()
        end
    },
}
