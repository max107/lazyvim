return {
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({
                ui = {
                    code_action = ''
                },
                finder = {
                    default = 'ref+imp+def+tyd',
                    methods = {
                        tyd = "textDocument/typeDefinition"
                    },
                    keys = {
                        toggle_or_open = '<cr>'
                    }
                },
                outline = {
                    keys = {
                        toggle_or_jump = '<cr>'
                    }
                }
            })
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons'      -- optional
        }
    },
}
