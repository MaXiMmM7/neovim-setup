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
    vim.keymap.set("n", "<leader>grc", "<cmd>FzfLua lgrep_curbuf<cr>", { desc = "Fuzzy live grep current buffer in cwd" });

    -- LSP
    vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua lsp_references<cr>", { desc = "Find LSP references" });
    vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Find LSP definitions" });
    vim.keymap.set("n", "<leader>fD", "<cmd>FzfLua lsp_declarations<cr>", { desc = "Find LSP declarations" });
    vim.keymap.set("n", "<leader>fi", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Find LSP implementations" });
    vim.keymap.set("n", "<leader>ft", "<cmd>FzfLua lsp_typedefs<cr>", { desc = "Find LSP type definitions" });
    vim.keymap.set("n", "<leader>D", "<cmd>FzfLua diagnostics_document<cr>", { desc = "LSP buffer diagnostic" });
  end
}
