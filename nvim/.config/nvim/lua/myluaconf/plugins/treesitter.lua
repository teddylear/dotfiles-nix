return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")

            -- The rewritten main branch expects an explicit install_dir if you want
            -- its parser/query install location prepended to runtimepath.
            -- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/README.md#setup
            ts.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            local group = vim.api.nvim_create_augroup(
                "myluaconf-treesitter-highlight",
                { clear = true }
            )

            -- On main, highlighting is provided by Neovim and enabled per filetype.
            -- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/README.md#highlighting
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
