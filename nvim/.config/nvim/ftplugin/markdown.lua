vim.keymap.set(
    "n",
    "<leader>s",
    ":setlocal spell!<CR>",
    { buffer = true, desc = "Toggle spell check" }
)
vim.keymap.set(
    "n",
    "<leader>rd",
    ":RenderMarkdown buf_toggle<CR>",
    { buffer = true, desc = "Toggle RenderMarkdown" }
)
