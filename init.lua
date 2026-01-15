local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })

vim.opt.cursorline = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.softtabstop = 4
vim.opt.termguicolors = true
vim.opt.mouse = ""
vim.opt.hidden = true
vim.opt.fileformats = "unix,mac,dos"
vim.opt.virtualedit = "block"
vim.opt.wildignorecase = true
vim.opt.wildignore =
  ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/vendor/**"
vim.opt.history = 2000
vim.opt.shada = "!,'300,<50,@100,s10,h"
vim.opt.smarttab = true
vim.opt.shiftround = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.complete = ".,w,b,k"
vim.opt.inccommand = "nosplit"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --hidden --vimgrep --smart-case --"
vim.opt.breakat = [[\ \	;:,!?]]
vim.opt.startofline = false
vim.opt.whichwrap = "h,l,<,>,[,],~"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.switchbuf = "useopen"
vim.opt.diffopt = "filler,iwhite,internal,algorithm:patience"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.jumpoptions = "stack"
vim.opt.showmode = false
vim.opt.shortmess = "aoOTIcF"
vim.opt.scrolloff = 2
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.sidescrolloff = 5
vim.opt.ruler = false
vim.opt.winwidth = 30
vim.opt.showtabline = 0
vim.opt.winminwidth = 10
vim.opt.pumheight = 15
vim.opt.helpheight = 12
vim.opt.previewheight = 12
vim.opt.showcmd = false
vim.opt.equalalways = false
vim.opt.laststatus = 0
vim.opt.showbreak = "↳  "
vim.opt.statuscolumn = ""
vim.opt.signcolumn = "yes"
vim.opt.undofile = true
vim.opt.synmaxcol = 2500
vim.opt.formatoptions = "1jcroql"
vim.opt.textwidth = 80
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.breakindentopt = "shift:2,min:20"
vim.opt.wrap = false
vim.opt.linebreak = false -- Wrap on word boundary
vim.opt.colorcolumn = "120"
vim.opt.winborder = "single"
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 4

vim.keymap.del("n", "gcc")
vim.keymap.del("n", "gc")

vim.diagnostic.config({
  -- virtual_text = {
  --   current_line = true,
  -- },
  -- virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  -- virtual_lines = true,
  virtual_text = { current_line = false },
  virtual_lines = { current_line = false },
})

vim.opt.clipboard = "unnamedplus"

if vim.loop.os_uname().sysname == "Darwin" then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }
  vim.g.python_host_prog = "/usr/bin/python"
  vim.g.python3_host_prog = "/usr/local/bin/python3"
end

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Highlight on yank
local yankGrp = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank({higroup='IncSearch', timeout=100})",
  group = yankGrp,
})

-- show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "set cursorline",
  group = cursorGrp,
})
vim.api.nvim_create_autocmd(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- Remove whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", { command = [[:%s/\s\+$//e]] })

-- Don't auto commenting new lines
vim.api.nvim_create_autocmd("BufEnter", { command = [[set fo-=c fo-=r fo-=o]] })

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd(
  "BufReadPost",
  { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

-- kill all floating windows
vim.keymap.set(
  "n",
  "<leader>cc",
  ':lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= "" then vim.api.nvim_win_close(win, false); print("Closing window", win) end end<CR>',
  { remap = false }
)

-- Stay in indent mode
local n_opts = { silent = true, noremap = true }
-- Normal mode
vim.keymap.set("n", "<", "<<", n_opts)
vim.keymap.set("n", ">", ">>", n_opts)
-- Visual --
vim.keymap.set("v", "<", "<gv", n_opts)
vim.keymap.set("v", ">", ">gv", n_opts)
-- buffer switch --
vim.keymap.set("n", "gp", ":bprev<cr>", n_opts)
vim.keymap.set("n", "gn", ":bnext<cr>", n_opts)
vim.keymap.set("v", "gp", ":bprev<cr>", n_opts)
vim.keymap.set("v", "gn", ":bnext<cr>", n_opts)

-- use leader with w for save file
vim.keymap.set("n", "<leader>w", ":w<cr>", n_opts)

-- close all popup windows
vim.keymap.set("n", "<leader>ka", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
      print("Closing window", win)
    end
  end
end, n_opts)

vim.cmd([[
command! W execute ":w"
command! Wq execute ":wq"
command! WQ execute ":wq"
]])

vim.cmd([[autocmd BufNewFile,BufRead *.nomad setfiletype hcl]])

local plugins = {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
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
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
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
  {
    "xzbdmw/colorful-menu.nvim",
    opts = {
      ls = {
        lua_ls = {
          -- Maybe you want to dim arguments a bit.
          arguments_hl = "@comment",
        },
        gopls = {
          -- By default, we render variable/function's type in the right most side,
          -- to make them not to crowd together with the original label.

          -- when true:
          -- foo             *Foo
          -- ast         "go/ast"

          -- when false:
          -- foo *Foo
          -- ast "go/ast"
          align_type_to_right = true,
          -- When true, label for field and variable will format like "foo: Foo"
          -- instead of go's original syntax "foo Foo". If align_type_to_right is
          -- true, this option has no effect.
          add_colon_before_type = false,
          -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
          preserve_type_when_truncate = true,
        },
        -- for lsp_config or typescript-tools
        ts_ls = {
          -- false means do not include any extra info,
          -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
          extra_info_hl = "@comment",
        },
        vtsls = {
          -- false means do not include any extra info,
          -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
          extra_info_hl = "@comment",
        },
        ["rust-analyzer"] = {
          -- Such as (as Iterator), (use std::io).
          extra_info_hl = "@comment",
          -- Similar to the same setting of gopls.
          align_type_to_right = true,
          -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
          preserve_type_when_truncate = true,
        },
        clangd = {
          -- Such as "From <stdio.h>".
          extra_info_hl = "@comment",
          -- Similar to the same setting of gopls.
          align_type_to_right = true,
          -- the hl group of leading dot of "•std::filesystem::permissions(..)"
          import_dot_hl = "@comment",
          -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
          preserve_type_when_truncate = true,
        },
        zls = {
          -- Similar to the same setting of gopls.
          align_type_to_right = true,
        },
        roslyn = {
          extra_info_hl = "@comment",
        },
        dartls = {
          extra_info_hl = "@comment",
        },
        -- The same applies to pyright/pylance
        basedpyright = {
          -- It is usually import path such as "os"
          extra_info_hl = "@comment",
        },
        pylsp = {
          extra_info_hl = "@comment",
          -- Dim the function argument area, which is the main
          -- difference with pyright.
          arguments_hl = "@comment",
        },
        -- If true, try to highlight "not supported" languages.
        fallback = true,
        -- this will be applied to label description for unsupport languages
        fallback_extra_info_hl = "@comment",
      },
      -- If the built-in logic fails to find a suitable highlight group for a label,
      -- this highlight is applied to the label.
      fallback_highlight = "@variable",
      -- If provided, the plugin truncates the final displayed text to
      -- this width (measured in display cells). Any highlights that extend
      -- beyond the truncation point are ignored. When set to a float
      -- between 0 and 1, it'll be treated as percentage of the width of
      -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
      -- Default 60.
      max_width = 60,
    },
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
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
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "nfnty/vim-nftables",
  },
  {
    "terrastruct/d2-vim",
    ft = { "d2" },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        disable_in_macro = false,
        disable_in_visualblock = false,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true,
        check_ts = false,
        map_bs = true,
        map_c_h = false,
        map_c_w = false,
      })
    end,
  },
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
            nix = { "nixfmt" },
            hcl = { "hcl" },
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
          -- vim.keymap.set("n", "<leader>tt", "<cmd>GoTestFunc<cr>", opts)

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
  { "google/vim-jsonnet" },
  { "Joorem/vim-haproxy" },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {},
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-highlight-colors").setup({
        render = "background",
        enable_hex = true,
        enable_short_hex = true,
        enable_rgb = true,
        enable_hsl = true,
        enable_var_usage = true,
        enable_named_colors = true,
        enable_tailwind = false,
        custom_colors = nil,
        exclude_filetypes = {
          "dashboard",
          "NvimTree",
          "lazy",
          "mason",
          "help",
          "terminal",
          "packer",
          "lspinfo",
          "TelescopePrompt",
          "TelescopeResults",
        },
      })
    end,
  },
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[
        let g:sonokai_transparent_background = 1
        colorscheme sonokai
      ]])
    end,
  },
  -- {
  --   "f-person/auto-dark-mode.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     set_dark_mode = function()
  --       vim.cmd("colorscheme sonokai")
  --     end,
  --     set_light_mode = function()
  --       vim.cmd("colorscheme github_light_default")
  --     end,
  --     update_interval = 3000,
  --     fallback = "dark",
  --   },
  -- },
  -- {
  --   "projekt0n/github-nvim-theme",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("github-theme").setup({
  --       options = {
  --         transparent = true,
  --       },
  --     })
  --
  --     -- if vim.o.background == "light" then
  --     --   vim.cmd('colorscheme github_light_default')
  --     -- else
  --     --   vim.cmd('colorscheme github_dark')
  --     -- end
  --
  --     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
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
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")

      nvim_tmux_nav.setup({
        disable_when_zoomed = true,
      })

      vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
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

      local opts = { noremap = true, silent = true }

      vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>Neotree filesystem reveal toggle current<CR>", opts)
      vim.api.nvim_set_keymap("n", "<C-g>", "<cmd>Neotree git_status toggle current<CR>", opts)
    end,
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
