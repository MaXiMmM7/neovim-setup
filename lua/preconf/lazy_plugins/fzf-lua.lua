return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {},
    ---@diagnostic enable: missing-fields
    config = function()
        require('fzf-lua')
        -- Find files & buffers
        vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Fuzzy find files in cwd" });
        vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Fuzzy find buffers in cwd" });

        -- grep
        vim.keymap.set("n", "<leader>gr", "<cmd>FzfLua grep<cr>", { desc = "Fuzzy grep project files in cwd" });
        vim.keymap.set("v", "\\gr", "<cmd>FzfLua grep_visual<cr>",
            { desc = "Fuzzy grep files under visual selection in cwd" });
        vim.keymap.set("n", "<leader>cwgr", "<cmd>FzfLua grep_cWORD<cr>",
            { desc = "Search cWORD under cursor" });
        vim.keymap.set("v", "<\\cwgr", "<cmd>FzfLua grep_cWORD<cr>",
            { desc = "Search cWORD under cursor in visual mode" });
        vim.keymap.set("n", "<leader>cbgr", "<cmd>FzfLua grep_curbuf<cr>",
            { desc = "Search in the current buffer" });

        -- LSP
        vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua lsp_references<cr>", { desc = "Find LSP references" });
        vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Find LSP definitions" });
        vim.keymap.set("n", "<leader>fD", "<cmd>FzfLua lsp_declarations<cr>", { desc = "Find LSP declarations" });
        vim.keymap.set("n", "<leader>fi", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Find LSP implementations" });
        vim.keymap.set("n", "<leader>ft", "<cmd>FzfLua lsp_typedefs<cr>", { desc = "Find LSP type definitions" });
        vim.keymap.set("n", "<leader>D", "<cmd>FzfLua diagnostics_document<cr>", { desc = "LSP buffer diagnostic" });

        -- Sessions
        vim.keymap.set("n", "<leader>fs", "<cmd>AutoSession search<cr>", { desc = "Find sessions" });
    end
}
