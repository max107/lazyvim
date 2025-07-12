return {
    {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = 'make' },
    },
    config = function()
        -- You dont need to set any of these options. These are the default ones. Only
        -- the loading is important
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                    },
                },
                -- prompt_position = "top",
                -- sorting_strategy = "ascending",
                file_ignore_patterns = {
                    "node_modules",
                    "vendor",
                    "venv",
                    "htmlcov",
                    ".idea",
                    ".git",
                    "symfony/var/.*",
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--trim",
                    "--no-ignore",
                    "--hidden",
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                    previewer = false,
                },
                git_files = {
                    hidden = true,
                    previewer = false,
                },
                live_grep = {
                    hidden = true,
                    previewer = false,
                    only_sort_text = true,
                },
                buffers = {
                    previewer = false,
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,                   -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true,    -- override the file sorter
                    case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
            },
        })
        -- To get fzf loaded and working with telescope, you need to call
        -- load_extension, somewhere after setup function:
        -- telescope.load_extension("fzf")

        local n_opts = { silent = true, noremap = true }
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>f", builtin.find_files, n_opts)
        vim.keymap.set("n", "<leader>g", builtin.live_grep, n_opts)
        -- vim.keymap.set("n", "<leader>fr", builtin.marks, n_opts)
        vim.keymap.set("n", "<leader>b", function()
            builtin.buffers({
                sort_mru = true,
                ignore_current_buffer = true
            })
        end, n_opts)
        vim.keymap.set("n", "<leader>p", builtin.git_status, n_opts)
        vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, n_opts)
    end
}
}
