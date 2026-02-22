vim.keymap.set("n", "<leader>D", "<cmd>FzfLua diagnostics_document<cr>", { desc = "LSP buffer diagnostic" });
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "See available code actions" }) -- see available code actions, in visual mode will apply to selection
vim.keymap.set("n", "<leader>sr", vim.lsp.buf.rename, { desc = "Smart rename" })                             -- smart rename
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })              -- show diagnostics for line
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under cursor" })        -- show documentation for what is under cursor

vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic" }) -- jump to previous diagnostic in buffer
--
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic" }) -- jump to next diagnostic in buffer
