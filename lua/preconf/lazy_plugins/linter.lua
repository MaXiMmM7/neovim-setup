return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- xmllint can validate stdin, which keeps XML checks working for unsaved buffers.
    lint.linters.xmllint = {
      cmd = "xmllint",
      stdin = true,
      append_fname = false,
      args = { "--noout", "-" },
      stream = "stderr",
      ignore_exitcode = true,
      parser = function(output)
        local diagnostics = {}

        for _, line in ipairs(vim.split(output, "\n")) do
          local lnum, message = line:match("^%-:(%d+): parser error : (.+)$")

          if lnum and message then
            table.insert(diagnostics, {
              lnum = tonumber(lnum) - 1,
              col = 0,
              message = message,
              severity = vim.diagnostic.severity.ERROR,
              source = "xmllint",
            })
          end
        end

        return diagnostics
      end,
    }

    lint.linters.cppcheck.args = {
      "--enable=warning,style,performance,information",
      function()
        if vim.bo.filetype == "cpp" then
          return "--language=c++"
        else
          return "--language=c"
        end
      end,
      "--suppress=missingIncludeSystem",
      "--inline-suppr",
      "--quiet",
      function()
        if vim.fn.isdirectory("build") == 1 then
          return "--cppcheck-build-dir=build"
        else
          return nil
        end
      end,
      "--template={file}:{line}:{column}: [{id}] {severity}: {message}",
    }

    lint.linters_by_ft = {
      python = { "pylint" },
      cpp = { "cppcheck" },
      c = { "cppcheck" },
      go = { "golangci-lint" },
      rust = { "cargo" },
      json = { "json_tool" },
      yaml = { "yamllint" },
      xml = { "xmllint" },
      xsd = { "xmllint" },
      xsl = { "xmllint" },
      xslt = { "xmllint" },
      svg = { "xmllint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    local function file_in_cwd(file_name)
      return vim.fs.find(file_name, {
        upward = true,
        stop = vim.loop.cwd():match("(.+)/"),
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
        type = "file",
      })[1]
    end

    local function remove_linter(linters, linter_name)
      for k, v in pairs(linters) do
        if v == linter_name then
          linters[k] = nil
          break
        end
      end
    end

    local function linter_in_linters(linters, linter_name)
      for k, v in pairs(linters) do
        if v == linter_name then
          return true
        end
      end
      return false
    end

    local function remove_linter_if_missing_config_file(linters, linter_name, config_file_name)
      if linter_in_linters(linters, linter_name) and not file_in_cwd(config_file_name) then
        remove_linter(linters, linter_name)
      end
    end

    local function try_linting()
      local linters = lint.linters_by_ft[vim.bo.filetype]

      -- if linters then
      --   -- remove_linter_if_missing_config_file(linters, "eslint_d", ".eslintrc.cjs")
      --   remove_linter_if_missing_config_file(linters, "eslint_d", "eslint.config.js")
      -- end

      lint.try_lint(linters)
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        try_linting()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      try_linting()
    end, { desc = "Trigger linting for current file" })
  end,
}
