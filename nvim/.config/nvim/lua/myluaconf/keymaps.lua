local map = vim.api.nvim_set_keymap

map("n", "<leader>co", "<CMD>copen<CR>", {
    noremap = true,
    desc = "Open quick fix list",
})

-- Cnext and Cprev shortcuts from prime
map("n", "<leader>j", "<CMD>cnext<CR>zz", {
    noremap = true,
    desc = "Cnext shortcut and center",
})

map("n", "<leader>k", "<CMD>cprev<CR>zz", {
    noremap = true,
    desc = "Cprev shortcut and center",
})

map("t", "jk", "<C-\\><C-n>", {
    noremap = true,
    desc = "Terminal mode back to normal mode",
})

-- center When going next or previous in search, or when merging with
-- previous line
map(
    "n",
    "n",
    "nzzzv",
    { noremap = true, desc = "Center when going next in search" }
)
map(
    "n",
    "N",
    "Nzzzv",
    { noremap = true, desc = "Center when going previous in search" }
)
map(
    "n",
    "J",
    "mzJ`z",
    { noremap = true, desc = "Center when merging pervious line" }
)

-- Setting Prime's keymaps for moving visual block up & down
map("v", "J", ":m '>+1<CR>gv=gv", {
    noremap = true,
    silent = true,
    desc = "In Visual mode move block down",
})

map("v", "K", ":m '<-2<CR>gv=gv", {
    noremap = true,
    silent = true,
    desc = "In Visual mode move block up",
})

-- another keymap from prime, pastes whats in register, but not clearing what's in register
map("x", "<leader>pr", '"_dP', {
    noremap = true,
    silent = true,
    desc = "replace word under cursor with what's in register, but keep what's in register in place",
})

map("n", "<leader>f", "", {
    noremap = true,
    silent = true,
    callback = vim.lsp.buf.format,
    desc = "format from lsp",
})

map("n", "Q", "@qj", {
    noremap = true,
    silent = true,
    desc = "Play macro @q and go down one line",
})

map("x", "Q", ":norm @q<CR>", {
    noremap = true,
    silent = true,
    desc = "Play macro @q on lines highlighted",
})

vim.keymap.set("n", "<leader>gv", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local current_config = vim.diagnostic.config().virtual_lines or false
    local new_config = not current_config
    vim.diagnostic.config({ virtual_lines = new_config })
    vim.diagnostic.hide(nil, bufnr)
    vim.diagnostic.show(nil, bufnr)
end, { silent = true })
