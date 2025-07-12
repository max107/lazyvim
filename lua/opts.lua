-- map leader to <Space>
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- vim.diagnostic.config({ virtual_text = { current_line = true } })
-- vim.o.winborder = 'single'
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
vim.opt.encoding = "utf-8"
vim.opt.wildignorecase = true
vim.opt.wildignore =
".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/vendor/**,**/bower_modules/**"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.history = 2000
vim.opt.shada = "!,'300,<50,@100,s10,h"
vim.opt.backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim"
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
vim.opt.colorcolumn = "80"
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

local api = vim.api

-- Highlight on yank
local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
    command = "silent! lua vim.highlight.on_yank({higroup='IncSearch', timeout=100})",
    group = yankGrp,
})

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    pattern = "*",
    command = "set cursorline",
    group = cursorGrp,
})
api.nvim_create_autocmd(
    { "InsertEnter", "WinLeave" },
    { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- Remove whitespace on save
api.nvim_create_autocmd("BufWritePre", { command = [[:%s/\s\+$//e]] })

-- Don't auto commenting new lines
api.nvim_create_autocmd("BufEnter", { command = [[set fo-=c fo-=r fo-=o]] })

-- go to last loc when opening a buffer
api.nvim_create_autocmd(
    "BufReadPost",
    { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

-- kill all floating windows
vim.keymap.set("n", "<leader>cc",
    ':lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= "" then vim.api.nvim_win_close(win, false); print("Closing window", win) end end<CR>',
    { remap = false })

api.nvim_create_autocmd({ "FileType" }, {
    pattern = "yaml",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
    end
})

api.nvim_create_autocmd({ "FileType" }, {
    pattern = "scss",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
    end
})

-- Stay in indent mode
local n_opts = { silent = true, noremap = true }
-- Normal mode
vim.keymap.set('n', '<', '<<', n_opts)
vim.keymap.set('n', '>', '>>', n_opts)
-- Visual --
vim.keymap.set("v", "<", "<gv", n_opts)
vim.keymap.set("v", ">", ">gv", n_opts)
-- buffer switch --
vim.keymap.set("n", "gp", ":bprev<cr>", n_opts)
vim.keymap.set("n", "gn", ":bnext<cr>", n_opts)
vim.keymap.set("v", "gp", ":bprev<cr>", n_opts)
vim.keymap.set("v", "gn", ":bnext<cr>", n_opts)

vim.cmd [[
command! W execute ":w"
command! Wq execute ":wq"
command! WQ execute ":wq"
]]

vim.cmd [[autocmd BufNewFile,BufRead *.nomad setfiletype hcl]]
