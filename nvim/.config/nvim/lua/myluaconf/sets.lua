local homedir = os.getenv("HOME")

vim.g.mapleader = " " -- settings leader key to space

vim.o.syntax = "on"
vim.o.softtabstop = 4
vim.o.termguicolors = true
vim.o.hidden = true
vim.o.scrolloff = 8
vim.o.backup = false

-- Avoid showing message extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false

-- Settings so it doesn't automatically autocomplete
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

vim.opt.autoindent = true
vim.opt.updatetime = 50
vim.opt.winbar = "%=%f"
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.swapfile = false
vim.opt.cmdheight = 2
vim.opt.colorcolumn = { "80" }
vim.opt.signcolumn = "yes"
vim.opt.background = "dark"
vim.opt.incsearch = true
vim.opt.undofile = true

-- set mouse wheel to work
vim.opt.mouse = "a"

vim.opt.undodir = homedir .. "/.vim/undodir"

-- setting clipboard so that copy pasting works
if vim.fn.has("mac") then
    vim.opt.clipboard = "unnamed"
else
    vim.opt.clipboard = "unnamedplus"
end

vim.opt.guicursor = ""

-- Create default mappings for smart comments
vim.cmd("let g:NERDCreateDefaultMappings = 1")

if jit.os == "Linux" then
    vim.cmd('let g:netrw_browsex_viewer = "xdg-open"')
end

-- Add spaces after comment delimiters by default
vim.cmd("let g:NERDSpaceDelims = 1")

-- local python3_host_prog_path = homedir .. "/.pyenv/shims/python"
vim.cmd([[let g:python3_host_prog=$HOME . '/.pyenv/shims/python']])

local function trimWhiteSpace()
    vim.cmd("keeppatterns %s/\\s\\+$//e")
    vim.cmd("call winrestview(winsaveview())")
end

local my_augroup = vim.api.nvim_create_augroup("THE_KENSTER", { clear = true })
vim.api.nvim_create_autocmd(
    "BufWritePre",
    { callback = trimWhiteSpace, group = my_augroup }
)

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*.tf", "*.tfvars" },
    callback = function()
        vim.cmd("setfiletype terraform")
    end,
})

-- Converted this to lua native for autosave current buffer on CursorHold
-- https://github.com/justinmk/config/blob/c3e8dcd8b8e179fd9d3a16572b2d7c9be55c5104/.config/nvim/init.lua#L80
vim.api.nvim_create_autocmd(
    { "BufHidden", "FocusLost", "WinLeave", "CursorHold" },
    {
        group = my_augroup,
        pattern = "*",
        callback = function()
            local buftype =
                vim.api.nvim_get_option_value("buftype", { buf = 0 })
            local filename = vim.api.nvim_buf_get_name(0)
            if buftype == "" and vim.fn.filereadable(filename) == 1 then
                vim.cmd("silent! lockmarks update ++p")
            end
        end,
    }
)

vim.diagnostic.config({
    virtual_lines = true,
})
