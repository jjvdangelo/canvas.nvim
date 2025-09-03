local M = {}

local palettes = {
    ["dark"] = require "canvas.palette-dark",
    ["light"] = require "canvas.palette-light",
}

local function get_vim_background()
    return vim.o.background == "light" and "light" or "dark"
end

M.supported_variants = { "dark", "light" }
M.default_variant = vim.o.background

function M.is_valid_variant(var)
    if not var then
        return false
    end

    for _, value in ipairs(M.supported_variants) do
        if value == var then
            return true
        end
    end

    return false
end

function M.get_variant()
    local v = vim.g.canvas_variant
    if not M.is_valid_variant(v) then
        if not v then
            vim.notify(
                "Invalid variant set for the Canvas colorscheme: '" .. v .. "'",
                vim.log.levels.WARN,
                { title = "groups.lua" }
            )
        end
        vim.g.canvas_variant = get_vim_background()
    end
    return vim.g.canvas_variant
end

function M.load_palette()
    vim.g.colors_name = "canvas"
    local v = M.get_variant()
    local palette = palettes[v]
    return palette or {}
end

function M.toggle()
    local cur = M.get_variant()
    vim.g.canvas_variant = cur == "dark" and "light" or "dark"
    M.load_palette()
end

function M.setup()
    local p = M.load_palette()
    local settings = nil

    local plain = { fg = p.fg, bg = p.bg }
    local yellow = { fg = p.yellow }
    local red = { fg = p.red }
    local accent = { fg = p.accent }
    local keyword = { fg = p.kw }
    local value = { fg = p.value }
    local type = { fg = p.ty }
    local fg = { fg = p.fg }
    local fg_alt = { fg = p.fg_alt, bg = p.bg }
    local bg = { bg = p.bg }
    local bg_alt = { bg = p.bg_alt }
    local bg_yellow = { fg = p.bg, bg = p.yellow }
    local bg_red = { fg = p.bg, bg = p.red }
    local bg_accent = { fg = p.bg, bg = p.accent }
    local bg_subtle = { bg = p.subtle }
    local subtle = { fg = p.subtle, bg = p.bg }

    if p ~= nil then
        settings = {
            Normal = plain,
            NormalNC = fg_alt,
            NormalFloat = bg_alt,
            FloatBorder = { fg = p.subtle, bg = p.bg_alt },
            WinSeparator = { fg = p.border, bg = p.bg },
            EndOfBuffer = bg,

            CursorLine = bg_alt,
            CursorColumn = bg_alt,
            ColorColumn = bg_alt,
            LineNr = subtle,
            CursorLineNr = yellow,
            SignColumn = bg,

            MatchParen = accent,
            Visual = { bg = p.border },
            Search = bg_yellow,
            IncSearch = bg_red,
            Pmenu = bg_alt,
            PmenuSel = bg_accent,
            PmenuSbar = { bg = p.border },
            PmenuThumb = bg_subtle,
            StatusLine = bg_alt,
            StatusLineNC = { fg = p.subtle, bg = p.bg_alt },
            TabLine = { fg = p.subtle, bg = p.bg_alt },
            TabLineSel = bg_accent,
            TabLineFill = bg_alt,

            Italic = { italic = vim.g.canvas_comments_italic },

            Comment = { fg = p.comment, italic = vim.g.canvas_comments_italic, nocombine = true },

            Identifier = fg,
            Function = fg,
            Operator = fg,
            Delimiter = subtle,
            Special = fg,

            Keyword = keyword,
            Statement = keyword,
            Conditional = keyword,
            Repeat = keyword,
            Type = type,

            String = value,
            Number = value,
            Boolean = value,
            Constant = value,
            SpecialChar = value,

            Directory = fg,
            Title = fg,

            DiffAdd = value,
            DiffChange = yellow,
            DiffDelete = red,
            DiffText = accent,

            GitSignsAdd = value,
            GitSignsChange = yellow,
            GitSignsDelete = red,
            diffAdded = value,
            Added = value,
            NeoTreeGitAdded = value,
            NvimTreeGitNew = value,
            MiniDiffSignAdd = value,

            DiagnosticError = red,
            DiagnosticWarn = yellow,
            DiagnosticInfo = accent,
            DiagnosticHint = accent,
            DiagnosticOk = value,

            DiagnosticUnderlineError = { sp = p.red, undercurl = true },
            DiagnosticUnderlineWarn = { sp = p.yellow, undercurl = true },
            DiagnosticUnderlineInfo = { sp = p.accent, undercurl = true },
            DiagnosticUnderlineHint = { sp = p.accent, undercurl = true },

            TelescopeNormal = bg_alt,
            TelescopeBorder = { fg = p.border, bg = p.bg_alt },
            TelescopeSelection = { bg = p.border },
            TelescopeMatching = value,

            LspSignatureActiveParameter = yellow,
            LspReferenceText = { bg = p.border },
            LspReferenceRead = { bg = p.border },
            LspReferenceWrite = { bg = p.border },

            ["@comment"] = { link = "Comment" },
            ["@constructor"] = { link = "Delimiter" },
            ["@method"] = { link = "Function" },
            ["@function"] = { link = "Function" },
            ["@function.builtin"] = { link = "Function" },
            ["@lsp.type.function"] = { link = "Function" },
            ["@lsp.mod.defaultLibrary"] = { link = "Function" },
            ["@lsp.typemod.function.defaultLibrary"] = { link = "Function" },
            ["@keyword"] = { link = "Keyword" },
            ["@conditional"] = { link = "Keyword" },
            ["@repeat"] = { link = "Keyword" },
            ["@operator"] = { link = "Operator" },
            ["@type"] = { link = "Type" },
            ["@property"] = fg,
            ["@field"] = fg,
            ["@variable"] = type,
            ["@variable.builtin"] = type,
            ["@string"] = { link = "String" },
            ["@string.escape"] = value,
            ["@number"] = { link = "Number" },
            ["@boolean"] = { link = "Boolean" },
            ["@constant"] = { link = "Constant" },
            ["@punctuation"] = subtle,
            ["@tag"] = subtle,
            ["@tag.delimiter"] = subtle,

            NonText = subtle,
            Whitespace = subtle,
            SpecialKey = subtle,
            Todo = bg_yellow,
            Error = red,
            WarningMsg = yellow,
            MoreMsg = value,
            Question = accent,
        }
    end

    return settings
end

return M
