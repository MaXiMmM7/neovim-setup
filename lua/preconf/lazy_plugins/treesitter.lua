return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter")
    configs.setup({
      ensure_installed = {
        "c", "cpp", "go", "bash", "lua", "vim", "vimdoc", "elixir", "javascript", "html", "python", "typescript"
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
    -- MODIFY CONFIG
    configs.install({
      "c", "cpp", "go", "bash", "lua", "vim", "vimdoc", "elixir", "javascript", "html", "python", "typescript"
    })
  end
}
