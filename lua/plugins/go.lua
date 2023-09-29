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
                lsp_inlay_hints = {
                    enable = true
                }
            })

            vim.keymap.set("n", "<leader>tf", ":GoTestFile<CR>", { remap = false })
            vim.keymap.set("n", "<leader>tt", ":GoTestFunc<CR>", { remap = false })
            vim.keymap.set("n", "<leader>tp", ":GoTestPkg<CR>", { remap = false })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    -- {
    --     "klen/nvim-test",
    --     -- opts = {
    --     --     -- TestSuite - run the whole test suite
    --     --     -- TestFile - run all tests for the current file
    --     --     -- TestEdit - edit tests for the current file
    --     --     -- TestNearest - run the test nearest to the cursor
    --     --     -- TestLast - rerun the latest test
    --     --     -- TestVisit - open the last run test in the current buffer
    --     --     -- TestInfo - show an information about the plugin
    --     --     term = "terminal",
    --     -- },
    --     config = function()
    --         require("nvim-test").setup({
    --             term = "terminal"
    --         })
    --         local opts = { silent = true, noremap = true }
    --         vim.keymap.set('n', '<leader>t', ':TestNearest<cr>', opts)
    --     end
    -- }
}
