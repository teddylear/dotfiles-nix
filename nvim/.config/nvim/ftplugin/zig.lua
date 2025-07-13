vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.zig",
    callback = function()
        vim.cmd("silent! %!zig fmt --stdin")
    end,
})
