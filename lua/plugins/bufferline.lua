return {
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup {
                options = {
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "Tree",
                            separator = true,
                            text_align = "left"
                        }
                    },

                    diagnostics = "nvim_lsp",
                    separator_style = { "", "" },
                    modified_icon = '●',
                    show_close_icon = false,
                    show_buffer_close_icons = false,
                }
            }
        end
    },
}
