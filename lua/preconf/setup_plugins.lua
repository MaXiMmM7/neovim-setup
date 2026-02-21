vim.cmd.colorscheme("tokyonight")

-- for auto-session
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

--cmp with lsp connection
local  capabilities = require("blink.cmp").get_lsp_capabilities()
-- used to enable autocompletion (assign to every lsp server config)
vim.lsp.config("*", {
 capabilities = capabilities,
})
