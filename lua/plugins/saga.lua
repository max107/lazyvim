return {
    {
        "glepnir/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            local saga = require("lspsaga")

            saga.setup({
                outline = {
                    auto_preview = false,
                    keys = {
                        expand_or_jump = "<cr>",
                    },
                },
                finder = {
                    max_height = 0.5,
                    min_width = 30,
                    force_max_height = false,
                    keys = {
                        expand_or_jump = "<cr>",
                    },
                },
            })

            -- Lsp finder find the symbol definition implement reference
            -- if there is no implement it will hide
            -- when you use action in finder like open vsplit then you can
            -- use <C-t> to jump back
            vim.keymap.set("n", "gd", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

            -- Code action
            vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })

            -- Rename
            vim.keymap.set("n", "<leader>gr", "<cmd>Lspsaga rename<CR>", { silent = true })
            vim.keymap.set({ "n", "t" }, "<leader>d", "<cmd>Lspsaga term_toggle<CR>")

            -- Peek Definition
            -- you can edit the definition file in this flaotwindow
            -- also support open/vsplit/etc operation check definition_action_keys
            -- support tagstack C-t jump back
            vim.keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

            -- Show line diagnostics
            vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

            -- Show cursor diagnostics
            vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

            -- Diagnostic jump can use `<c-o>` to jump back
            vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
            vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

            -- Only jump to error
            vim.keymap.set("n", "[D", function()
                require("lspsaga.diagnostic").goto_prev({
                    severity = vim.diagnostic.severity.ERROR,
                })
            end, { silent = true })

            vim.keymap.set("n", "]D", function()
                require("lspsaga.diagnostic").goto_next({
                    severity = vim.diagnostic.severity.ERROR,
                })
            end, { silent = true })

            -- Outline
            -- @todo https://github.com/glepnir/lspsaga.nvim/issues/648
            vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { silent = true })

            -- Call hierarchy
            vim.keymap.set("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
            vim.keymap.set("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

            -- Hover Doc
            vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
            -- api.nvim_create_autocmd("LspAttach", {
            -- 	callback = function(args)
            -- 		keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
            -- 	end,
            -- })

            vim.keymap.set("n", "<F6>", "<cmd>LspInfo<cr>", { silent = true })
        end,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            --Please make sure you install markdown and markdown_inline parser
            { "nvim-treesitter/nvim-treesitter" }
        }
    },
}
