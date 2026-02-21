--vim.lsp.enable("clangd")
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    --local opts = { buffer = args.buf }
    local opts = { buffer = args.buf, silent = true }
    -- Go to definitions, references, etc.
    opts.desc = "Show LSP references"
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
    
    -- Rename and Actions
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = "LSP Rename", buffer = args.buf })
    vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, { desc = "LSP Code Action", buffer = args.buf })
    
    -- Hover and Signature
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)
  end,
})

