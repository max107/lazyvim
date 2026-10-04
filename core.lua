-- Shared base: options, keymaps, autocommands and commands used by both
-- init.lua (full local setup) and server.lua (minimal remote setup).

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- the colorscheme and everything around it (themes/plugins.lua)
vim.opt.rtp:append(vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/themes")

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
-- popup: docs of the selected item next to the menu
vim.opt.completeopt = "menu,menuone,noselect,fuzzy,popup"
vim.opt.jumpoptions = "stack"
vim.opt.showmode = false
-- t: cut a long file message ("path" 127L, 2917B) to fit instead of wrapping it
-- into a "Press ENTER" prompt; W: drop the "[w]" suffix on write
vim.opt.shortmess = "aoOtTIcFW"
vim.opt.scrolloff = 2
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

-- built-in commenting: gc in Normal mode toggles the current line (the default gcc, which is dropped);
-- in Visual mode gc stays an operator, in Operator-pending mode a text object
local comment_line = vim.fn.maparg("gcc", "n", false, true).callback
vim.keymap.del("n", "gcc")
vim.keymap.set("n", "gc", comment_line, { expr = true, desc = "Toggle comment line" })

vim.diagnostic.config({
  signs = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_lines = false,
  virtual_text = false,
})

vim.opt.clipboard = "unnamedplus"

if vim.uv.os_uname().sysname == "Darwin" then
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

-- Remove whitespace on save (skip markdown: trailing two spaces are a hard linebreak there)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "markdown" then
      -- keep the last search pattern, jumplist and view intact
      local view = vim.fn.winsaveview()
      vim.cmd([[keeppatterns keepjumps %s/\s\+$//e]])
      vim.fn.winrestview(view)
    end
  end,
})

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

-- Built-in detection maps an empty *.tf to "tf" (TinyFugue) and only switches to
-- "terraform" once the buffer has content, so new files got no highlighting/LSP.
vim.filetype.add({ extension = { tf = "terraform" } })
-- *.tofu has no built-in detection; "opentofu" is what tofu_ls attaches to.
vim.filetype.add({ extension = { tofu = "opentofu" } })

vim.filetype.add({
  pattern = {
    [".*haproxy%.cfg.*"] = "haproxy",
    [".*haproxy.*%.conf"] = "haproxy",
  },
})

-- No built-in detection for nftables
vim.filetype.add({
  extension = { nft = "nftables" },
  filename = { ["nftables.conf"] = "nftables" },
  pattern = {
    -- #!/usr/sbin/nft -f, #!/usr/bin/env nft -f
    [".*"] = {
      function(_, bufnr)
        -- bufnr is nil when matching by filename only (e.g. snacks picker previews)
        if not bufnr then
          return
        end
        local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
        if line:match("^#!%S*/nft%f[%s%z]") or line:match("^#!%S*/env%s+nft%f[%s%z]") then
          return "nftables"
        end
      end,
      { priority = -math.huge },
    },
  },
})
