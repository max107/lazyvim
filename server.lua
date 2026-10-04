-- Minimal config for remote/server use: shared base only, no LSP/completion/treesitter.

local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
dofile(config_dir .. "/core.lua")

local plugins = {
  { "nfnty/vim-nftables" },
  {
    "grafana/vim-alloy",
    config = function()
      vim.filetype.add({
        extension = {
          alloy = "alloy",
        },
      })
    end,
  },
  {
    "echasnovski/mini.comment",
    version = "*",
    opts = {
      mappings = {
        comment = "",
        comment_line = "gc",
        comment_visual = "gc",
        textobject = "gc",
      },
    },
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")

      nvim_tmux_nav.setup({
        disable_when_zoomed = true,
      })

      vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
      -- C-w + h/j/k/l or arrow: like the built-in window keys, but continues
      -- into tmux panes
      vim.keymap.set("n", "<C-w>h", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-w>j", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-w>k", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-w>l", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<C-w><Left>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-w><Down>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-w><Up>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-w><Right>", nvim_tmux_nav.NvimTmuxNavigateRight)
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
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
      vim.g.loaded_netrwPlugin = 1
      vim.g.loaded_netrw = 1

      require("neo-tree").setup({
        close_if_last_window = true,
        use_default_mappings = false,
        popup_border_style = "single",
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        sort_case_insensitive = true,
        default_component_configs = {
          modified = { symbol = "[+]" },
          name = { trailing_slash = true, use_git_status_colors = true },
          git_status = {
            symbols = {
              added = "+",
              modified = ".",
              deleted = "",
              renamed = "󰁕",
              untracked = "?",
              ignored = "/",
              unstaged = "±",
              staged = "✓",
              conflict = "✗",
            },
          },
          file_size = { enabled = true, required_width = 64 },
          type = { enabled = true, required_width = 122 },
          last_modified = { enabled = false, required_width = 88 },
          created = { enabled = false, required_width = 110 },
          symlink_target = { enabled = false },
        },
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
  {
    "akinsho/bufferline.nvim",
    version = "*",
    opts = {},
  },
}

require("lazy").setup({
  -- the colorscheme and its plugin live in themes/, shared with init.lua
  spec = { plugins, dofile(config_dir .. "/themes/plugins.lua") },
  change_detection = { enabled = false, notify = false },
  ui = { border = "single", title = "Lazy", title_pos = "left" },
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json", -- hide lockfile away
  performance = {
    rtp = {
      paths = { config_dir .. "/themes" }, -- keep it after lazy.nvim resets 'runtimepath'
      disabled_plugins = {
        "osc52",
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "spellfile",
        "rplugin",
      },
    },
  },
})
