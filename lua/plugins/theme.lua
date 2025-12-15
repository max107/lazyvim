return {
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
  --   "projekt0n/github-nvim-theme",
  --   dependencies = {
  --     {
  --       "f-person/auto-dark-mode.nvim",
  --       lazy = false,
  --       priority = 1000,
  --       opts = {
  --         set_dark_mode = function()
  --           vim.cmd('colorscheme github_dark')
  --         end,
  --         set_light_mode = function()
  --           vim.cmd('colorscheme github_light_default')
  --         end,
  --         update_interval = 3000,
  --         fallback = "dark"
  --       }
  --     },
  --   },
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('github-theme').setup({
  --       options = {
  --         transparent = true,
  --       }
  --     })
  --
  --     -- if vim.o.background == "light" then
  --     --   vim.cmd('colorscheme github_light_default')
  --     -- else
  --     --   vim.cmd('colorscheme github_dark')
  --     -- end
  --
  --     vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  --     vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  --     vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
  --     vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
  --   end
  -- },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        separator_style = { "", "" },
        modified_icon = "!",
        show_close_icon = false,
        show_buffer_close_icons = false,
      },
    },
  },
}
