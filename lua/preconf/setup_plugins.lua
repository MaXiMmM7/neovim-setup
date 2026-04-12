vim.cmd.colorscheme("tokyonight")

-- for auto-session
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

--cmp with lsp connection
local capabilities = require("blink.cmp").get_lsp_capabilities()
-- used to enable autocompletion (assign to every lsp server config)
vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.lsp.config("clangd", {
    cmd = {
        "/usr/bin/clangd",
        "--enable-config",
        "--query-driver=/usr/bin/c++,/usr/bin/g++,/usr/bin/x86_64-linux-gnu-g++-*",
    },
    capabilities = capabilities,
})

require("oil").setup()
