return {
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup {
                filters = {
                    dotfiles = false,
                },
                disable_netrw = true,
                hijack_netrw = true,
                hijack_cursor = true,
                hijack_unnamed_buffer_when_opening = false,
                sync_root_with_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = false,
                },
                view = {
                    adaptive_size = false,
                    side = "left",
                    width = 25,
                    preserve_window_proportions = true,
                },
                git = {
                    enable = false,
                    ignore = true,
                },
                filesystem_watchers = {
                    enable = true,
                },
                modified = {
                    enable = true,
                    show_on_dirs = true,
                    show_on_open_dirs = true,
                },
                actions = {
                    open_file = {
                        quit_on_open = false,
                        resize_window = true,
                    },
                },
                renderer = {
                    root_folder_label = false,
                    highlight_git = false,
                    highlight_opened_files = "none",
                    indent_markers = {
                        enable = false,
                    },
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = false,
                        },
                        glyphs = {
                            default = "󰈚",
                            symlink = "",
                            folder = {
                                default = "",
                                empty = "",
                                empty_open = "",
                                open = "",
                                symlink = "",
                                symlink_open = "",
                                arrow_open = "",
                                arrow_closed = "",
                            },
                            git = {
                                unstaged = "✗",
                                staged = "✓",
                                unmerged = "",
                                renamed = "➜",
                                untracked = "★",
                                deleted = "",
                                ignored = "◌",
                            },
                        },
                    },
                },
            }

            local opts = { noremap = true, silent = true }

            vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>NvimTreeFindFile<CR>", opts)
            vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", opts)
        end
    }
}
