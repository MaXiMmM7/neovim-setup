return {
    'stevearc/conform.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                cpp = { "clang-format" },
                cmake = { "gersemi" },
                json = { "jq" },
                lua = { "stylua" },
                markdown = { "mdformat" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- You can customize some of the format options for the filetype (:help conform.format)
                rust = { "rustfmt", lsp_format = "fallback" },
                xml = { "xmllint" },
                yaml = { "yamlfmt" },
                -- Conform will run the first available formatter
                javascript = { "prettierd", "prettier", stop_after_first = true },
            },
            format_on_save = {
                timeout_ms = 2000,
                async = false,
                lsp_fallback = true, -- Use LSP formatting if no conform formatter is found
            },
        })
        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end
}
