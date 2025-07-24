return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        opts = {
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              buftype = { "terminal", "quickfix" },
            },
          },
        },
      },
    },
    config = function()
      -- disable netrw
      vim.g.loaded_netrwPlugin = 1
      vim.g.loaded_netrw = 1

      require("neo-tree").setup({
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        use_default_mappings = false,
        popup_border_style = "single",
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
        sort_case_insensitive = true, -- used when sorting files and directories in the tree
        default_component_configs = {
          modified = {
            symbol = "[+]",
          },
          name = {
            trailing_slash = true,
            use_git_status_colors = true,
          },
          git_status = {
            symbols = {
              -- Change type
              added = "+", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = ".", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = "", -- this can only be used in the git_status source
              renamed = "󰁕", -- this can only be used in the git_status source
              -- Status type
              untracked = "?",
              ignored = "/",
              unstaged = "±",
              staged = "✓",
              conflict = "✗",
            },
          },
          file_size = {
            enabled = true,
            required_width = 64, -- min width of window required to show this column
          },
          type = {
            enabled = true,
            required_width = 122, -- min width of window required to show this column
          },
          last_modified = {
            enabled = false,
            required_width = 88, -- min width of window required to show this column
          },
          created = {
            enabled = false,
            required_width = 110, -- min width of window required to show this column
          },
          symlink_target = {
            enabled = false,
          },
        },
        -- A list of functions, each representing a global custom command
        -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
        -- see `:h neo-tree-custom-commands-global`
        commands = {},
        window = {
          position = "left",
          width = 40,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<cr>"] = { "open" },
            ["<esc>"] = "cancel",
            ["a"] = { "add", config = { show_path = "relative" } },
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = { "copy", config = { show_path = "relative" } },
            ["m"] = "move",
            ["R"] = "refresh",
            ["i"] = "show_file_details",

            ["h"] = "close_node",
            ["<Left>"] = "close_node",

            ["l"] = "open",
            ["<Right>"] = "open",
          },
        },
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
            hide_by_name = {
              "node_modules",
              "htmlcov",
              "venv",
              ".idea",
              ".git",
            },
            never_show = {
              ".DS_Store",
              "thumbs.db",
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          group_empty_dirs = false,
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
            },
            fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up",
            },
          },

          commands = {}, -- Add a custom command or override a global one using the same function name
        },
        buffers = {},
      })

      local opts = { noremap = true, silent = true }

      vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>Neotree filesystem reveal toggle current<CR>", opts)
      vim.api.nvim_set_keymap("n", "<C-g>", "<cmd>Neotree git_status toggle current<CR>", opts)
    end,
  },
}
