local M = {}

local function set_opts(opts)
    local comments = opts.comments or {}
    if comments.italic ~= nil then
        vim.g.canvas_comments_italic = comments.italic and true or false
    elseif opts.comments_italic ~= nil then
        vim.g.canvas_comments_italic = opts.comment_italic and true or false
    else
        vim.g.canvas_comments_italic = false
    end

    vim.g.canvas_variant = opts.variant

    if vim.g.colors_name then
        vim.cmd.hi("clear")
    end

    vim.g["colors_name"] = "canvas"
end

function M.setup(opts)
    set_opts(opts or {})
    local groups = require "canvas.groups".setup() or {}

    for group, setting in pairs(groups) do
        vim.api.nvim_set_hl(0, group, setting)
    end
end

vim.api.nvim_create_user_command("CanvasToggle", function() M.toggle() end, {})

return M
