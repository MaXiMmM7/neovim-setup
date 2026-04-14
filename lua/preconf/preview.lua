local M = {}

local function is_markdown(name, filetype)
    return filetype == "markdown"
        or name:match("%.md$")
        or name:match("%.markdown$")
end

function M.toggle()
    local name = vim.api.nvim_buf_get_name(0)
    local filetype = vim.bo.filetype

    if is_markdown(name, filetype) then
        vim.cmd("RenderMarkdown buf_toggle")
    end
end

return M
