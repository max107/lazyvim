return {
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()

            vim.keymap.set("n", "<leader>tf", ":GoTestFile<CR>", { remap = false })
            vim.keymap.set("n", "<leader>tt", ":GoTestFunc<CR>", { remap = false })
            vim.keymap.set("n", "<leader>tp", ":GoTestPkg<CR>", { remap = false })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    }
}
