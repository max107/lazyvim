return {
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
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        -- small lsp progress plugin
        "j-hui/fidget.nvim",
        opts = {},
      },
      {
        -- code formatting tool
        "stevearc/conform.nvim",
        opts = {
          formatters_by_ft = {
            lua = { "stylua" },
            sql = { "sql_formatter" },
            vue = { "prettierd" },
            typescript = { "prettierd" },
            javascript = { "prettierd" },
            css = { "prettierd" },
            graphql = { "prettierd" },
            json = { "prettierd" },
            yaml = { "prettierd" },
            templ = { "templ" },
            scss = { "prettierd" },
            html = { "prettierd" },
            python = { "ruff_format" },
            toml = { "taplo" },
            terraform = { "terraform_fmt" },
            go = { "goimports", "gofumpt", "golangci-lint" },
          },
          format_on_save = {
            -- These options will be passed to conform.format()
            async = false,
            lsp_fallback = false,
            timeout_ms = 500,
            -- lsp_format = "fallback",
          },
        },
        config = function(_, opts)
          require("conform").setup(opts)

          vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
      },
    },
    opts = {
      inlay_hints = { enabled = false },
    },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities({
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

      vim.lsp.config("vue_ls", {
        cmd = { "bun", "--bun", os.getenv("HOME") .. "/.bun/bin/vue-language-server", "--stdio" },
      })

      vim.lsp.config("vtsls", {
        cmd = { "bun", "--bun", os.getenv("HOME") .. "/.bun/bin/vtsls", "--stdio" },
        -- cmd = { "vtsls", "--stdio" },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
        },
        root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = "/Users/max/.bun/install/global/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
          },
        },
      })

      vim.lsp.config("terraformls", {
        root_markers = { ".terraform", ".git", "root.tf", "main.tf", ".terraform.lock.hcl" },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci.yml",
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
        "templ",

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

        -- terraform
        "terraformls",
        "tflint",

        -- vscode language servers
        "cssls",
        "jsonls",
        "html",
        -- 'eslint',
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
          vim.keymap.set("n", "<leader>R", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
          vim.keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

          -- neovim go
          vim.keymap.set("n", "<leader>tt", "<cmd>GoTestFunc<cr>", opts)

          vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
          vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
        end,
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
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    event = "BufWinEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(_, buf)
            local max_filesize = 1 * 1024 * 1024 -- 1 MB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true or false
            include_surrounding_whitespace = true,
          },
        },
        ensure_installed = {
          "astro",
          "bash",
          "css",
          "dockerfile",
          "fish",
          "go",
          "graphql",
          "hcl",
          "html",
          "javascript",
          "json",
          "lua",
          "make",
          "markdown",
          "nginx",
          "nix",
          "promql",
          "proto",
          "scss",
          "sql",
          "templ",
          "terraform",
          "toml",
          "typescript",
          "vue",
          "yaml",
        },
      })
    end,
  },
}
