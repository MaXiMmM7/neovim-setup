return {
    "ya2s/nvim-cursorline",
    event = { "BufReadPost", "BufNewFile", "BufEnter" },
    opts = {
        cursorline = {
            enable = true,
            timeout = 100,
            number = false,
        },
        cursorword = {
            enabled = true,
            min_length = 2,
        },
    },
}
