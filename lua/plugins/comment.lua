return {
    {
        'numToStr/Comment.nvim',
        lazy = false,
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        config = function()
            require('Comment').setup({
                mappings = {
                    basic = true,
                    extra = false,
                },
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
        end
    },
}
