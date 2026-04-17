return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {
            "clangd",
            "neocmake",
            "lua_ls",
            "ty",
            "postgres_lsp",
            "jsonls",
            "yamlls",
            "lemminx",
            "bashls",
        },
        -- zuban and ty for python
    },
    dependencies = {
        { "mason-org/mason.nvim",
            opts = {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    },
                },
            },
        }, 
        "neovim/nvim-lspconfig"
    },
}
