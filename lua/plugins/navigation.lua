return {
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   ---@type Flash.Config
  --   opts = {
  --     char = {
  --       enabled = false,
  --       keys = { ";" },
  --     },
  --   },
  --   -- stylua: ignore
  --   keys = {
  --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --   },
  -- },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- TODO fixme
      -- @todo fix highlight
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info", alt = { "todo" } },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        pattern = { [[.*<(KEYWORDS)\s*]], [[.*<@(KEYWORDS)\s*]] },
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
  },

  -- {
  --   "folke/trouble.nvim",
  --   opts = {},
  --   cmd = "Trouble",
  --   keys = {
  --     {
  --       "<leader>qq",
  --       "<cmd>Trouble diagnostics toggle focus=false<cr>",
  --       desc = "Quickfix List (Trouble)",
  --     },
  --   },
  -- },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
    opts = {
      focus = true,
    },
    cmd = "Trouble",
    keys = {
      { "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
      {
        "<leader>tb",
        "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "Open trouble document diagnostics",
      },
      { "<leader>tq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
      { "<leader>tl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
      { "<leader>td", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      zen = {
        enabled = true,
        dim = true,
        git_signs = true,
        mini_diff_signs = false,
      },
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = {
        enabled = true,
      },
      input = { enabled = false },
      picker = {
        enabled = true,
        -- layout = {
        --   cycle = true,
        --   preset = "vertical",
        -- },
        ---@class snacks.picker.matcher.Config
        matcher = {
          fuzzy = true, -- use fuzzy matching
          smartcase = true, -- use smartcase
          ignorecase = true, -- use ignorecase
          sort_empty = false, -- sort results when the search string is empty
          filename_bonus = true, -- give bonus for matching file names (last part of the path)
          file_pos = true, -- support patterns like `file:line:col` and `file:line`
          -- the bonusses below, possibly require string concatenation and path normalization,
          -- so this can have a performance impact for large lists and increase memory usage
          cwd_bonus = true, -- give bonus for matching files in the cwd
          frecency = true, -- frecency bonus
          history_bonus = true, -- give more weight to chronological order
        },
      },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      lazygit = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = true, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      words = { enabled = false },
    },
    keys = {
      -- Top Pickers & Explorer
      -- { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
      -- { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      -- { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
      -- { "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
      -- { "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },
      -- find
      {
        "<leader>b",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>f",
        function()
          Snacks.picker.files({
            hidden = true,
            exclude = {
              "test/",
              "node_modules/",
              "vendor/",
              "/__mocks__/",
            },
          })
        end,
        desc = "Find Files",
      },
      {
        "<leader>p",
        function()
          Snacks.picker.git_status({
            exclude = {
              "node_modules/",
              "vendor/",
            },
          })
        end,
        desc = "Find Git Files",
      },
      -- { "<leader>fp", function() Snacks.picker.projects() end,  desc = "Projects" },
      -- { "<leader>fr", function() Snacks.picker.recent() end,    desc = "Recent" },
      -- git
      -- { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
      -- { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      -- { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
      -- { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      -- { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
      -- { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
      -- { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
      -- -- Grep
      -- { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      {
        "<leader>g",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      -- { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
      -- -- search
      -- { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
      -- { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
      },
      -- { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      -- LSP
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Goto Definition",
      },
      {
        "gD",
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = "Goto Declaration",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = "References",
      },
      {
        "gI",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Goto Implementation",
      },
      {
        "gy",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Goto T[y]pe Definition",
      },
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP Workspace Symbols",
      },

      -- zen mode
      {
        "<leader>Z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle zen mode",
      },
      {
        "<leader>lg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },

      -- todo-comments
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Todo",
      },
    },
  },
}
