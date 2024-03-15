return {
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {
            disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function()
            -- If you want insert `(` after select function or method item
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufWinEnter",
        dependencies = {
            "p00f/nvim-ts-rainbow",
            "nvim-treesitter/nvim-treesitter-refactor",
            'JoosepAlviste/nvim-ts-context-commentstring',
            {
                "windwp/nvim-ts-autotag",
                event = "InsertEnter",
            },
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                rainbow = {
                    enable = true,
                    extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                    max_file_lines = nil,  -- Do not enable for files with more than n lines, int
                },
                -- autopairs = {
                --     enable = false,
                -- },
                autotag = {
                    enable = true,
                },
                refactor = {
                    highlight_definitions = {
                        enable = true,
                    },
                    highlight_current_scope = {
                        enable = false,
                    },
                    smart_rename = {
                        enable = true,
                        keymaps = {
                            smart_rename = "grr",
                        },
                    },
                    navigation = {
                        enable = false,
                        -- enable = true,
                        -- keymaps = {
                        --   goto_definition = "gd",
                        --   list_definitions = "gD",
                        --   list_definitions_toc = "gO",
                        --   goto_next_usage = "<a-*>",
                        --   goto_previous_usage = "<a-#>",
                        -- },
                    },
                },
                highlight = {
                    enable = true,
                    disable = {},
                },
                indent = {
                    enable = true,
                    disable = {},
                },
                ensure_installed = {
                    "lua",
                    "json",
                    "astro",
                    "typescript",
                    "css",
                    "sql",
                    "bash",
                    "yaml",
                    "html",
                    "javascript",
                    "go",
                    "terraform",
                    "fish",
                    "dockerfile",
                    "toml",
                    "graphql",
                    "scss",
                    "hcl",
                    "markdown",
                },
                sync_install = false,
            })
        end
    },
    -- {
    --     "nvim-treesitter/nvim-treesitter-context"
    -- }
}
