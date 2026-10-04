-- Full local config: shared base plus the complete plugin set.

local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
dofile(config_dir .. "/core.lua")

-- приглушённые направляющие отступов snacks.indent (обычные и текущий scope), для светлой и тёмной темы
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local light = vim.o.background == "light"
    vim.api.nvim_set_hl(0, "SnacksIndent", { fg = light and "#e4dcd4" or "#2c2c30" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = light and "#d3c7bb" or "#4d4766" })
  end,
})

local plugins = {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "^1.0.0",
    opts = {
      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },

        ["<Enter>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      },
      signature = { enabled = true },
      completion = {
        documentation = { auto_show = false },
        ghost_text = {
          enabled = false,
        },
        menu = {
          auto_show = true,
        },
      },
      sources = {
        default = {
          "lsp",
          "path",
          -- "snippets",
          -- 'buffer',
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },

  -- golang development
  {
    "ray-x/go.nvim",
    version = "^0.11.0",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      -- "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- lsp_keymaps = false,
      -- other options
    },
    -- config = function(_, opts)
    --   require("go").setup(opts)
    --   local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     pattern = "*.go",
    --     callback = function()
    --       require('go.format').goimports()
    --     end,
    --     group = format_sync_grp,
    --   })
    -- end,
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },

  {
    "windwp/nvim-autopairs",
    version = "^0.11.0",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        disable_in_macro = false,
        disable_in_visualblock = false,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true,
        check_ts = true,
        map_bs = true,
        map_c_h = false,
        map_c_w = false,
      })
    end,
  },
  {
    "grafana/vim-alloy",
    ft = "alloy",
    config = function()
      vim.filetype.add({
        extension = {
          alloy = "alloy",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    version = "^2.0.0",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        -- small lsp progress plugin
        "j-hui/fidget.nvim",
        version = "^2.0.0",
        opts = {},
      },
      -- {
      --   -- code formatting tool
      --   "stevearc/conform.nvim",
      --   version = "^9.0.0",
      --   opts = {
      --     formatters_by_ft = {
      --       lua = { "stylua" },
      --       sql = { "sql_formatter" },
      --       vue = { "prettierd" },
      --       typescript = { "prettierd" },
      --       -- javascript = { "prettierd" },
      --       css = { "prettierd" },
      --       graphql = { "prettierd" },
      --       json = { "prettierd" },
      --       yaml = { "yamlfmt" },
      --       scss = { "prettierd" },
      --       html = { "prettierd" },
      --       python = { "ruff_format" },
      --       -- nix = { "nixfmt" },
      --       toml = { "taplo" },
      --       go = { "goimports", "gofumpt", "golangci-lint" },
      --
      --       -- terraform = { "tofu_fmt" },
      --       -- tf = { "tofu_fmt" },
      --       -- tofu = { "tofu_fmt" },
      --       -- hcl = { "tofu_fmt" },
      --     },
      --     -- formatters = {
      --     --   tofu_fmt = {
      --     --     command = "tofu",
      --     --     args = { "fmt", "-" },
      --     --     stdin = true,
      --     --   },
      --     -- },
      --     -- format_on_save = function(bufnr)
      --     --   if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      --     --     return
      --     --   end
      --
      --     -- if vim.bo[bufnr].filetype == "yaml" then
      --     --   return
      --     -- end
      --
      --     --   return { timeout_ms = 500, lsp_fallback = true }
      --     -- end,
      --     format_on_save = {
      --       -- These options will be passed to conform.format()
      --       -- async = false,
      --       lsp_fallback = true,
      --       timeout_ms = 500,
      --       quiet = true,
      --       -- lsp_format = "fallback",
      --     },
      --   },
      --   config = function(_, opts)
      --     require("conform").setup(opts)
      --
      --     vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      --   end,
      -- },
    },
    config = function()
      -- Experiment: LSP semantic tokens are disabled, highlighting comes from treesitter only.
      -- They repainted treesitter colors ~0.5-1s after a file opens.
      -- To revert, delete this line (or toggle at runtime:
      -- :lua vim.lsp.semantic_tokens.enable(not vim.lsp.semantic_tokens.is_enabled())).
      -- Softer alternative: keep them below treesitter instead of disabling:
      -- vim.hl.priorities.semantic_tokens = 95
      vim.lsp.semantic_tokens.enable(false)

      -- Neovim never rotates lsp.log (it only warns past 1 GB). Rotate it here, before any server starts
      -- and the log is opened: past 5 MB it becomes lsp.log.old (overwriting the previous one).
      -- To turn LSP logging off entirely: vim.lsp.log.set_level(vim.log.levels.OFF)
      local lsp_log = vim.lsp.log.get_filename()
      local lsp_log_stat = vim.uv.fs_stat(lsp_log)
      if lsp_log_stat and lsp_log_stat.size > 5 * 1024 * 1024 then
        vim.uv.fs_rename(lsp_log, lsp_log .. ".old")
      end

      -- projects where format on save is disabled
      local no_format_projects = {
        -- website = true,
        -- website_business = true,
      }

      vim.lsp.config("*", {
        on_attach = function(client, bufnr)
          local project = vim.fs.basename(client.root_dir or vim.fn.getcwd())
          if no_format_projects[project] then
            return
          end
          if client:supports_method('textDocument/formatting') then
            local grp = vim.api.nvim_create_augroup('LspFormat' .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = grp,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  silent = true,
                  bufnr = bufnr,
                  async = false,
                  timeout_ms = 2000,
                })
              end,
            })
          end
        end,
        capabilities = require("blink.cmp").get_lsp_capabilities({
          workspace = {
            -- Enable file watching capability for new/deleted files
            didChangeWatchedFiles = {
              dynamicRegistration = true
            }
          },
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = true,
              },
            },
            semanticTokens = {
              multilineTokenSupport = true,
            },
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        }),
      })

      ---------------------------------- vue typescript

      local vue_language_server_path = "/Users/max/.bun/install/global/node_modules/@vue/language-server"
      local tsserver_filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
      }

      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
      }
      vim.lsp.config("ts_ls", {
        filetypes = tsserver_filetypes,
        init_options = {
          plugins = { vue_plugin },
        },
      })

      vim.lsp.config("vue_ls", {
        cmd = { "bun", "--bun", os.getenv("HOME") .. "/.bun/bin/vue-language-server", "--stdio" },
      })

      vim.lsp.config("vtsls", {
        cmd = { "bun", "--bun", os.getenv("HOME") .. "/.bun/bin/vtsls", "--stdio" },
        filetypes = tsserver_filetypes,
        -- cmd = { "vtsls", "--stdio" },
        root_markers = {
          "tsconfig.json",
          "package.json",
          ".git",
        },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                vue_plugin,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
          },
        },
      })

      ---------------------------------- vue typescript

      vim.lsp.config("golangci_lint_ls", {
        init_options = {
          command = {
            "golangci-lint",
            "run",
            "--output.json.path",
            "stdout",
            "--show-stats=false",
            "--issues-exit-code=1",
          },
        },
      })

      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc" },
        settings = {
          Lua = {
            runtime = { version = "Lua 5.1" },
            diagnostics = {
              globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
            },
          },
        },
      })

      vim.lsp.config("graphql", {
        filetypes = { "graphql", "graphqls", "typescriptreact", "javascriptreact" },
      })

      vim.lsp.config("tofu_ls", {
        -- tofu-ls logs every job to stderr, which Neovim copies into lsp.log at ERROR level (was ~99% of it)
        cmd = { "tofu-ls", "serve", "-log-file", "/dev/null" },
        filetypes = { "opentofu", "opentofu-vars", "terraform", "terraform-vars" },
        root_markers = {
          ".terraform",
          ".git",
          "root.tf",
          "main.tf",
          ".terraform.lock.hcl",
        },
      })

      vim.lsp.config("intelephense", {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_markers = { ".git", "composer.json" },
        settings = { intelephense = { files = {} } },
        -- The client keeps a reference to this settings table, so before_init mutates it instead of reassigning.
        -- Setting files.exclude replaces intelephense's defaults, so they are repeated here. Project dirs are
        -- anchored to the root: a bare "**/cache/**" would also hide vendor/psr/cache and vendor/symfony/cache.
        before_init = function(_, config)
          local root = config.root_dir
          if not root then
            return
          end
          local exclude = {
            "**/.git/**",
            "**/.svn/**",
            "**/.hg/**",
            "**/CVS/**",
            "**/.DS_Store/**",
            "**/node_modules/**",
            "**/bower_components/**",
            "**/vendor/**/{Tests,tests}/**",
            "**/.history/**",
            "**/vendor/**/vendor/**",
          }
          for _, dir in ipairs({ "private", "cache", "temp", "logs", "var/doctrine/proxies" }) do
            table.insert(exclude, root .. "/" .. dir .. "/**")
          end
          config.settings.intelephense.files.exclude = exclude
        end,
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
              "/.gitlab-ci.yml",
            },
          },
        },
      })

      vim.lsp.enable({
        -- lua
        "lua_ls",

        -- postgres
        "postgres_lsp",

        -- vue, typescript
        "vtsls",
        "vue_ls",

        -- golang
        "gopls",
        "golangci_lint_ls",

        -- docker
        "dockerls",
        "docker_compose_language_service",

        -- graphql
        "graphql",

        -- jsonnet (k8s, grafana)
        "jsonnet_ls",

        -- gitlab ci, github ci
        "yamlls",

        -- protobuf
        "protols",

        -- python
        "basedpyright",

        -- terraform: tofu_ls covers terraform filetypes and does its own validation.
        -- terraformls and tflint are off: their binaries aren't installed (brew install tflint to bring it back).
        "tofu_ls",

        -- vscode language servers
        "cssls",
        "jsonls",
        "html",
        -- 'eslint',

        -- php
        "intelephense"
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
          vim.keymap.set("n", "<leader>R", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
          vim.keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

          -- neovim go
          -- vim.keymap.set("n", "<leader>tt", "<cmd>GoTestFunc<cr>", opts)

          vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.jump({ count = -1 })<cr>", opts)
          vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.jump({ count = 1 })<cr>", opts)
        end,
      })
    end,
  },

  {
    "echasnovski/mini.comment",
    event = "BufWinEnter",
    version = "^0.18.0",
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
    "nvim-treesitter/nvim-treesitter",
    -- main branch: setup() no longer takes highlight/ensure_installed/textobjects;
    -- parsers are installed via install() and highlighting is started per buffer.
    -- Requires tree-sitter-cli (brew install tree-sitter-cli).
    branch = "main",
    commit = "074aa4422bf029908338e855d0c0f71470a971bb",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

      -- Parsers missing from nvim-treesitter. Must be registered before install():
      -- install()/update() fire TSUpdate and read the parser list after it.
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          local parsers = require("nvim-treesitter.parsers")
          -- no queries in the repo, they live in queries/haproxy/ of this config
          parsers.haproxy = {
            install_info = {
              url = "https://github.com/thochra/tree-sitter-haproxy",
              revision = "59e19f2b55be588dadbf8b038b294e5ed935cbb2",
            },
          }
          parsers.nftables = {
            install_info = {
              url = "https://github.com/acd407/tree-sitter-nftables",
              revision = "32afd3418f9380f8c84b2d7f4ab8e68431bde5ee",
              -- the repo has no src/parser.c and no src/grammar.json: generate from grammar.js
              generate = true,
              generate_from_json = false,
              queries = "queries",
            },
          }
        end,
      })

      -- OpenTofu files are parsed as Terraform
      vim.treesitter.language.register("terraform", { "opentofu", "opentofu-vars" })

      -- async; already installed parsers are skipped
      require("nvim-treesitter").install({
        "astro",
        "bash",
        "css",
        -- "dockerfile",
        "fish",
        "go",
        "graphql",
        "haproxy",
        "hcl",
        "html",
        "javascript",
        "json",
        "jsonnet",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "nftables",
        "nginx",
        "nix",
        "php",
        "phpdoc",
        "promql",
        "proto",
        "scss",
        "sql",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vue",
        "yaml",
      })

      local max_filesize = 1 * 1024 * 1024 -- 1 MB, skip slow highlighting on large files
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
          if ok and stats and stats.size > max_filesize then
            return
          end
          -- no-op (returns false) when there is no parser for this filetype
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      require("nvim-treesitter-textobjects").setup({
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V",  -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          include_surrounding_whitespace = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      for keys, spec in pairs({
        ["af"] = { "@function.outer" },
        ["if"] = { "@function.inner" },
        ["ac"] = { "@class.outer" },
        ["ic"] = { "@class.inner", desc = "Select inner part of a class region" },
        ["as"] = { "@local.scope", "locals", desc = "Select language scope" },
      }) do
        vim.keymap.set({ "x", "o" }, keys, function()
          select.select_textobject(spec[1], spec[2] or "textobjects")
        end, { desc = spec.desc })
      end
    end,
  },

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
    "folke/trouble.nvim",
    version = "^3.0.0",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "folke/todo-comments.nvim",
        version = "^1.0.0",
      },
    },
    opts = {
      focus = true,
      modes = {
        mydiags = {
          mode = "diagnostics", -- inherit from diagnostics mode
          filter = {
            any = {
              buf = 0,                                    -- current buffer
              {
                severity = vim.diagnostic.severity.ERROR, -- errors only
                function(item)
                  return item.filename:find((vim.uv or vim.loop).cwd(), 1, true)
                end,
              },
            },
          },
        },
      },
    },
    cmd = "Trouble",
    keys = {
      { "<leader>tt", "<cmd>Trouble mydiags toggle<CR>", desc = "Open trouble workspace diagnostics" },
      {
        "<leader>qq",
        -- "<cmd>Trouble diagnostics toggle focus=false<cr>",
        "<cmd>Trouble diagnostics toggle focus=false win.position=right<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    "folke/snacks.nvim",
    version = "^2.0.0",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      zen = {
        enabled = true,
        dim = true,
      },
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = {
        enabled = true,
        animate = { enabled = false },
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
          fuzzy = true,          -- use fuzzy matching
          smartcase = true,      -- use smartcase
          ignorecase = true,     -- use ignorecase
          sort_empty = false,    -- sort results when the search string is empty
          filename_bonus = true, -- give bonus for matching file names (last part of the path)
          file_pos = true,       -- support patterns like `file:line:col` and `file:line`
          -- the bonusses below, possibly require string concatenation and path normalization,
          -- so this can have a performance impact for large lists and increase memory usage
          cwd_bonus = false,     -- give bonus for matching files in the cwd
          frecency = false,      -- frecency bonus
          history_bonus = false, -- give more weight to chronological order
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
        right = { "fold" },        -- priority of signs on the right (high to low)
        folds = {
          open = false,            -- open fold icons need a fold level lookup per line on every redraw
        },
        refresh = 50,              -- refresh at most every 50ms
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
          Snacks.picker.colorschemes({
            -- hide the colorschemes bundled with Neovim ($VIMRUNTIME/colors), and plugin ones shadowed by
            -- them: :colorscheme prefers a .vim anywhere in rtp, so the plugin's catppuccin.lua would load
            -- the bundled catppuccin.vim instead
            transform = function(item)
              local bundled = vim.env.VIMRUNTIME .. "/colors/"
              return not vim.startswith(item.file, bundled) and vim.fn.filereadable(bundled .. item.text .. ".vim") == 0
            end,
          })
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
  -- {
  --   "akinsho/bufferline.nvim",
  --   version = "*",
  --   dependencies = "nvim-tree/nvim-web-devicons",
  --   opts = {},
  -- },
  -- {
  --   "brenoprata10/nvim-highlight-colors",
  --   event = { "BufReadPre", "BufNewFile" },
  --   config = function()
  --     require("nvim-highlight-colors").setup({
  --       render = "background",
  --       enable_hex = true,
  --       enable_short_hex = true,
  --       enable_rgb = true,
  --       enable_hsl = true,
  --       enable_var_usage = true,
  --       enable_named_colors = true,
  --       enable_tailwind = false,
  --       custom_colors = nil,
  --       exclude_filetypes = {
  --         "dashboard",
  --         "NvimTree",
  --         "lazy",
  --         "mason",
  --         "help",
  --         "terminal",
  --         "packer",
  --         "lspinfo",
  --         "TelescopePrompt",
  --         "TelescopeResults",
  --       },
  --     })
  --   end,
  -- },
  -- colors/sonokai.lua is compiled, it needs no plugin at runtime. Its source is the lush spec in
  -- lua/lush_theme/sonokai.lua: :Lushify in that buffer previews edits live, :Shipwright (run from this
  -- directory) rebuilds colors/sonokai.lua from it via shipwright_build.lua.
  { "rktjmp/lush.nvim", cmd = "Lushify" },
  { "rktjmp/shipwright.nvim", cmd = "Shipwright", dependencies = { "rktjmp/lush.nvim" } },
  -- colorscheme "terminal" (colors/terminal.lua, generated by ~/.dotfiles/bin/theme-sync) is built on
  -- mini.base16; loaded on require so it stays selectable from the colorscheme picker
  { "echasnovski/mini.base16", version = "^0.18.0", lazy = true },

  -- colorschemes on trial: lazy, so they cost nothing at startup; the colorscheme picker (<leader>uC)
  -- lists them and lazy.nvim loads a plugin when its colorscheme is picked. All transparent, like sonokai.
  {
    "loctvl842/monokai-pro.nvim",
    lazy = true,
    opts = { transparent_background = true, filter = "spectrum" },
  },
  { "catppuccin/nvim", name = "catppuccin", lazy = true, opts = { transparent_background = true } },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
      on_colors = function(c)
        -- burgundy style: the active float border is derived from blue1 (types), use burgundy instead
        if c.burgundy then
          c.border_highlight = c.burgundy.border
        end
      end,
    },
    config = function(_, opts)
      -- extra style "burgundy" (colors/tokyonight-burgundy.lua): night with a dark brown background, warm
      -- greys and burgundy accents. Set as a palette, before tokyonight derives selection/search/diff from it.
      -- Text accent #cc5a72 is the darkest burgundy with 4.5:1 contrast on the background; deep burgundy
      -- #7a1f33 is only used as a background (search, selection).
      require("tokyonight.colors").styles.burgundy = function()
        return vim.tbl_deep_extend("force", vim.deepcopy(require("tokyonight.colors.night")), {
          bg = "#1e1612",
          bg_dark = "#18110e",
          bg_dark1 = "#120c0a",
          bg_highlight = "#2b211b", -- cursorline
          blue = "#cc5a72",         -- main accent: functions, titles, directories
          blue0 = "#7a1f33",        -- search, selection (blended)
          blue7 = "#4a2630",        -- diff text, inlay hint background
          fg_gutter = "#4a3a30",
          dark3 = "#5e4c41",
          dark5 = "#8f7d70",
          comment = "#86746a",
          terminal_black = "#4d3e34",
          burgundy = { border = "#a8324a" },
        })
      end
      require("tokyonight").setup(opts)
    end,
  },
  { "rebelot/kanagawa.nvim", lazy = true, opts = { transparent = true } },
  {
    -- main colorscheme: dayfox in the light macOS appearance, carbonfox in the dark one, switching while
    -- running. Loaded first (priority) so other plugins set their default highlights on top of it.
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- transparent: the background comes from the terminal, so tmux can dim inactive panes
      require("nightfox").setup({ options = { transparent = true } })

      local schemes = { light = "dayfox", dark = "carbonfox" }
      -- last seen appearance: startup applies it right away instead of waiting ~5 ms for `defaults read`,
      -- the real one is checked asynchronously right after
      local state_file = vim.fn.stdpath("state") .. "/appearance"
      local f = io.open(state_file)
      local mode = f and f:read("*l")
      if f then
        f:close()
      end
      mode = schemes[mode] and mode or "dark"
      vim.cmd.colorscheme(schemes[mode])

      if vim.fn.has("mac") == 0 then
        return
      end

      local function check()
        -- AppleInterfaceStyle is "Dark" in the dark appearance and missing (exit code 1) in the light one
        vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }, function(res)
          local new = (res.stdout or ""):match("Dark") and "dark" or "light"
          if new == mode then
            return
          end
          mode = new
          vim.schedule(function()
            vim.cmd.colorscheme(schemes[mode])
            local out = io.open(state_file, "w")
            if out then
              out:write(mode)
              out:close()
            end
          end)
        end)
      end

      -- nothing notifies a terminal app of appearance changes: poll (async, a ~5 ms `defaults` run every
      -- 3 s) and check at once when the window gets focus back
      local timer = assert(vim.uv.new_timer())
      timer:start(0, 3000, check)
      vim.api.nvim_create_autocmd("FocusGained", { callback = check })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          timer:close()
        end,
      })
    end,
  },
  { "rose-pine/neovim", name = "rose-pine", lazy = true, opts = { styles = { transparency = true } } },
  -- {
  --   "f-person/auto-dark-mode.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     set_dark_mode = function()
  --       vim.cmd("colorscheme nightfox")
  --     end,
  --     set_light_mode = function()
  --       vim.cmd("colorscheme dayfox")
  --     end,
  --     update_interval = 3000,
  --     fallback = "light",
  --   },
  -- },
  -- {
  --   "EdenEast/nightfox.nvim",
  --   config = function()
  --     require("nightfox").setup({
  --       options = {
  --         -- transparent = true,
  --         terminal_colors = true,
  --       },
  --     })
  --     vim.cmd("colorscheme nightfox")
  --   end,
  -- },
  -- {
  --   "akinsho/bufferline.nvim",
  --   version = "*",
  --   dependencies = "nvim-tree/nvim-web-devicons",
  --   opts = {
  --     options = {
  --       diagnostics = "nvim_lsp",
  --       separator_style = { "", "" },
  --       modified_icon = "!",
  --       show_close_icon = false,
  --       show_buffer_close_icons = false,
  --     },
  --   },
  -- },
  {
    "alexghergh/nvim-tmux-navigation",
    opts = {
      disable_when_zoomed = true,
    },
    keys = function()
      local function nav(direction)
        return function()
          require("nvim-tmux-navigation")["NvimTmuxNavigate" .. direction]()
        end
      end
      return {
        { "<C-\\>",      nav("LastActive") },
        { "<C-Space>",   nav("Next") },
        -- C-w + h/j/k/l or arrow: like the built-in window keys, but continues
        -- into tmux panes
        { "<C-w>h",       nav("Left") },
        { "<C-w>j",       nav("Down") },
        { "<C-w>k",       nav("Up") },
        { "<C-w>l",       nav("Right") },
        { "<C-w><Left>",  nav("Left") },
        { "<C-w><Down>",  nav("Down") },
        { "<C-w><Up>",    nav("Up") },
        { "<C-w><Right>", nav("Right") },
      }
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    branch = "master",
    lazy = true, -- loaded on require by neo-tree, trouble and the snacks picker
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "^3.0.0",
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
    cmd = "Neotree",
    keys = {
      { "<C-n>", "<cmd>Neotree filesystem reveal toggle current<CR>", silent = true },
      { "<C-g>", "<cmd>Neotree git_status toggle current<CR>",       silent = true },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
      vim.g.loaded_netrw = 1

      -- lazy-loaded, so `nvim <dir>` has to load it explicitly for hijack_netrw_behavior to take over
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NeotreeStartDirectory", { clear = true }),
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          end
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end,
      })
    end,
    config = function()
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
              deleted = "",
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
    end,
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    -- Work profile (same as the fish `claude-work` wrapper) only inside the work repos, personal profile elsewhere.
    -- Decided once at startup: the plugin reads CLAUDE_CONFIG_DIR at load time to place the IDE lockfile.
    init = function()
      local work_dirs = {
        vim.fn.expand("~/projects/ecarstrade/website"),
        vim.fn.expand("~/projects/ecarstrade/website_business"),
      }
      local cwd = vim.fn.resolve(vim.fn.getcwd())
      local is_work_dir = false
      for _, dir in ipairs(work_dirs) do
        if cwd == dir or vim.startswith(cwd, dir .. "/") then
          is_work_dir = true
          break
        end
      end
      vim.env.CLAUDE_CONFIG_DIR = is_work_dir and vim.fn.expand("~/.claude-work") or nil
    end,
    opts = {
      terminal = {
        snacks_win_opts = {
          position = "float",
          width = 0.85,
          height = 0.85,
          border = "rounded",
          keys = {
            claude_hide = {
              "<C-q>",
              function(self)
                self:hide()
              end,
              mode = "t",
              desc = "Hide Claude",
            },
          },
        },
      },
    },
    keys = {
      { "<leader>i",  nil,                              desc = "Claude Code" },
      { "<leader>ii", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>if", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ir", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>iC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>im", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ib", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>is", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
      {
        "<leader>is",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      { "<leader>ia", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>id", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
  },
}

require("lazy").setup({
  spec = plugins,
  change_detection = { enabled = false, notify = false },
  ui = { border = "single", title = "Lazy", title_pos = "left" },
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json", -- hide lockfile away
  performance = {
    rtp = {
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
