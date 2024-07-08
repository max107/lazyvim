return {
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup({
                silent = false,    -- less notifications
                term = "terminal", -- a terminal to run ("terminal"|"toggleterm")
                lsp_inlay_hints = {
                    enable = true
                },
                termOpts = {
                    direction = "vertical", -- terminal's direction ("horizontal"|"vertical"|"float")
                    width = 96,             -- terminal's width (for vertical|float)
                    height = 24,            -- terminal's height (for horizontal|float)
                    go_back = false,        -- return focus to original window after executing
                    stopinsert = "auto",    -- exit from insert mode (true|false|"auto")
                    keep_one = true,        -- keep only one terminal for testing
                },
            })

            vim.keymap.set("n", "<leader>tf", ":GoTestFile<CR>", { remap = false })
            vim.keymap.set("n", "<leader>tt", ":GoTestFunc<CR>", { remap = false })
            vim.keymap.set("n", "<leader>tp", ":GoTestPkg<CR>", { remap = false })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
}
