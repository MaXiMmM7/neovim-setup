vim.g.mapleader = vim.keycode('<Space>')

vim.keymap.set("n", "<leader>p", function()
    require("preconf.preview").toggle()
end, { desc = "Toggle file preview" })
