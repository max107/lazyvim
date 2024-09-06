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
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
        config = function()
            local wk = require("which-key")
            wk.add({
                { "<leader>f",  group = "file" }, -- group
                { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
                { "<leader>fb", function() print("hello") end,   desc = "Foobar" },
                { "<leader>fn", desc = "New File" },
                { "<leader>f1", hidden = true },                                      -- hide this keymap
                { "<leader>w",  proxy = "<c-w>",                 group = "windows" }, -- proxy to window mappings
                {
                    "<leader>b",
                    group = "buffers",
                    expand = function()
                        return require("which-key.extras").expand.buf()
                    end
                },
                {
                    -- Nested mappings are allowed and can be added in any order
                    -- Most attributes can be inherited or overridden on any level
                    -- There's no limit to the depth of nesting
                    mode = { "n", "v" },                          -- NORMAL and VISUAL mode
                    { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
                    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
                }
            })
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
