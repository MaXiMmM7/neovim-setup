return {
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
    config = function()
        require("treesitter-context").setup({
            enable = true,
            -- any other options you want
        })
    end
}
