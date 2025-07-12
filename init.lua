local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.cmd([[
autocmd FileType nix setlocal tabstop=2 shiftwidth=2
autocmd FileType graphqls setlocal tabstop=2 shiftwidth=2
autocmd FileType river setlocal tabstop=2 shiftwidth=2
]])

require("opts")
require("lazy").setup("plugins", {
    change_detection = {
        enabled = false,
        notify = false,
    },
    ui = {
        border = "single",
        title = "Lazy",
        title_pos = "left"
    },
    defaults = {
        -- lazy = true
    },
    lockfile = vim.fn.stdpath 'data' .. '/lazy-lock.json', -- hide lockfile away
    performance = {
        rtp = {
            disabled_plugins = {
                'osc52', 'gzip', 'matchit',
                'matchparen', 'netrwPlugin', 'tarPlugin',
                'tohtml', 'tutor', 'zipPlugin', 'spellfile',
                'rplugin', 'editorconfig',
            }
        }
    }
})

