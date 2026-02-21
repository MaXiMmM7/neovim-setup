return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      --mode = "tabs",
      diagnostics = "nvim_lsp",
      numbers = function(opts)
        return string.format('%s', opts.lower(opts.id))
      end,
    },
  },
  }
