return {
    {
        "taybart/b64.nvim",
        config = function()
            -- vnoremap <silent> <leader>be :<c-u>lua require("b64").encode()<cr>
            -- vnoremap <silent> <leader>bd :<c-u>lua require("b64").decode()<cr>
        end
    },
    {
        "LunarVim/bigfile.nvim",
    },
}
