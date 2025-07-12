return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = false },
            indent = { enabled = true },
            input = { enabled = false },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = false },
            statuscolumn = {
                enabled = true,
                left = { "mark", "sign" }, -- priority of signs on the left (high to low)
                right = { "fold", "git" }, -- priority of signs on the right (high to low)
                folds = {
                    open = true,           -- show open fold icons
                    git_hl = true,         -- use Git Signs hl for fold icons
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
            { "<leader>b",  function() Snacks.picker.buffers() end,              desc = "Buffers" },
            { "<leader>f",  function() Snacks.picker.files() end,                desc = "Find Files" },
            { "<leader>p",  function() Snacks.picker.git_files() end,            desc = "Find Git Files" },
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
            { "<leader>g",  function() Snacks.picker.grep() end,                 desc = "Grep" },
            -- { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
            -- -- search
            -- { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
            -- { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
            { "<leader>sd", function() Snacks.picker.diagnostics() end,          desc = "Diagnostics" },
            -- { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
            { "<leader>sk", function() Snacks.picker.keymaps() end,              desc = "Keymaps" },
            -- { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
            -- -- LSP
            { "gd",         function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition" },
            { "gD",         function() Snacks.picker.lsp_declarations() end,     desc = "Goto Declaration" },
            { "gr",         function() Snacks.picker.lsp_references() end,       nowait = true,                  desc = "References" },
            { "gI",         function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementation" },
            { "gy",         function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
            -- { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
            -- { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
        },
    }
}
