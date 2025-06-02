return {
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup {
                options = {
                    diagnostics = "nvim_lsp",
                    separator_style = { "", "" },
                    modified_icon = '!',
                    show_close_icon = false,
                    show_buffer_close_icons = false,
                }
            }
        end
    },
    "google/vim-jsonnet",
    "rfratto/vim-river",
    "Joorem/vim-haproxy",
    -- {
    --     "kylechui/nvim-surround",
    --     version = "*", -- Use for stability; omit to use `main` branch for the latest features
    --     event = "VeryLazy",
    --     config = function()
    --         require("nvim-surround").setup({
    --             -- Configuration here, or leave empty to use defaults
    --         })
    --     end
    -- },
}
