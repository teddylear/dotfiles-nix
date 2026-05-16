return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")

            ts.setup({})

            local group = vim.api.nvim_create_augroup(
                "myluaconf-treesitter-highlight",
                { clear = true }
            )

            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })

            vim.keymap.set("n", "<leader>tc", "<CMD>TSContext toggle<CR>", {
                desc = "Toggle TS Context for parent",
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {},
    },
}
