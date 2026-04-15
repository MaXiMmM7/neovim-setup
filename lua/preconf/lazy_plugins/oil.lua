return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,

    config = function()
        require("oil").setup({
            columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
            },
            view_options = {
                -- Show files and directories that start with "."
                show_hidden = true,
                -- Keep dotfiles visible, but hide the synthetic parent entry.
                is_always_hidden = function(name, _)
                    return name == ".."
                end,
            },
        }
        )
        vim.keymap.set("n", "<leader>-", "<cmd>Oil<cr>", { desc = "Open Oil file explorer" })
    end
}
